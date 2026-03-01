# Vibology macOS App — Comprehensive Build Plan

## Context

Cartographer is deployed and healthy on Cloud Run (`https://cartographer-273583413962.us-central1.run.app`), running Skyfield/JPL DE440s (MIT licensed — no AGPL obligations). The database schema is finalized in `DATABASE-PLAN.md`. No Swift code exists yet. This plan covers standing up the full Xcode project and implementing Phase 1: the client hub, blueprint calculation, Ephemeris retrieval, and the GRDB/Turso database layer.

**Chart rendering decision:** Server-side image generation has been removed from Cartographer. All chart visualization will be built natively in SwiftUI using Canvas — the HD Bodygraph and Astrology Wheel will be rendered directly in the app. No web chart renderer is planned. The app is the design reference; a JS port may follow once the native design is proven.

---

## Phase 1 Scope

| Feature | Included |
|---------|----------|
| Client hub (add/view clients + Ephemeris browser) | ✅ |
| Blueprint calculation (Cartographer → chart display) | ✅ |
| HD Bodygraph renderer (SwiftUI Canvas) | ✅ |
| Astrology Wheel renderer (SwiftUI Canvas) | ✅ |
| Ephemeris retrieval (tag-based note lookup from chart) | ✅ |
| Client + session persistence (GRDB + Turso) | ✅ |
| Apple Intelligence — session synthesis generation | ✅ |
| Tarot/Astrolabe card selection UI | ❌ Phase 2 |
| PDF report generation | ❌ Phase 2 |

---

## Step 1 — Xcode Project Setup

**Action:** Create a new macOS App target in Xcode 26.

- Product name: `Vibology`
- Bundle ID: `com.vibology.app`
- Interface: SwiftUI
- Language: Swift
- Minimum deployment: macOS 26
- Location: `App/VibologyApp/`

**SPM Dependencies** (add via Xcode → Add Package):

| Package | URL | Purpose |
|---------|-----|---------|
| GRDB.swift | `https://github.com/groue/GRDB.swift` | Type-safe SQLite, migrations, FTS5, reactive observation |
| libsql-swift | `https://github.com/tursodatabase/libsql-swift` | Turso embedded replica sync |

**App icon:** Set `CFBundleIconName` to reference `Vibology.icon` already in `App/Icon/`.

**Folder structure inside `VibologyApp/`:**
```
VibologyApp/
├── App/                     # Entry point, app delegate
├── Views/
│   ├── Hub/                 # Main hub layout
│   ├── Clients/             # Client list, detail, add form
│   ├── Ephemeris/           # Note browser, search, detail
│   └── Blueprint/           # Chart display (astrology + HD)
├── ViewModels/
├── Services/
├── Models/
├── Database/
└── Resources/
```

---

## Step 2 — Keychain Service

**File:** `Services/KeychainService.swift`

Thin wrapper around the Security framework. Stores and retrieves two values:
- `TURSO_DATABASE_URL`
- `TURSO_AUTH_TOKEN`

On first launch (values absent), the app presents a one-time `SetupSheet` prompting for these values. Once saved they persist across launches. Referenced pattern: `Documentation/Security-Reference.md`.

---

## Step 3 — Database Layer

### 3a. Turso Sync Manager

**File:** `Database/TursoSyncManager.swift`

Wraps `Libsql.Database` in embedded replica mode:

```swift
let db = try Database(
    path: applicationSupportDirectory + "/vibology-replica.db",
    url: keychainValue(for: "TURSO_DATABASE_URL"),
    authToken: keychainValue(for: "TURSO_AUTH_TOKEN")
)
let conn = try db.connect()
```

Exposes a `sync()` method called on `NSApplicationDidBecomeActiveNotification` (app foreground). Reads are always local; writes sync to Turso cloud.

### 3b. GRDB Database Manager

**File:** `Database/DatabaseManager.swift`

Opens a `DatabasePool` on the same local replica file path (after Turso has synced). All reads and writes go through GRDB; Turso handles cloud sync separately.

```swift
let dbPool = try DatabasePool(path: replicaPath)
```

### 3c. Migrations

**File:** `Database/Migrations.swift`

One migration `"v1"` implementing the full schema from `DATABASE-PLAN.md`.

