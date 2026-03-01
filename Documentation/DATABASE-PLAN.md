# Vibology Database Plan

## Overview

One Turso database. Three logical domains:

| Domain | Purpose |
|--------|---------|
| **Athenaeum** | Page-indexed source texts (101 books) — enables citation → PDF navigation |
| **Ephemeris** | Synthesis notes from Obsidian — contextual retrieval by chart element |
| **Client** | Session data, blueprints, entity records |

The Athenaeum and Ephemeris are populated by ingestion scripts maintained in the Knowledge Base repo. The App agent's responsibility is the GRDB migration, Swift models, and query layer. Do not write ingestion scripts — that is handled separately.

Use **embedded replica mode** (Turso's local SQLite mirror). Reads are local and instant; writes sync to the cloud. This gives offline support with zero extra code.

---

## Turso Setup

```bash
# Install Turso CLI
brew install tursodatabase/tap/turso

# Authenticate
turso auth login

# Create the database
turso db create vibology

# Get the connection URL
turso db show vibology --url

# Create an auth token
turso db tokens create vibology
```

Store both values in macOS Keychain — never hardcode them. Retrieve at runtime via the Security framework. See `Security-Reference.md`.

---

## Schema

Implement as GRDB `migrator.registerMigration("v1")`. Full DDL below.

### Athenaeum

```sql
CREATE TABLE athenaeum_sources (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    source_key  TEXT UNIQUE NOT NULL,   -- slug used in citation links, e.g. 'definitive-book-hd'
    title       TEXT NOT NULL,
    instrument  TEXT NOT NULL,          -- 'Human Design' | 'Astrology'
    category    TEXT,                   -- 'Foundations' | 'Rave Cosmology' | 'Differentiation Degree Program - Advanced' | etc.
    pdf_path    TEXT,                   -- absolute path: ~/Vibology/Knowledge Base/The Athenaeum/.../*.pdf
    md_path     TEXT,                   -- absolute path to full.md alongside the PDF
    total_pages INTEGER
);

CREATE TABLE athenaeum_chunks (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    source_id   INTEGER NOT NULL REFERENCES athenaeum_sources(id),
    page_number INTEGER NOT NULL,       -- 1-indexed, maps directly to PDF page
    block_type  TEXT NOT NULL,          -- 'title' | 'paragraph' | 'table' | 'text'
    content     TEXT NOT NULL
);

CREATE INDEX idx_chunks_source ON athenaeum_chunks(source_id, page_number);

CREATE VIRTUAL TABLE athenaeum_fts USING fts5(
    content,
    content='athenaeum_chunks',
    content_rowid='id',
    tokenize='porter unicode61'
);

CREATE TRIGGER athenaeum_ai AFTER INSERT ON athenaeum_chunks BEGIN
    INSERT INTO athenaeum_fts(rowid, content) VALUES (new.id, new.content);
END;
CREATE TRIGGER athenaeum_ad AFTER DELETE ON athenaeum_chunks BEGIN
    INSERT INTO athenaeum_fts(athenaeum_fts, rowid, content) VALUES ('delete', old.id, old.content);
END;
CREATE TRIGGER athenaeum_au AFTER UPDATE ON athenaeum_chunks BEGIN
    INSERT INTO athenaeum_fts(athenaeum_fts, rowid, content) VALUES ('delete', old.id, old.content);
    INSERT INTO athenaeum_fts(rowid, content) VALUES (new.id, new.content);
END;
```

### Ephemeris

```sql
CREATE TABLE ephemeris_notes (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    file_path     TEXT UNIQUE NOT NULL,  -- relative from Knowledge Base root, e.g. 'The Ephemeris/The Instruments/The Astrolabe/The Codex/Family of Earth/02 - The Receptive.md'
    title         TEXT NOT NULL,
    instrument    TEXT NOT NULL,         -- 'Human Design' | 'Astrology' | 'The Tarot' | 'The Astrolabe' | 'Personal Mythos'
    system        TEXT,                  -- from YAML 'system' field
    date_created  TEXT,
    status        TEXT,
    verified      INTEGER DEFAULT 0,     -- 0 = unverified | 1 = source-checked
    content       TEXT NOT NULL,         -- markdown body (frontmatter stripped)
    frontmatter   TEXT NOT NULL          -- full YAML as JSON
);

CREATE TABLE note_tags (
    note_id INTEGER NOT NULL REFERENCES ephemeris_notes(id),
    tag     TEXT NOT NULL,
    PRIMARY KEY (note_id, tag)
);

CREATE INDEX idx_note_tags_tag ON note_tags(tag);

CREATE VIRTUAL TABLE ephemeris_fts USING fts5(
    content,
    content='ephemeris_notes',
    content_rowid='id',
    tokenize='porter unicode61'
);

CREATE TRIGGER ephemeris_ai AFTER INSERT ON ephemeris_notes BEGIN
    INSERT INTO ephemeris_fts(rowid, content) VALUES (new.id, new.content);
END;
CREATE TRIGGER ephemeris_ad AFTER DELETE ON ephemeris_notes BEGIN
    INSERT INTO ephemeris_fts(ephemeris_fts, rowid, content) VALUES ('delete', old.id, old.content);
END;
CREATE TRIGGER ephemeris_au AFTER UPDATE ON ephemeris_notes BEGIN
    INSERT INTO ephemeris_fts(ephemeris_fts, rowid, content) VALUES ('delete', old.id, old.content);
    INSERT INTO ephemeris_fts(rowid, content) VALUES (new.id, new.content);
END;
```

### Citations

The link between Ephemeris synthesis and Athenaeum source pages. Populated during the KB verification pass — `page_number` starts NULL and is filled in once each citation is checked against source material.

```sql
CREATE TABLE citations (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    note_id       INTEGER NOT NULL REFERENCES ephemeris_notes(id),
    footnote_key  TEXT NOT NULL,         -- '1', '2', '3' — matches [^1] [^2] [^3] in markdown
    source_key    TEXT NOT NULL,         -- matches athenaeum_sources.source_key
    page_number   INTEGER,               -- NULL until verified; set during KB verification pass
    description   TEXT,                  -- citation text as written in the footnote
    verified      INTEGER DEFAULT 0
);

CREATE INDEX idx_citations_note   ON citations(note_id);
CREATE INDEX idx_citations_source ON citations(source_key, page_number);
```

### Client Data

```sql
CREATE TABLE clients (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    entity_id        TEXT UNIQUE NOT NULL,  -- privacy-safe identifier, never full name
    birth_date       TEXT,                  -- encrypt before write; see Security-Reference.md
    birth_time       TEXT,
    birth_location   TEXT,
    blueprint        TEXT,                  -- JSON blob from Cartographer response
    created_at       TEXT DEFAULT (datetime('now')),
    updated_at       TEXT DEFAULT (datetime('now'))
);

CREATE TABLE sessions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id    INTEGER REFERENCES clients(id),
    session_date TEXT,
    notes        TEXT,
    cards_drawn  TEXT,                      -- JSON array of card identifiers
    created_at   TEXT DEFAULT (datetime('now'))
);
```

---

## Key Query Patterns

### Contextual retrieval by chart element

The primary app pattern: given a parsed Cartographer blueprint, fetch Ephemeris notes relevant to the client's chart.

```swift
// Single element — e.g. Gate 34 defined in chart
let notes = try conn.query("""
    SELECT DISTINCT n.id, n.title, n.instrument, n.system, n.verified
    FROM ephemeris_notes n
    JOIN note_tags t ON t.note_id = n.id
    WHERE t.tag = ?
    ORDER BY n.instrument, n.title
""", ["gate-34"])

// Multiple elements at once (full chart load)
let placeholders = tags.map { _ in "?" }.joined(separator: ", ")
let chartNotes = try conn.query("""
    SELECT DISTINCT n.id, n.title, n.instrument, n.system
    FROM ephemeris_notes n
    JOIN note_tags t ON t.note_id = n.id
    WHERE t.tag IN (\(placeholders))
    ORDER BY n.instrument, n.title
""", tags)
```

Tag convention established by the ingestion script (drawn from YAML `tags:` arrays):
- Gates: `gate-1` through `gate-64`
- Channels: `channel-34-57`, `channel-6-59`, etc.
- Centers: `sacral-center`, `solar-plexus-center`, `g-center`, etc.
- Types: `generator`, `projector`, `manifestor`, `reflector`
- Authorities: `emotional-authority`, `sacral-authority`, `splenic-authority`, etc.
- Profiles: `profile-4-6`, `profile-1-3`, etc.
- Instruments: `human-design`, `astrology`, `the-tarot`, `the-astrolabe`, `personal-mythos`
- Hexagrams/Gates (Astrolabe): `hexagram-2`, `gate-2`, `family-of-earth`
- Planets: `saturn`, `neptune`, `jupiter`, etc.

### FTS search across Ephemeris

```swift
let results = try conn.query("""
    SELECT n.id, n.title, n.instrument,
           snippet(ephemeris_fts, 0, '<em>', '</em>', '…', 25) AS excerpt
    FROM ephemeris_fts
    JOIN ephemeris_notes n ON n.id = ephemeris_fts.rowid
    WHERE ephemeris_fts MATCH ?
    ORDER BY bm25(ephemeris_fts)
    LIMIT 20
""", [searchQuery])
```

### Citation → PDF page lookup

Called when the user taps a footnote in an Ephemeris note view.

```swift
let hit = try conn.query("""
    SELECT c.page_number, c.description, s.pdf_path, s.title
    FROM citations c
    JOIN athenaeum_sources s ON s.source_key = c.source_key
    WHERE c.note_id = ? AND c.footnote_key = ?
""", [noteId, footnoteKey])
```

If `page_number` is non-null, open the PDF at that page. If null (not yet verified), fall back to FTS search in Athenaeum using the description text and present a results list.

### FTS search across Athenaeum source texts

Used for the source verification viewer and as the citation fallback.

```swift
let hits = try conn.query("""
    SELECT s.title, s.source_key, s.pdf_path,
           c.page_number, c.block_type,
           snippet(athenaeum_fts, 0, '<em>', '</em>', '…', 30) AS excerpt
    FROM athenaeum_fts
    JOIN athenaeum_chunks c  ON c.id = athenaeum_fts.rowid
    JOIN athenaeum_sources s ON s.id = c.source_id
    WHERE athenaeum_fts MATCH ?
    ORDER BY bm25(athenaeum_fts)
    LIMIT 20
""", [searchQuery])
```

---

## Citation → PDFKit Navigation

```swift
import PDFKit

func openPDF(at pdfPath: String, page pageNumber: Int) {
    guard let document = PDFDocument(url: URL(fileURLWithPath: pdfPath)),
          let page = document.page(at: pageNumber - 1)  // PDFKit is 0-indexed
    else { return }

    pdfView.document = document
    pdfView.go(to: page)
}
```

Present in a secondary panel or sheet alongside the Ephemeris note — side-by-side synthesis and source.

PDF files resolve via `pdf_path` in `athenaeum_sources`. Paths are absolute and reference the local iCloud sync location: `~/Vibology/Knowledge Base/The Athenaeum/...`. At runtime, expand `~` to `NSHomeDirectory()`.

---

## Connection Setup (Swift)

See `Turso-libSQL-Reference.md` for full SDK details. Embedded replica mode is required — do not use remote-only mode.

```swift
import Libsql

let db = try Database(
    path: applicationSupportDirectory + "/vibology-replica.db",
    url: keychainValue(for: "TURSO_DATABASE_URL"),
    authToken: keychainValue(for: "TURSO_AUTH_TOKEN")
)
let conn = try db.connect()
```

The local replica means all reads hit local SQLite. Sync happens on connect and after writes.

---

## What the Ingestion Scripts Provide

The Knowledge Base agent maintains two Python scripts (not in this repo):

- **`build_athenaeum.py`** — walks `The Athenaeum/`, parses each `content_list_v2.json`, writes `athenaeum_sources` + `athenaeum_chunks` rows, populates `athenaeum_fts`. Run whenever new MinerU extractions are added.
- **`build_ephemeris.py`** — walks `The Ephemeris/`, parses YAML frontmatter + markdown body, writes `ephemeris_notes` + `note_tags`, extracts footnotes into `citations`. Run whenever Ephemeris notes change significantly.

The App agent does not run these scripts. Expect the database to be populated before integration testing begins.

**`source_key` convention** (Athenaeum slugs used in `citations.source_key`):

| Title | source_key |
|-------|-----------|
| The Definitive Book of Human Design | `definitive-book-hd` |
| The Complete Rave I'Ching | `complete-rave-iching` |
| Rave I'Ching Line Companion | `rave-iching-line-companion` |
| The Gene Keys | `gene-keys-rudd` |
| The Book of Destinies | `book-of-destinies` |
| The Book of Lines | `book-of-lines` |
| Alfred Huang — The Complete I'Ching | `complete-iching-huang` |
| Richard Wilhelm — The I'Ching or Book of Changes | `iching-wilhelm` |
| Hellenistic Astrology (Part 1) | `hellenistic-astrology-brennan-1` |
| Hellenistic Astrology (Part 2) | `hellenistic-astrology-brennan-2` |
| Tetrabiblos | `tetrabiblos-ptolemy` |
| Saturn: A New Look at an Old Devil | `saturn-greene` |
| The Astrology of Fate | `astrology-of-fate-greene` |
| The Astrological Neptune (Part 1) | `neptune-greene-1` |
| The Astrological Neptune (Part 2) | `neptune-greene-2` |
| Jung's Studies in Astrology | `jungs-studies-astrology-greene` |
| Valens Anthologies Annotated (Part 1) | `valens-anthologies-1` |
| Valens Anthologies Annotated (Part 2) | `valens-anthologies-2` |
| Christian Astrology Vol. 1 | `christian-astrology-lilly-1` |
| Christian Astrology Vol. 2 | `christian-astrology-lilly-2` |
| Christian Astrology Vol. 3 | `christian-astrology-lilly-3` |

Remaining HD source keys follow the same `kebab-case-short-title` pattern. Full list available once ingestion scripts are finalized.
