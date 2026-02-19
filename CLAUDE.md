# Vibology MacOS Application

## Project Overview

Vibology is a native macOS application that synthesizes five symbolic instruments (Astrology, Human Design, Personal Mythos, Tarot, and The Astrolabe) into a unified framework for consultation sessions and personal exploration. It bridges technical calculation with esoteric wisdom through a client-server architecture.

## Architecture

### Core Technology Stack

| Layer | Component | Implementation |
|-------|-----------|----------------|
| **Calculation** | Headless Engine | Python/FastAPI (Cartographer) on Google Cloud Run with pyswisseph |
| **Research** | The Ephemeris | Obsidian (Markdown) with YAML frontmatter, synced via iCloud |
| **Interface** | Native Client | SwiftUI for macOS with Glassmorphism/Synthwave aesthetics |
| **Database** | Persistent Store | Turso (cloud-hosted libSQL/SQLite) — client data + Ephemeris index |
| **Data Logic** | Bridge | GRDB.swift for reactive, type-safe database management |

### Infrastructure

**Serverless Architecture** — no dedicated file server required:
- **Cartographer** (Google Cloud Run) — calculation engine, scales to zero
- **Turso** — cloud-hosted SQLite, accessible from any Mac anywhere
- **iCloud** — Obsidian vault sync across devices
- **Any Mac** — runs the SwiftUI app; no local server dependencies

**Security:**
- Client data encrypted at rest via Turso (SOC 2 certified)
- Application-layer encryption for any fields requiring additional privacy
- Turso uses the same trust model as Cloud Run — third-party hosted, encrypted

### Real-Time Sync

Obsidian vault syncs to each Mac via iCloud. The app watches the local iCloud
path directly with FSEvents — no watcher service or dedicated server needed.
When a note changes on disk, the app re-queries Turso's index and refreshes.

## Application Logic

### Five-Instrument Integration

The app synthesizes five distinct symbolic lenses:

1. **Astrology** - Planetary timing via Cartographer calculation engine
2. **Human Design** - Mechanical imprinting via pyswisseph
3. **Personal Mythos** - Psychological narrative from Obsidian notes
4. **The Tarot** - Qabalistic archetypes via Correspondence Index
5. **The Astrolabe** - Contemporary oracle resonance (I Ching/Gene Keys)

### Live Session Workflow

1. **Calculation** - Enter birth data → app calls Cartographer (Cloud Run) → receives JSON blueprint
2. **Physical Interaction** - Pull Tarot or Astrolabe cards physically
3. **Digital Retrieval** - Select cards in UI → GRDB joins card ID with Obsidian notes
4. **Synthesis** - Display personal commentary, shadow/gift/siddhi, archetypal stories alongside technical chart

### Professional Features

- **Reporting**: PDFKit renders branded PDF reports combining Blueprint (JSON) + Narrative (Markdown)
- **Search**: FTS5 full-text search across entire esoteric corpus in milliseconds
- **Redundancy**: Turso handles replication and backup automatically

## Data Flow

```
Edit    → Write in Obsidian on any Mac (syncs to iCloud)
Detect  → App watches local iCloud path via FSEvents, detects note changes
Index   → App re-queries Turso index, refreshes Ephemeris view
Consult → App calls Cartographer (Cloud Run) for chart calculations
Secure  → Client session data written to Turso (encrypted at rest, SOC 2)
```

## Documentation Library

**Always read the relevant reference file in `App/Documentation/` before writing code for that technology.** Do not rely solely on training data — these files contain project-specific APIs, confirmed field names, and usage patterns verified against the actual running system.

| File | Use when working on |
|------|-------------------|
| `Cartographer-Reference.md` | Calling the API from Swift; `BlueprintResponse` models; endpoint contracts |
| `SwiftUI-Reference.md` | SwiftUI views, modifiers, layout |
| `SwiftUI-WhatsNew-macOS26.md` | macOS Tahoe / Xcode 26 specific APIs (Liquid Glass, `.icon` format, etc.) |
| `GRDB-Reference.md` | Database queries, migrations, reactive observation |
| `Combine-Reference.md` | Publishers, subscribers, data flow |
| `Turso-libSQL-Reference.md` | Cloud database connection, auth tokens, SQL dialect |
| `Security-Reference.md` | Keychain, encryption, privacy |
| `PDFKit-Reference.md` | PDF report generation |
| `CloudRun-Reference.md` | Deploying / configuring Cartographer |
| `FastAPI-Reference.md` | Modifying Cartographer endpoints |
| `pyswisseph-Reference.md` | Swiss Ephemeris internals |

## Development Guidelines

### Code Organization

- Use SwiftUI's declarative patterns
- Separate concerns: Views, ViewModels, Services, Models
- GRDB for all database interactions (reactive, type-safe)
- Network calls abstracted into services with clear error handling

### Aesthetics

- **Design System**: Glassmorphism + Synthwave — aligns naturally with macOS Tahoe's Liquid Glass material language
- Translucent panels, vibrant gradients, neon accents
- Dark mode optimized; all UI must also be tested in Light and Tinted modes (Tahoe requirement)
- Typography should feel both technical and mystical