**Athenaeum domain:**
- `athenaeum_sources` — source text catalogue
- `athenaeum_chunks` — page-level content blocks
- `athenaeum_fts` — FTS5 virtual table (porter + unicode61 tokenizer) with AI/AD/AU triggers

**Ephemeris domain:**
- `ephemeris_notes` — synthesis notes (markdown body + frontmatter as JSON)
- `note_tags` — junction table enabling tag-based chart retrieval
- `ephemeris_fts` — FTS5 virtual table with triggers
- `citations` — footnote links from notes to Athenaeum source pages

**Client domain:**
- `clients` — entity records (birth data encrypted before write)
- `sessions` — session records with blueprint JSON blob and `cards_drawn` JSON array

All indexes as specified in `DATABASE-PLAN.md`.

---

## Step 4 — Swift Models

### 4a. Database Records

**File:** `Models/DatabaseModels.swift`

Each type conforms to `Codable + FetchableRecord + PersistableRecord + Identifiable`.

```swift
struct Client: Codable, FetchableRecord, MutablePersistableRecord, Identifiable
struct Session: Codable, FetchableRecord, MutablePersistableRecord, Identifiable
struct EphemerisNote: Codable, FetchableRecord, Identifiable
struct NoteTag: Codable, FetchableRecord, PersistableRecord
struct Citation: Codable, FetchableRecord, Identifiable
struct AthenaeumsSource: Codable, FetchableRecord, Identifiable
struct AthenaeumsChunk: Codable, FetchableRecord, Identifiable
```

### 4b. Cartographer Response Models

**File:** `Models/BlueprintModels.swift`

Decoded with `.convertFromSnakeCase`. All field names drawn from `Documentation/Cartographer-Reference.md`.

```swift
struct BlueprintRequest: Encodable
struct BlueprintResponse: Decodable {
    let meta: BlueprintMeta
    let astrology: AstrologyData
    let humanDesign: HumanDesignData
}
struct AstrologyData: Decodable {
    let planets: [String: PlanetData]
    let houses: [String: Double]
    let aspects: [AspectData]
    let lunarPhase: LunarPhase
    let elements: [String: Int]
    let modalities: [String: Int]
}
struct HumanDesignData: Decodable {
    let type: HDType
    let authority: HDAuthority
    let profile: HDProfile
    let definition: HDDefinition
    let variables: HDVariables
    let planets: HDPlanets
    let channels: [String]
}
```

---

## Step 5 — Services

### 5a. CartographerService

**File:** `Services/CartographerService.swift`

```swift
func fetchBlueprint(_ request: BlueprintRequest) async throws -> BlueprintResponse
```

- Base URL: `https://cartographer-273583413962.us-central1.run.app`
- Endpoint: `POST /blueprint`
- Decodes with `.convertFromSnakeCase`
- Typed errors: `.networkError`, `.decodingError`, `.serverError(Int)`

### 5b. EphemerisService

**File:** `Services/EphemerisService.swift`

Two methods backed by GRDB:

1. **Tag-based retrieval** — given an array of chart tags derived from a `BlueprintResponse`, returns matching `EphemerisNote` records via the `note_tags` join. Uses the multi-tag `IN (?)` pattern from `DATABASE-PLAN.md`.

2. **FTS search** — given a query string, returns ranked results with `snippet()` excerpts from `ephemeris_fts`.

A pure function `tagsFromBlueprint(_ response: BlueprintResponse) -> [String]` transforms HD gates, channels, type, authority, profile, and astrology planets into the kebab-case tag convention documented in `DATABASE-PLAN.md`.

### 5c. ClientService

**File:** `Services/ClientService.swift`

CRUD for `Client` and `Session` records:

```swift
func fetchAllClients() -> [Client]
func saveClient(_ client: Client) throws
func deleteClient(id: Int) throws
func fetchSessions(for clientId: Int) -> [Session]
func saveSession(_ session: Session) throws
```

Encrypts `birth_date`, `birth_time`, and `birth_location` before write using the pattern in `Documentation/Security-Reference.md`. Decrypts transparently on read.

---

## Step 6 — ViewModels

**`ViewModels/HubViewModel.swift`**
- Holds client list via `ValueObservation` (reactive, auto-updates on DB change)
- Exposes search text binding for Ephemeris FTS
- Selected client ID drives the detail panel

**`ViewModels/ClientDetailViewModel.swift`**
- Calls `CartographerService.fetchBlueprint()` for the selected client
- Calls `EphemerisService` with tags derived from the blueprint
- Manages `.idle / .loading / .loaded(BlueprintResponse) / .error` state

