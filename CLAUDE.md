# Vibology MacOS Application

## Project Overview

Vibology is a native macOS application that synthesizes five symbolic instruments (Astrology, Human Design, Personal Mythos, Tarot, and The Astrolabe) into a unified framework for consultation sessions and personal exploration. It bridges technical calculation with esoteric wisdom through a client-server architecture.

## Architecture

### Core Technology Stack

| Layer | Component | Implementation |
|-------|-----------|----------------|
| **Calculation** | Headless Engine | Docker container running .NET 8 with SharpAstrology & Swiss Ephemeris |
| **Research** | Esoteric Grimoire | Obsidian (Markdown) with YAML frontmatter for metadata |
| **Interface** | Native Client | SwiftUI for macOS with Glassmorphism/Synthwave aesthetics |
| **Database** | Persistent Store | SQLite with SQLCipher (encryption) and FTS5 (full-text search) |
| **Data Logic** | Bridge | GRDB.swift for reactive, type-safe database management |

### Infrastructure

**Two-Machine Architecture:**
- **2018 Mac Mini (A1993)** - File server with 2-bay DAS
  - Hosts: Obsidian vault, SQLite database, Docker calculation engine
  - Shares directories via SMB 3.0
  - Runs real-time notification watcher service

- **M1 Mac Mini** - Main workstation
  - Runs native SwiftUI application
  - Mounts server directories as network drives
  - Clean local storage, minimal dependencies

**Security:**
- Client data encrypted via SQLCipher at database level
- Privacy maintained even if network share is accessed

### Real-Time Sync Pipeline

**The Watcher Service** (runs on 2018 Mini):
1. Monitors local FSEvents on network-accessible directories
2. Detects file changes (e.g., Obsidian note saves from M1)
3. Sends WebSocket or UDP "Refresh" signal to M1 app
4. M1 app re-queries network SQLite index, updating UI instantly

## Application Logic

### Five-Instrument Integration

The app synthesizes five distinct symbolic lenses:

1. **Astrology** - Planetary timing via .NET calculation engine
2. **Human Design** - Mechanical imprinting via SharpAstrology
3. **Personal Mythos** - Psychological narrative from Obsidian notes
4. **The Tarot** - Qabalistic archetypes via Correspondence Index
5. **The Astrolabe** - Contemporary oracle resonance (I Ching/Gene Keys)

### Live Session Workflow

1. **Calculation** - Enter birth data → M1 app calls 2018 Mini Docker API → receives JSON blueprint
2. **Physical Interaction** - Pull Tarot or Astrolabe cards physically
3. **Digital Retrieval** - Select cards in UI → GRDB joins card ID with Obsidian notes
4. **Synthesis** - Display personal commentary, shadow/gift/siddhi, archetypal stories alongside technical chart

### Professional Features

- **Reporting**: PDFKit renders branded PDF reports combining Blueprint (JSON) + Narrative (Markdown)
- **Search**: FTS5 full-text search across entire esoteric corpus in milliseconds (network-hosted)
- **Redundancy**: Daily hot backup (SQLITE VACUUM INTO) on 2018 Mini to DAS

## Data Flow

```
Edit    → Write in Obsidian on M1 (saves to 2018 Mini DAS via network share)
Notify  → 2018 Mini Watcher detects change, pings M1 App
Index   → M1 App updates SQLite view of grimoire
Consult → M1 App requests calculations from 2018 Mini Docker API
Secure  → Client session logs encrypted via SQLCipher, saved to 2018 Mini
```

## Development Guidelines

### Code Organization

- Use SwiftUI's declarative patterns
- Separate concerns: Views, ViewModels, Services, Models
- GRDB for all database interactions (reactive, type-safe)
- Network calls abstracted into services with clear error handling

### Aesthetics

- **Design System**: Glassmorphism + Synthwave
- Translucent panels, vibrant gradients, neon accents
- Dark mode optimized
- Typography should feel both technical and mystical

### Security & Privacy

- **ALWAYS** use SQLCipher for client data
- Never log sensitive personal information
- Encrypt birth data, session notes, client identifiers
- Network communication should be authenticated

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

### GRDB.swift
- Type-safe SQLite wrapper
- Reactive queries via Combine
- Migration support
- FTS5 integration

### Docker + .NET 8
- Calculation engine isolated in container
- REST API for chart calculations
- SharpAstrology library
- Swiss Ephemeris for astronomical precision

### SQLite + SQLCipher
- Embedded database
- Client-side encryption
- FTS5 for full-text search
- Network-accessible via SMB share

### Obsidian Integration
- YAML frontmatter as metadata source
- Markdown as narrative layer
- File system monitoring for live updates
- Correspondence tables link symbols across systems

## Development Workflow

1. **Local Development**: Use M1 for coding, testing, debugging
2. **Calculation Testing**: Docker container on 2018 Mini must be running
3. **Database Migrations**: Use GRDB migrations, test on copy of production DB
4. **UI Design**: Prototype in SwiftUI, reference Synthwave design system
5. **Integration**: Test full flow with real Obsidian vault and network storage

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
├── CalculationEngine/        # .NET Docker service (separate repo?)
├── WatcherService/           # FSEvents monitoring service
└── Shared/                   # Shared models between components
```

## Related Repositories

- **the-ephemeris** - Obsidian knowledge vault (source data)
- **vibology-website** - Public-facing content

## Current Status

Project setup complete. Ready for initial development.

---

*"Anima et Algorithm" - Bridging mystical wisdom with technical precision*