### App Icon (macOS Tahoe / Liquid Glass)

**Canonical Brand Assets** (source of truth: `~/Vibology/Branding/`):
- Symbol: `Icon/icon-gradient-1600.svg` — solid gradient-filled dodecahedron, no strokes
- Combined mark: `Logo/logo-header.svg` — symbol + wordmark lockup
- Gradient: Cyan `#9DD8F7` → Lavender `#B8A5E5` → Pearl `#E8F5FF` (vertical, top-to-bottom)

**Icon Architecture (layered)**:
macOS Tahoe uses the `.icon` format (authored in Icon Composer, ships with Xcode 26). Icons are composed of a required background layer plus up to 4 foreground layers:

| Layer | Content | Notes |
|-------|---------|-------|
| Background | Adaptive — not hard-coded navy | Must work across light, dark, and tinted modes |
| Foreground | Dodecahedron gradient silhouette | Apply Liquid Glass material + specular highlights in Icon Composer |

- Do **not** use a fixed `#1a1d2e` navy background — it breaks in Clear Light and Tinted Light modes
- The foreground dodecahedron should use Liquid Glass material (specular highlights are appropriate and expected by the platform)
- The symbol's inter-face white gaps are intentional and part of its identity — Liquid Glass specular highlights along those edges reinforce the faceted crystal aesthetic and are accepted/expected

**Six Appearance Modes** — icon must be verified in all:
1. Default
2. Dark
3. Clear Light
4. Clear Dark
5. Tinted Light
6. Tinted Dark

**File Format**:
- Production: `.icon` folder generated by Icon Composer → compiled to `Assets.car` via `actool`
- Legacy compatibility: also include `.icns` in Resources folder (for pre-Tahoe macOS)
- Set `CFBundleIconName` in app `.plist` to reference the icon asset
- Xcode 26 generates all size variants automatically from the `.icon` file

### Security & Privacy

- Client data stored in Turso — encrypted at rest, SOC 2 certified
- Never log sensitive personal information
- Encrypt sensitive fields at the application layer before writing to Turso
  (birth data, session notes, client identifiers) as a defense-in-depth measure
- Network communication authenticated via Turso auth tokens (stored in Keychain)

### Performance

- Lazy-load Obsidian notes via GRDB queries
- Cache calculation results where appropriate
- Network operations must be asynchronous with proper loading states
- FTS5 queries should be debounced for search-as-you-type

### Testing

- Unit tests for calculation parsing logic
- Integration tests for GRDB database layer
- UI tests for critical flows (chart generation, session workflow)
- Mock network services for offline development

## Key Technologies

### SwiftUI
- Native macOS UI framework
- Declarative, reactive patterns
- Combine for data flow

### GRDB.swift + Turso
- Type-safe SQLite/libSQL wrapper
- Turso's libSQL is wire-compatible with SQLite — GRDB connects via the Turso Swift SDK
- Reactive queries via Combine
- Migration support
- FTS5 for full-text search across Ephemeris index

### Docker + Python/FastAPI (Cartographer)
- Calculation engine isolated in container, deployed to Cloud Run
- REST API for astrology and Human Design calculations
- pyswisseph for Swiss Ephemeris precision
- Endpoints: `/chart/natal`, `/humandesign/calculate`, `/health`
- Deploy: `cd Cartographer && make deploy`

### Turso (libSQL)
- Cloud-hosted SQLite — accessible from any Mac, no local server
- SOC 2 certified, encrypted at rest
- Free tier sufficient for a personal practice
- Auth tokens stored in macOS Keychain

### Obsidian Integration
- YAML frontmatter as metadata source
- Markdown as narrative layer
- File system monitoring for live updates
- Correspondence tables link symbols across systems

## Development Workflow

1. **Local Development**: Code and debug on any Mac
2. **Calculation Testing**: Cartographer is live on Cloud Run; also runnable locally via `uvicorn`
3. **Database Migrations**: Use GRDB migrations against a Turso dev database (separate from production)
4. **UI Design**: Prototype in SwiftUI, reference Synthwave design system
5. **Integration**: Test full flow with real Obsidian vault (iCloud-synced) and Turso dev DB

## File Structure Expectations

```
App/
├── VibologyApp/              # Main SwiftUI app target
│   ├── Views/               # SwiftUI views
│   ├── ViewModels/          # View logic and state
│   ├── Services/            # API clients, file watchers
│   ├── Models/              # Data models
│   ├── Database/            # GRDB setup and queries
│   └── Resources/           # Assets, design tokens
├── Cartographer/             # Python/FastAPI calculation engine (deployed to Cloud Run)
└── Shared/                   # Shared models between components
```

## Related

- **Knowledge Base** - Obsidian vault (The Ephemeris + The Athenaeum), synced via iCloud at `~/Vibology/Knowledge Base`
- **vibology-website** - Public-facing content

## Current Status

Project setup complete. Ready for initial development.

---

*"Anima et Algorithm" - Bridging mystical wisdom with technical precision*