**`ViewModels/EphemerisViewModel.swift`**
- FTS search state with 300ms debounce
- Instrument filter: All / Human Design / Astrology / The Tarot / The Astrolabe / Personal Mythos

---

## Step 7 — Views

### 7a. App Entry Point

**File:** `App/VibologyApp.swift`

`@main` struct with `WindowGroup` → `HubView`. On launch:
1. Check Keychain for Turso credentials
2. If absent → present `SetupSheet` (blocks navigation until complete)
3. If present → open `HubView` and call `TursoSyncManager.sync()`

### 7b. Hub Layout

**File:** `Views/Hub/HubView.swift`

`NavigationSplitView` with three columns:

| Column | Content |
|--------|---------|
| Sidebar | Two sections: **Clients** (list) and **Ephemeris** (instrument filter) |
| Content | Client list or Ephemeris note list depending on sidebar selection |
| Detail | Client blueprint view or Ephemeris note reader |

Aesthetics: `.glass` button style, translucent panel backgrounds, cyan/lavender Synthwave accent colors.

### 7c. Client Views

**`Views/Clients/ClientListView.swift`** — scrollable list with add button and search field.

**`Views/Clients/AddClientView.swift`** — sheet form: name, birth date, birth time (optional), birth location. Save triggers `ClientService.saveClient()`.

**`Views/Clients/ClientDetailView.swift`** — client info header + "Generate Blueprint" button. On generate: calls Cartographer and passes result to `BlueprintView`.

### 7d. Blueprint View

**File:** `Views/Blueprint/BlueprintView.swift`

Five tabs:

| Tab | Content |
|-----|---------|
| Astrology Wheel | SwiftUI Canvas chart — zodiac ring, house divisions, planet glyphs, aspect lines |
| Astrology Data | Planet list (sign, house, retrograde flag), lunar phase, elements/modalities breakdown |
| HD Bodygraph | SwiftUI Canvas chart — nine centers, channels, defined/undefined coloring |
| Human Design Data | Type, authority, profile, defined/undefined centers, channels list |
| Ephemeris | Ephemeris notes relevant to this chart, grouped by instrument |

Loading state shows a progress indicator while the Cartographer call is in flight. Chart tabs render from the decoded `BlueprintResponse` using the native SwiftUI Canvas renderers built in Step 9.

### 7e. Ephemeris Views

**`Views/Ephemeris/EphemerisListView.swift`** — filterable by instrument, FTS search bar, grouped results.

**`Views/Ephemeris/EphemerisNoteView.swift`** — full markdown render of note body. Footnote taps trigger citation lookup → open PDF at page via PDFKit (or fall back to Athenaeum FTS if page not yet verified).

### 7f. Setup Sheet

**File:** `Views/Hub/SetupSheet.swift`

Shown once on first launch. Two `SecureField` inputs for Turso URL and auth token. Not dismissible until both values are saved to Keychain and a sync succeeds.

---

## Step 8 — SwiftUI Chart Renderers

All chart rendering is done natively in SwiftUI using `Canvas` and `Path`. The design aesthetic is Glassmorphism/Synthwave — dark backgrounds, translucent panels, cyan/lavender palette, neon glyph highlights.

### 8a. HD Bodygraph Renderer

**File:** `Views/Blueprint/BodygraphView.swift`

Renders the Human Design Bodygraph from `HumanDesignData`:

- **Nine centers** drawn as geometric shapes (Head/Ajna = triangle, Throat = square, G-Center = diamond, Heart = triangle, Solar Plexus = triangle, Sacral = square, Spleen = triangle, Root = square, ESP = triangle) at fixed positions on a normalized coordinate grid
- **Defined centers** filled with Synthwave cyan/magenta gradient; **undefined** centers outlined only (semi-transparent stroke)
- **Channels** drawn as thick lines connecting center pairs; **active channels** use a solid neon cyan stroke; **undefined** channels use a subtle dimmed line
- **Gate labels**: small glyphs at each gate position along channels (64 positions, one per hexagram)
- **Type color accent**: line color varies by HD type (Generator = magenta, Projector = yellow, Manifestor = red, Reflector = silver)

Implementation pattern:
```swift
struct BodygraphView: View {
    let data: HumanDesignData
    var body: some View {
        Canvas { context, size in
            let scale = min(size.width, size.height)
            // Draw centers, channels, gate numbers from data
        }
        .aspectRatio(0.75, contentMode: .fit) // Standard bodygraph proportions
    }
}
```

The center positions and channel-to-center mapping constants belong in a separate `BodygraphLayout.swift` struct (static geometry, no state).

### 8b. Astrology Wheel Renderer

**File:** `Views/Blueprint/AstrologyWheelView.swift`

Renders the classic natal chart wheel from `AstrologyData`:

- **Outer ring**: 12 zodiac sign segments (30° each), labeled with sign glyphs, Synthwave gradient fill per element (fire = magenta, earth = amber, air = cyan, water = indigo)
- **House divisions**: 12 radial lines from inner to outer ring based on `houses` cusp longitudes, house numbers in the inner ring
- **Planet glyphs**: symbol placed at correct ecliptic longitude on the planet ring; retrograde planets marked with `℞`
- **Aspect lines**: drawn across the center of the wheel; line style varies by aspect type (conjunction = solid white, trine = solid cyan, square = dashed red, opposition = solid red, sextile = dashed cyan); opacity proportional to closeness of orb
- **Ascendant marker**: prominent tick at ASC cusp with "ASC" label

Implementation pattern:
```swift
struct AstrologyWheelView: View {
    let data: AstrologyData
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 * 0.9
            // Draw rings, houses, planets, aspects
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
```

Glyph lookup table (Unicode symbols for planets and signs) belongs in `AstrologyGlyphs.swift`.

---

## Step 10 — Reactive Data Flow

```
DB Write
  → GRDB ValueObservation fires
  → ViewModel @Published updates
  → SwiftUI re-renders

App Foreground
  → TursoSyncManager.sync()
  → local replica updated
  → next observation fires

Cartographer call
  → async/await
  → ViewModel state: .loading → .loaded(BlueprintResponse)
  → BlueprintView renders
```

`ValueObservation.publisher(in: dbPool)` piped into `@Published` properties on ViewModels via Combine. Search text uses `debounce(for: .milliseconds(300))` before triggering FTS query.

---

## Implementation Order

| # | Task |
|---|------|
| 1 | Xcode project + SPM dependencies |
| 2 | KeychainService |
| 3 | TursoSyncManager + DatabaseManager + Migrations (v1) |
| 4 | DatabaseModels + BlueprintModels |
| 5 | CartographerService (verify against live URL) |
| 6 | ClientService + EphemerisService |
| 7 | ViewModels |
| 8 | BodygraphView + AstrologyWheelView (SwiftUI Canvas chart renderers) |
| 9 | SetupSheet → HubView → ClientListView → AddClientView → ClientDetailView → BlueprintView → EphemerisListView → EphemerisNoteView |

---

## Verification

- **Unit tests:** `CartographerService` against live Cloud Run URL with a known birth dataset; assert all top-level fields present on `BlueprintResponse`.
- **DB tests:** Run migrations against an in-memory GRDB pool; assert all tables and FTS virtual tables created; insert a client, fetch it back.
- **Integration:** Add a client → generate blueprint → confirm Ephemeris tab populates with relevant notes.
- **Sync:** Write a client record, call `TursoSyncManager.sync()`, confirm record visible in Turso dashboard.

---

---

## Apple Intelligence — Session Synthesis

> **Requirement:** Apple Silicon Mac + macOS 26 + Apple Intelligence enabled. The framework is a system API — no SPM package needed.

### What It Does

A **"Generate Synthesis"** button on the Blueprint view feeds the client's chart and relevant Ephemeris notes to the on-device Foundation Models LLM. The model returns a structured `SessionSynthesis` — five named sections weaving together the astrological, Human Design, and Ephemeris layers into a session-ready narrative. Fully on-device, private, free, offline-capable.

Writing Tools are automatically available in any `TextEditor` (session notes field) with no code required — rewrite, proofread, and summarize come for free.

---

### Token Budget Analysis

The 4096 combined token limit (input + output) requires careful distillation. Here is the exact budget:

**Why not send the raw `BlueprintResponse`:**

| Section | Raw tokens (est.) |
|---------|-------------------|
| Meta | ~80 |
| 12 astrology planets (sign, house, longitude, speed, retrograde) | ~240 |
| 12 house cusps (floating point) | ~60 |
| 40–60 aspects × ~15 tokens each | ~600–900 |
| Lunar phase | ~20 |
| Elements + modalities | ~30 |
| HD type, authority, profile, definition | ~110 |
| HD variables (4 arrows) | ~20 |
| HD planets — personality + design (26 entries × ~15 tokens) | ~390 |
| HD channels (4–6 entries × ~25 tokens) | ~120 |
| **Total raw blueprint** | **~1670–2070** |

Sending the full response leaves only ~2000–2400 tokens for notes, system prompt, and output. That is not enough for meaningful note content.

**Distilled `BlueprintSummary` (~400 tokens):**

Strip everything the model cannot interpret symbolically — raw longitudes, house cusps, aspect lists with tight orbs, HD variables, all HD planet detail except the Sun/Earth gates. Keep only the interpretive layer:

| Element | Tokens (est.) |
|---------|---------------|
| Name + birth date | ~15 |
| HD Type, strategy, signature, not-self | ~35 |
| HD Authority | ~10 |
| HD Profile + Incarnation Cross | ~20 |
| HD Definition type + defined centers | ~30 |
| HD Active channels (full descriptive names) | ~100 |
| Personality Sun gate.line + Design Sun gate.line | ~20 |
| Astrology Sun, Moon, Rising + Mercury, Venus, Mars (sign + house) | ~60 |
| Dominant element + modality | ~15 |
| Lunar phase name | ~10 |
| Key aspects (orb < 3°, major only: conjunction, opposition, trine, square) | ~50 |
| **Total distilled blueprint** | **~365–415** |

Savings over raw: **~1300–1600 tokens freed up.**

**Ephemeris note excerpts (~700 tokens for 5 notes):**

Do not send full note content. Send: title + instrument + first ~100 words of the markdown body (~140 tokens per note × 5 notes = ~700 tokens).

**Final token budget:**

| Component | Tokens |
|-----------|--------|
| System prompt | ~200 |
| Distilled blueprint | ~400 |
| 5 Ephemeris note excerpts | ~700 |
| Instruction line | ~50 |
| **Total input** | **~1350** |
| Output (`SessionSynthesis`, 5 sections) | ~700 |
| **Grand total** | **~2050** |

Headroom: ~2046 tokens. This means up to 10 notes could be included if the chart yields many strong matches, or excerpts extended to 200 words.

---

### Note Retrieval

Note selection is handled dynamically by the model via `EphemerisSearchTool` rather than hard-coded priority logic. The system instructions direct the model to look up HD type, authority, profile, active channels, Personality Sun gate, Design Sun gate, and dominant astrological placements — the model decides what to query and how many results to request per lookup.

---

### Implementation

**New file:** `Models/BlueprintSummary.swift`

A pure transformation — no networking, no I/O. Takes a `BlueprintResponse` and produces a formatted string for the prompt:

```swift
struct BlueprintSummary {
    init(_ response: BlueprintResponse) { ... }
    func formatted() -> String {
        """
        HUMAN DESIGN
        Type: \(hdType) — \(strategy) | Signature: \(signature) | Not-Self: \(notSelf)
        Authority: \(authority)
        Profile: \(profile) | Cross: \(incarnationCross)
        Definition: \(definitionType) | Defined Centers: \(definedCenters.joined(separator: ", "))
        Active Channels: \(channels.joined(separator: "; "))
        Personality Sun: Gate \(personalitySunGate).\(personalitySunLine)
        Design Sun: Gate \(designSunGate).\(designSunLine)

        ASTROLOGY
        Sun: \(sunSign) H\(sunHouse) | Moon: \(moonSign) H\(moonHouse) | Rising: \(ascSign)
        Mercury: \(mercurySign) | Venus: \(venusSign) | Mars: \(marsSign)
        Dominant Element: \(dominantElement) | Modality: \(dominantModality)
        Lunar Phase: \(lunarPhaseName)
        Key Aspects: \(keyAspects)
        """
    }
}
```

`keyAspects` filters `astrology.aspects` to orb < 3°, major aspect types only, formatted as `"Sun conjunct Node (0.8°)"`.

---

**New file:** `Models/SessionSynthesis.swift`

Structured output type for guided generation:

```swift
import FoundationModels

@Generable
struct SessionSynthesis {
    @Guide(description: "2–3 sentence portrait weaving together HD type, authority, and key astrological placements.")
    let coreTheme: String

    @Guide(description: "How this person's type, strategy, and authority shape their decision-making and relationships.")
    let humanDesignInsight: String

    @Guide(description: "Dominant astrological signature: element balance, most powerful placements, lunar quality.")
    let astrologicalTheme: String

    @Guide(description: "How the Ephemeris notes illuminate this chart — what resonates, what tensions exist, what is activated.")
    let ephemerisResonance: String

    @Guide(description: "One concrete focus for this consultation session.")
    let sessionFocus: String
}
```

---

**New file:** `Services/SynthesisService.swift`

Two types: `EphemerisSearchTool` (called by the model to look up notes on demand) and `SynthesisService` (session manager).

```swift
import FoundationModels

// The model calls this tool to retrieve Ephemeris notes during synthesis.
// It may call it multiple times for different symbols.
struct EphemerisSearchTool: Tool {
    let description = """
        Search the Ephemeris for notes relevant to a symbol, planet, sign, HD gate, \
        channel, or archetype. Call multiple times for different symbols.
        """

    @Generable
    struct Arguments {
        @Guide(description: "Search query — a planet, sign, HD gate number, archetype, or theme")
        var query: String

        @Guide(description: "Maximum results to return", .range(1...5))
        var limit: Int
    }

    let ephemerisService: EphemerisService

    func call(arguments: Arguments) async throws -> String {
        let notes = try ephemerisService.search(arguments.query, limit: arguments.limit)
        guard !notes.isEmpty else { return "No Ephemeris notes found for '\(arguments.query)'." }
        return notes.map { note in
            "[\(note.instrument)] \(note.title)\n\(note.content.prefix(300))"
        }.joined(separator: "\n\n")
    }
}

class SynthesisService {
    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }

    func prewarm() {
        LanguageModelSession().prewarm()
    }

    func generate(blueprint: BlueprintResponse, ephemerisService: EphemerisService) async throws -> SessionSynthesis {
        let session = LanguageModelSession(
            tools: [EphemerisSearchTool(ephemerisService: ephemerisService)]
        ) {
            "You are a synthesis engine for a professional Human Design and Astrology practitioner."
            "Use EphemerisSearchTool to retrieve relevant Ephemeris notes before synthesising."
            "Look up: HD type, authority, profile, active channels, Personality Sun gate, Design Sun gate, and dominant astrological placements."
            "Write for a practitioner preparing for a live consultation — precise and illuminating."
        }

        let summary = BlueprintSummary(blueprint).formatted()
        return try await session.respond(
            to: "Generate a session synthesis for this client chart:\n\(summary)",
            generating: SessionSynthesis.self
        ).content
    }
}
```

---

**Updated `ViewModels/ClientDetailViewModel.swift`:**

Add synthesis state:

```swift
enum SynthesisState {
    case idle, unavailable, generating, complete(SessionSynthesis), error(Error)
}
@Published var synthesisState: SynthesisState = .idle
```

On `BlueprintView` appear → call `synthesisService.prewarm()`.
On "Generate Synthesis" tap → set `.generating`, call `synthesisService.generate(blueprint:ephemerisService:)` — the model fetches Ephemeris notes dynamically via `EphemerisSearchTool` rather than receiving a pre-selected list. Set `.complete` or `.error`.

---

**New file:** `Views/Blueprint/SynthesisView.swift`

Displayed as a fourth tab in `BlueprintView` (alongside Astrology, Human Design, Ephemeris):

| State | UI |
|-------|----|
| `.unavailable` | "Enable Apple Intelligence in System Settings" with Settings deep-link |
| `.idle` | "Generate Synthesis" glass button |
| `.generating` | Progress indicator + "Synthesising…" |
| `.complete(synthesis)` | Five labeled sections with Synthwave-styled cards |
| `.error` | Error message + retry button |

---

### Availability Gate

Always check before displaying any AI UI:

```swift
switch SystemLanguageModel.default.availability {
case .available:
    // show Synthesis tab normally
case .unavailable(.appleIntelligenceNotEnabled):
    // show prompt to enable Apple Intelligence in System Settings
case .unavailable(.deviceNotEligible):
    // hide Synthesis tab entirely — non-Apple Silicon Mac
default:
    break
}
```

---

## Future: Semantic Vector RAG

Turso/libSQL supports native vector search via the `libsql-vector` extension, which would enable true semantic (embedding-based) retrieval of Ephemeris notes rather than BM25 keyword matching. Deferred to v2 — blocked on an embedding source.

`FoundationModels` exposes no embedding API. To generate embeddings you would need either a Core ML embedding model bundled in the app or an external embedding service, both of which add complexity and the latter compromises the privacy guarantee. FTS5 (already in Phase 1) is a strong match for this domain given the Ephemeris uses consistent, distinctive esoteric terminology.

Revisit when Apple exposes an on-device embedding API or a suitable Core ML model becomes available.

---

## Future: Vibology Lens Adapter

A LoRA adapter trained on the Ephemeris and The Athenaeum would shift the on-device model from a general assistant into one that already understands the Vibology ethos, archetypal framing, and specific parlance — before any prompt is written. Deferred post-launch.

### Requirements

- **Apple Developer Program** — required to download the Foundation Models Adapter Training Toolkit
- **Foundation Models Framework Adapter Entitlement** — required for production deployment (request via Account Holder on developer.apple.com)
- **Training hardware** — Mac with Apple Silicon (32GB+ RAM)
  - Intended training rig: Mac Mini with 32GB+ RAM (to be acquired)

### Training Data Strategy

Source training pairs from the Ephemeris and Athenaeum:

| Source | Prompt pattern | Response pattern |
|--------|---------------|-----------------|
| Ephemeris notes | "What is the symbolic meaning of [gate/planet/archetype]?" | Note body in Vibology voice |
| Session notes | "Synthesise [HD type] + [Sun sign] for a consultation" | Practitioner-voice synthesis |
| Obsidian commentary | Free-form symbolic queries | Written interpretations |

Target: 500–1,000 high-quality JSONL pairs. Prioritise quality over quantity.

**Format:**
```json
[{"role": "user", "content": "PROMPT"}, {"role": "assistant", "content": "RESPONSE"}]
```

### Training Workflow

```bash
# Verify setup with base model test
python -m examples.generate --prompt "Interpret Gate 64 in a Human Design chart"

# Train
python -m examples.train_adapter \
  --train-data vibology-train.jsonl \
  --eval-data vibology-eval.jsonl \
  --epochs 5 \
  --learning-rate 1e-3 \
  --batch-size 4 \
  --checkpoint-dir checkpoints/

# Export
python -m export.export_fmadapter \
  --adapter-name vibology-lens \
  --checkpoint checkpoints/adapter-final.pt \
  --output-dir exports/
```

### Integration

Drop into `SynthesisService` by loading the adapter before creating the session:

```swift
let adapter = try SystemLanguageModel.Adapter(fileURL: adapterURL)
try await adapter.compile()
let model = SystemLanguageModel(adapter: adapter)
let session = LanguageModelSession(model: model, tools: [EphemerisSearchTool(...)])
```

### Key Constraints

- **Version lock** — each `.fmadapter` is tied to one specific system model version; must retrain for every macOS update that bumps the model
- **~160 MB per adapter** — distribute via Background Assets, not bundled in the app
- **Retraining cadence** — plan for adapter maintenance as a recurring cost of each OS release

---

## Reference Files

| When working on | Read |
|-----------------|------|
| API contracts, field names | `Documentation/Cartographer-Reference.md` |
| GRDB migrations, FTS5, ValueObservation | `Documentation/GRDB-Reference.md` |
| Turso embedded replica, sync | `Documentation/Turso-libSQL-Reference.md` |
| Keychain, encryption | `Documentation/Security-Reference.md` |
| macOS 26 APIs, Liquid Glass | `Documentation/SwiftUI-WhatsNew-macOS26.md` |
| Foundation Models, @Generable, synthesis | `Documentation/FoundationModels-Reference.md` |
| @Observable ViewModels, @Bindable, thread safety | `Documentation/Observation-Reference.md` |
| Sandbox, entitlements, code signing | `Documentation/Entitlements-Reference.md` |
| FSEvents, VaultWatcher, iCloud path | `Documentation/FSEvents-Reference.md` |
| URLSession async/await, CartographerService | `Documentation/URLSession-Reference.md` |
| Markdown rendering, footnotes, wiki-links | `Documentation/AttributedString-Reference.md` |
| Database schema + query patterns | `DATABASE-PLAN.md` |
