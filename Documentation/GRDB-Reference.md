# GRDB.swift Reference
> Fetched from github.com/groue/GRDB.swift — February 2026
> Latest release: version 7.10.0 (February 15, 2026)
> Requirements: iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 7.0+ · SQLite 3.20.0+ · Swift 6.1+ / Xcode 16.3+

---

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Database Connections](#database-connections)
4. [Records](#records)
   - [FetchableRecord Protocol](#fetchablerecord-protocol)
   - [TableRecord Protocol](#tablerecord-protocol)
   - [PersistableRecord Protocol](#persistablerecord-protocol)
   - [Codable Records](#codable-records)
   - [Identifiable Records](#identifiable-records)
   - [Persistence Methods](#persistence-methods)
   - [Persistence Callbacks](#persistence-callbacks)
   - [Record Comparison](#record-comparison)
5. [Querying](#querying)
   - [Executing Updates (SQL)](#executing-updates)
   - [Fetching Methods](#fetching-methods)
   - [Row Queries](#row-queries)
   - [Value Queries](#value-queries)
   - [Values and Supported Types](#values-and-supported-types)
   - [The Query Interface](#the-query-interface)
6. [Migrations](#migrations)
7. [Full-Text Search (FTS5)](#full-text-search-fts5)
8. [Combine and Swift Concurrency](#combine-and-swift-concurrency)
9. [Errors](#errors)

---

## Overview

GRDB is a toolkit for SQLite databases, with a focus on application development. It has been proudly serving the community since 2015.

**Core capabilities:**

- **SQL Generation** — Enhance application models with persistence and fetching methods without manual SQL
- **Database Observation** — Get notifications when database values are modified
- **Robust Concurrency** — Multi-threaded applications can efficiently use their databases, including WAL databases with concurrent reads and writes
- **Migrations** — Evolve the schema of your database as you ship new versions of your application
- **Full SQLite Access** — Come with your SQL and SQLite skills, or learn new ones as you go

### Quick Start (Four Steps)

```swift
import GRDB

// 1. Open a database connection
let dbQueue = try DatabaseQueue(path: "/path/to/database.sqlite")

// 2. Define the database schema
try dbQueue.write { db in
    try db.create(table: "player") { t in
        t.primaryKey("id", .text)
        t.column("name", .text).notNull()
        t.column("score", .integer).notNull()
    }
}

// 3. Define a record type
struct Player: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: String
    var name: String
    var score: Int

    enum Columns {
        static let name = Column(CodingKeys.name)
        static let score = Column(CodingKeys.score)
    }
}

// 4. Write and read in the database
try dbQueue.write { db in
    try Player(id: "1", name: "Arthur", score: 100).insert(db)
    try Player(id: "2", name: "Barbara", score: 1000).insert(db)
}

try dbQueue.read { db in
    let player = try Player.find(db, id: "1")

    let bestPlayers = try Player
        .order(\.score.desc)
        .limit(10)
        .fetchAll(db)
}
```

---

## Installation

### Swift Package Manager (Recommended)

Add a dependency to `https://github.com/groue/GRDB.swift.git` in your package or Xcode project.

GRDB offers two libraries:
- `GRDB` — static library (prefer this when in doubt)
- `GRDB-dynamic` — useful if you link it with multiple targets in your app

### CocoaPods

Due to a CocoaPods issue, the last version available on CocoaPods directly is 6.24.1. Use a git dependency for GRDB 7+:

```ruby
# Use the GRDB7 branch
pod 'GRDB.swift', git: 'https://github.com/groue/GRDB.swift.git', branch: 'GRDB7'

# Or pin to a specific tag
pod 'GRDB.swift', git: 'https://github.com/groue/GRDB.swift.git', tag: 'v7.10.0'
```

---

## Database Connections

GRDB provides two classes for accessing SQLite databases: `DatabaseQueue` and `DatabasePool`.

```swift
import GRDB

// Pick one:
let dbQueue = try DatabaseQueue(path: "/path/to/database.sqlite")
let dbPool  = try DatabasePool(path: "/path/to/database.sqlite")
```

**Key differences:**

| Feature | DatabaseQueue | DatabasePool |
|---------|:---:|:---:|
| Concurrent reads and writes | No | Yes (WAL mode) |
| In-memory databases | Yes | No |
| Recommended default | Yes | — |

**If you are not sure, choose `DatabaseQueue`.** You can always switch to `DatabasePool` later.

### Opening a Read-Only Connection

```swift
// For a bundled database resource
if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
    var config = Configuration()
    config.readonly = true
    let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
}
```

### Creating or Opening a Database File

```swift
// Create the directory if needed, then open or create the database
let fileManager = FileManager.default
let appSupportURL = try fileManager.url(
    for: .applicationSupportDirectory, in: .userDomainMask,
    appropriateFor: nil, create: true)
let directoryURL = appSupportURL.appendingPathComponent("MyDatabase", isDirectory: true)
try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
let dbQueue = try DatabaseQueue(path: databaseURL.path)
```

### In-Memory Databases

```swift
// Great for previews and tests
let dbQueue = try DatabaseQueue()
```

### Configuration

```swift
var config = Configuration()
config.readonly = true
config.maximumReaderCount = 10    // DatabasePool only
config.prepareDatabase { db in
    // Customize each new database connection
    try db.execute(sql: "PRAGMA foreign_keys = ON")
    db.add(function: myCustomFunction)
}
let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
```

### Async/Await Access

```swift
// Read
let playerCount = try await dbQueue.read { db in
    try Player.fetchCount(db)
}

// Write
let newPlayerCount = try await dbQueue.write { db in
    try Player(name: "Arthur").insert(db)
    return try Player.fetchCount(db)
}
```

### Closing Connections

Database connections are automatically closed when `DatabaseQueue` or `DatabasePool` instances are deinitialized. For explicit closing:

```swift
try dbQueue.close()
```

---

## Records

Records are application objects conforming to GRDB protocols that enable persistence and fetching.

### Record Protocols Overview

| Protocol | Purpose |
|----------|---------|
| `FetchableRecord` | Decode database rows into instances |
| `TableRecord` | Generate SQL queries from the type |
| `PersistableRecord` | Create, update, and delete rows in the database |
| `MutablePersistableRecord` | Like `PersistableRecord` but `didInsert` is mutating (for structs with auto-increment PK) |
| `EncodableRecord` | Encode the record into persistence containers |

> **Note**: GRDB records are not uniqued, do not auto-update, and do not lazy-load — unlike Core Data's NSManagedObject or Realm's Object. This is intentional.

### FetchableRecord Protocol

`FetchableRecord` grants fetching methods to any type that can be built from a database row:

```swift
protocol FetchableRecord {
    init(row: Row) throws
}
```

Example implementation:

```swift
struct Place {
    var id: Int64?
    var title: String
    var coordinate: CLLocationCoordinate2D
}

extension Place: FetchableRecord {
    enum Columns {
        static let id        = Column("id")
        static let title     = Column("title")
        static let latitude  = Column("latitude")
        static let longitude = Column("longitude")
    }

    init(row: Row) {
        id = row[Columns.id]
        title = row[Columns.title]
        coordinate = CLLocationCoordinate2D(
            latitude: row[Columns.latitude],
            longitude: row[Columns.longitude])
    }
}
```

When your record type adopts `Decodable`, the `init(row:)` implementation is derived automatically:

```swift
struct Player: Decodable, FetchableRecord {
    var id: Int64
    var name: String
    var score: Int

    enum Columns {
        static let id    = Column(CodingKeys.id)
        static let name  = Column(CodingKeys.name)
        static let score = Column(CodingKeys.score)
    }
}
```

Fetching methods available on `FetchableRecord`:

```swift
try Place.fetchCursor(db, sql: "SELECT ...", arguments: ...) // Cursor<Place>
try Place.fetchAll(db, sql: "SELECT ...", arguments: ...)    // [Place]
try Place.fetchSet(db, sql: "SELECT ...", arguments: ...)    // Set<Place>
try Place.fetchOne(db, sql: "SELECT ...", arguments: ...)    // Place?
```

### TableRecord Protocol

`TableRecord` generates SQL queries for your type:

```swift
protocol TableRecord {
    static var databaseTableName: String { get }
    static var databaseSelection: [any SQLSelectable] { get }  // optional
}
```

By default, `databaseTableName` is derived from the type name:

```swift
struct Place: TableRecord { }
print(Place.databaseTableName) // "place"
```

Convention: `Place` → `"place"`, `PostalAddress` → `"postalAddress"`, `HTTPRequest` → `"httpRequest"`

Override as needed:

```swift
struct Place: TableRecord {
    static let databaseTableName = "location"
}
```

When combined with `FetchableRecord`, you can use the query interface:

```swift
// SELECT * FROM place WHERE name = 'Paris'
let paris = try Place.filter { $0.name == "Paris" }.fetchOne(db)
```

### PersistableRecord Protocol

`PersistableRecord` (and `MutablePersistableRecord`) enables create, update, and delete operations:

```swift
// Defines how a record encodes itself into the database
protocol EncodableRecord {
    func encode(to container: inout PersistenceContainer) throws
}

// Adds persistence methods
protocol MutablePersistableRecord: TableRecord, EncodableRecord {
    mutating func didInsert(_ inserted: InsertionSuccess)
}

// Non-mutating variant (for classes or structs without auto-increment PK)
protocol PersistableRecord: MutablePersistableRecord {
    func didInsert(_ inserted: InsertionSuccess)
}
```

**Which to use:**
- Class types → `PersistableRecord`
- Struct with auto-incremented PK → `MutablePersistableRecord`, implement `didInsert`
- Struct with other PK → `PersistableRecord`, ignore `didInsert`

Example with auto-incremented primary key:

```swift
extension Place: MutablePersistableRecord {
    enum Columns {
        static let id        = Column("id")
        static let title     = Column("title")
        static let latitude  = Column("latitude")
        static let longitude = Column("longitude")
    }

    func encode(to container: inout PersistenceContainer) {
        container[Columns.id]        = id
        container[Columns.title]     = title
        container[Columns.latitude]  = coordinate.latitude
        container[Columns.longitude] = coordinate.longitude
    }

    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}

var paris = Place(id: nil, title: "Paris", coordinate: ...)
try paris.insert(db)
paris.id  // non-nil after insert
```

### Codable Records

When a record type adopts `Codable`, `Encodable`, or `Decodable`, the `init(row:)` and `encode(to:)` implementations are derived for free:

```swift
struct Player: Codable, FetchableRecord, PersistableRecord {
    var id: Int64
    var name: String
    var score: Int

    enum Columns {
        static let id    = Column(CodingKeys.id)
        static let name  = Column(CodingKeys.name)
        static let score = Column(CodingKeys.score)
    }
}

try dbQueue.write { db in
    try Player(id: 1, name: "Arthur", score: 100).insert(db)
    let players = try Player.order(\.score.desc).fetchAll(db)
}
```

**JSON Columns**: Complex properties (arrays, dicts, nested structs) are automatically stored as JSON:

```swift
struct Player: Codable, FetchableRecord, PersistableRecord {
    var name: String
    var score: Int
    var achievements: [Achievement]  // stored as JSON in the database
}
```

**Column Naming Strategies**: Override `databaseColumnDecodingStrategy` / `databaseColumnEncodingStrategy` to use snake_case or other conventions.

**Date/UUID Strategies**: Override `databaseDateDecodingStrategy`, `databaseDateEncodingStrategy`, `databaseUUIDEncodingStrategy` to customize serialization.

**Tips:**
- Derive `Column` values from `CodingKeys` to avoid typos
- Set `JSONEncoder.sortedKeys = true` for stable JSON output (important for `ValueObservation` change detection)

### Identifiable Records

When a record maps a table with a single-column primary key, adopt `Identifiable` for type-safe convenience methods:

```swift
struct Player: Identifiable, FetchableRecord, PersistableRecord {
    var id: Int64  // fulfills Identifiable
    var name: String
    var score: Int
}

let player  = try Player.find(db, id: 1)               // Player (throws if not found)
let player  = try Player.fetchOne(db, id: 1)           // Player?
let players = try Player.fetchAll(db, ids: [1, 2, 3])  // [Player]
let players = try Player.fetchSet(db, ids: [1, 2, 3])  // Set<Player>

try Player.deleteOne(db, id: 1)
try Player.deleteAll(db, ids: [1, 2, 3])
```

For tables where the primary key is not named `id`:

```swift
struct Country: Identifiable, FetchableRecord, PersistableRecord {
    var isoCode: String
    var name: String
    var population: Int

    var id: String { isoCode }  // Fulfill Identifiable
}
```

> **Note**: Avoid `Identifiable` on types with auto-incremented primary key (`var id: Int64?`). The optional id is not suitable.

### Persistence Methods

Types adopting `PersistableRecord` or `MutablePersistableRecord` get:

```swift
// INSERT
try place.insert(db)
let insertedPlace = try place.inserted(db)  // non-mutating variant

// UPDATE
try place.update(db)
try place.update(db, columns: ["title"])

// Maybe UPDATE (only if changed)
try place.updateChanges(db, from: otherPlace)
try place.updateChanges(db) { $0.isFavorite = true }

// INSERT or UPDATE
try place.save(db)
let savedPlace = try place.saved(db)  // non-mutating variant

// UPSERT (SQLite 3.35.0+ / iOS 15+ / macOS 12+)
try place.upsert(db)
let upserted = try place.upsertAndFetch(db)

// DELETE
try place.delete(db)

// EXISTENCE CHECK
let exists = try place.exists(db)
```

**Batch operations** (on `TableRecord`):

```swift
// UPDATE
try Place.updateAll(db, ...)

// DELETE
try Place.deleteAll(db)
try Place.deleteAll(db, ids: [...])
try Place.deleteAll(db, keys: [...])
try Place.deleteOne(db, id: ...)
try Place.deleteOne(db, key: ...)
```

**RETURNING clause** (SQLite 3.35.0+ / iOS 15+ / macOS 12+):

```swift
// INSERT ... RETURNING *
let player = try partialPlayer.insertAndFetch(db, as: Player.self)

// INSERT ... RETURNING score
let score = try partialPlayer.insertAndFetch(db) { statement in
    try Int.fetchOne(statement)
} select: {
    [$0.score]
}

// DELETE ... RETURNING *
let deletedPlayers = try request.deleteAndFetchAll(db)  // [Player]

// UPDATE ... RETURNING *
let updatedPlayers = try request.updateAndFetchAll(db) { [$0.score += 10] }
```

### Persistence Callbacks

Implement callbacks on `MutablePersistableRecord` / `PersistableRecord` for lifecycle hooks:

```swift
struct Player: MutablePersistableRecord {
    var id: Int64?

    // Called after a successful insert — update auto-incremented id
    mutating func didInsert(_ inserted: InsertionSuccess) {
        id = inserted.rowID
    }
}

// Validation example:
struct Link: PersistableRecord {
    var url: URL

    func willSave(_ db: Database) throws {
        if url.host == nil {
            throw ValidationError("url must be absolute.")
        }
    }
}
```

**Available callbacks** (in order of invocation):

- Inserting: `willSave` → `aroundSave` → `willInsert` → `aroundInsert` → `didInsert` → `didSave`
- Updating: `willSave` → `aroundSave` → `willUpdate` → `aroundUpdate` → `didUpdate` → `didSave`
- Deleting: `willDelete` → `aroundDelete` → `didDelete`

> **Warning**: `did***` callbacks fire before the transaction is committed to disk. Use `db.afterNextTransaction { _ in ... }` when you need to react after commit.

### Record Comparison

`EncodableRecord` types can be compared for database changes:

```swift
// Update only changed columns
try player.updateChanges(db, from: oldPlayer)

// Update in-place
try player.updateChanges(db) { $0.score = 100 }

// Check equality (based on database representation, not Equatable)
if newPlayer.databaseEquals(oldPlayer) == false {
    try newPlayer.save(db)
}

// Inspect what changed
for (column, oldValue) in try newPlayer.databaseChanges(from: oldPlayer) {
    print("\(column) was \(oldValue)")
}
```

---

## Querying

### Executing Updates

```swift
try dbQueue.write { db in
    // DDL
    try db.execute(sql: """
        CREATE TABLE player (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            score INT)
        """)

    // DML with positional arguments
    try db.execute(
        sql: "INSERT INTO player (name, score) VALUES (?, ?)",
        arguments: ["Barbara", 1000])

    // DML with named arguments
    try db.execute(
        sql: "UPDATE player SET score = :score WHERE id = :id",
        arguments: ["score": 1000, "id": 1])
}
```

**SQL Interpolation** (safe, no injection risk):

```swift
try dbQueue.write { db in
    let name = "O'Brien"
    let score = 550
    try db.execute(literal: """
        INSERT INTO player (name, score) VALUES (\(name), \(score))
        """)
}
```

**Never embed values directly in raw SQL strings:**

```swift
// WRONG — SQL injection risk!
try db.execute(sql: "UPDATE player SET name = '\(name)' WHERE id = \(id)")

// CORRECT
try db.execute(
    sql: "UPDATE player SET name = ? WHERE id = ?",
    arguments: [name, id])
```

**Last inserted row ID:**

```swift
try db.execute(sql: "INSERT INTO player (name, score) VALUES (?, ?)", arguments: ["Arthur", 1000])
let playerId = db.lastInsertedRowID
```

### Fetching Methods

Throughout GRDB, you can fetch *cursors*, *arrays*, *sets*, or *single values*:

```swift
try Row.fetchCursor(...) // Cursor<Row> — lazy, memory-efficient
try Row.fetchAll(...)    // [Row]        — eager
try Row.fetchSet(...)    // Set<Row>     — eager, unique
try Row.fetchOne(...)    // Row?         — single optional
```

**Cursors** load results step-by-step (low memory, close to SQLite metal):

```swift
let rows = try Row.fetchCursor(db, sql: "SELECT ...")
while let row = try rows.next() {
    // process row
}
```

> **Warning**: Cursors must be consumed on the dispatch queue they were created in. Do not extract them out of a `dbQueue.read/write` block.

**Arrays** can be used on any thread:

```swift
let players = try dbQueue.read { db in
    try Player.fetchAll(db, ...)
}
for player in players { ... }  // safe on any thread
```

Cursors support many functional-style methods: `filter`, `map`, `compactMap`, `forEach`, `reduce`, `first`, `contains`, `prefix`, etc.

### Row Queries

```swift
try dbQueue.read { db in
    // Fetch rows
    let rows = try Row.fetchCursor(db, sql: "SELECT * FROM wine")
    while let row = try rows.next() {
        let name: String  = row["name"]
        let color: Color  = row["color"]
    }

    // Single row
    if let row = try Row.fetchOne(db, sql: "SELECT * FROM wine WHERE id = ?", arguments: [1]) {
        let name: String = row["name"]
    }
}
```

**Column access:**

```swift
let name: String  = row[0]            // by index
let name: String  = row["name"]       // by column name (case-insensitive)
let name: String? = row["name"]       // optional for nullable columns
```

**DatabaseValue** — the raw intermediate type:

```swift
let dbValue: DatabaseValue = row[0]

dbValue.isNull          // Bool
dbValue.storage.value   // Int64, Double, String, Data, or nil

switch dbValue.storage {
case .null:                print("NULL")
case .int64(let v):        print("Int64: \(v)")
case .double(let v):       print("Double: \(v)")
case .string(let v):       print("String: \(v)")
case .blob(let v):         print("Data: \(v)")
}

// Safe conversion (returns nil for invalid conversions)
let date = Date.fromDatabaseValue(dbValue)  // Date?
let int  = Int.fromDatabaseValue(dbValue)   // Int?
```

### Value Queries

```swift
try dbQueue.read { db in
    try Int.fetchCursor(db, sql: "SELECT ...")    // Cursor<Int>
    try Int.fetchAll(db, sql: "SELECT ...")       // [Int]
    try Int.fetchSet(db, sql: "SELECT ...")       // Set<Int>
    try Int.fetchOne(db, sql: "SELECT MAX(score) FROM player")  // Int?

    let names = try String.fetchAll(db, sql: "SELECT name FROM player")
}
```

For nullable results:

```swift
let scores = try Optional<Int>.fetchAll(db, sql: "SELECT score FROM player")  // [Int?]
```

### Values and Supported Types

GRDB has built-in support for:

- **Swift Standard Library**: `Bool`, `Double`, `Float`, all signed and unsigned integer types, `String`, Swift `enum` with raw value
- **Foundation**: `Data`, `Date`, `DateComponents` (via `DatabaseDateComponents`), `Decimal`, `NSNull`, `NSNumber`, `NSString`, `URL`, `UUID`
- **CoreGraphics**: `CGFloat`
- **GRDB**: `DatabaseValue`, `FTS3Pattern`, `FTS5Pattern`
- **Custom types**: adopt `DatabaseValueConvertible`

**Swift enums:**

```swift
enum Color: Int {
    case red, white, rose
}

extension Color: DatabaseValueConvertible { }

// Store
try db.execute(sql: "INSERT INTO wine (color) VALUES (?)", arguments: [Color.red])

// Read
let color: Color = row["color"]
```

**Date storage format**: "YYYY-MM-DD HH:MM:SS.SSS" in UTC (millisecond precision, comparable, compatible with SQLite date functions).

**UUID storage**: 16-byte data blobs; can decode both blobs and UUID strings.

**Custom `DatabaseValueConvertible`** types: implement `databaseValue` (encoding) and `fromDatabaseValue(_:)` (decoding).

### The Query Interface

The query interface generates SQL in pure Swift, using the `TableRecord` protocol and `Column` definitions:

```swift
// SELECT * FROM player ORDER BY score DESC LIMIT 10
let bestPlayers = try Player
    .order(\.score.desc)
    .limit(10)
    .fetchAll(db)

// SELECT * FROM player WHERE email IS NOT NULL
let withEmail = try Player
    .filter { $0.email != nil }
    .fetchAll(db)

// SELECT COUNT(*) FROM player WHERE score >= 1000
let count = try Player
    .filter { $0.score >= 1000 }
    .fetchCount(db)

// Batch update
try Player
    .filter { $0.team == "Reds" }
    .updateAll(db) { $0.score += 100 }

// Batch delete
try Player
    .filter { $0.score == 0 }
    .deleteAll(db)
```

**Request-building methods** (chainable, return new requests):

| Method | SQL Effect |
|--------|-----------|
| `.all()` | `SELECT * FROM table` |
| `.none()` | Empty result |
| `.select(...)` | Change selected columns |
| `.distinct()` | Add `DISTINCT` |
| `.filter { ... }` | Add `WHERE` condition |
| `.filter(id:)` | Type-safe filter by Identifiable id |
| `.filter(key:)` | Filter by primary/unique key |
| `.matching(pattern)` | FTS pattern matching |
| `.group(...)` | `GROUP BY` |
| `.having(...)` | `HAVING` |
| `.order(...)` | `ORDER BY` |
| `.reversed()` | Reverse ordering |
| `.limit(_:offset:)` | `LIMIT ... OFFSET ...` |
| `.joining(required:)` | `INNER JOIN` via association |
| `.joining(optional:)` | `LEFT JOIN` via association |
| `.including(required:)` | `JOIN` and load association |
| `.including(optional:)` | `LEFT JOIN` and load association |
| `.with(cte)` | Add `WITH` (CTE) |

**Filter examples:**

```swift
// IN clause
Player.filter { [1, 2, 3].contains($0.id) }

// AND conditions
Player.filter { $0.name != nil && $0.height > 1.75 }

// Type-safe id filter (Identifiable)
Player.filter(id: 1)
Country.filter(ids: ["FR", "US"])

// Composite key
Citizenship.filter(key: ["citizenId": 1, "countryCode": "FR"])
```

**Ordering examples:**

```swift
Player.order(\.name)                     // ORDER BY name
Player.order(\.score.desc)               // ORDER BY score DESC
Player.order { [$0.score.desc, $0.name] }// ORDER BY score DESC, name
Player.order(\.score.desc).order(\.name) // ORDER BY name (each call replaces)
```

**SQL is always welcome** in the query interface:

```swift
// SQL snippet in a request
let minScore = 1000
let count = try Player
    .filter(sql: "score >= ?", arguments: [minScore])
    .fetchCount(db)

// Full SQL fetch
let players = try Player.fetchAll(db, sql: "SELECT * FROM player ORDER BY score DESC")
```

**Fetching aggregated values:**

```swift
let playerCount  = try Player.fetchCount(db)
let maxScore     = try Player.select { max($0.score) }.fetchOne(db) as Int?
let totalScore   = try Player.select { sum($0.score) }.fetchOne(db) as Int?
```

**Fetching by key:**

```swift
// Requires Identifiable
let player  = try Player.find(db, id: 1)           // Player (throws if not found)
let player  = try Player.fetchOne(db, id: 1)        // Player?
let players = try Player.fetchAll(db, ids: [1, 2])  // [Player]

// Without Identifiable
try Player.fetchOne(db, key: 1)
try Player.fetchOne(db, key: ["email": "arthur@example.com"])
try Country.fetchAll(db, keys: ["FR", "US"])
```

---

## Migrations

Migrations allow you to evolve your database schema over time. Each migration runs in a separate transaction.

### Basic Setup

```swift
var migrator = DatabaseMigrator()

// 1st migration
migrator.registerMigration("Create authors") { db in
    try db.create(table: "author") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("creationDate", .datetime)
        t.column("name", .text)
    }
}

// 2nd migration
migrator.registerMigration("Add books and author.birthYear") { db in
    try db.create(table: "book") { t in
        t.autoIncrementedPrimaryKey("id")
        t.belongsTo("author").notNull()
        t.column("title", .text).notNull()
    }

    try db.alter(table: "author") { t in
        t.add(column: "birthYear", .integer)
    }
}

// Apply migrations
let dbQueue = try DatabaseQueue(path: "/path/to/database.sqlite")
try migrator.migrate(dbQueue)
```

### Migrate to a Specific Version (for Testing)

```swift
try migrator.migrate(dbQueue, upTo: "Create authors")
```

### Checking Migration State

```swift
try dbQueue.read { db in
    // Check if all migrations have been applied
    if try migrator.hasCompletedMigrations(db) == false {
        // database is too old
    }

    // Check if the database has migrations from a future app version
    if try migrator.hasBeenSuperseded(db) {
        // database is too new
    }
}
```

### Development: Erase on Schema Change

```swift
var migrator = DatabaseMigrator()
#if DEBUG
// Nuke the database on schema change during development
migrator.eraseDatabaseOnSchemaChange = true
#endif
```

> **Warning**: Never ship `eraseDatabaseOnSchemaChange = true` in production.

### Good Practices

**Use literal strings, not type references:**

```swift
// RECOMMENDED — stable across type renames
migrator.registerMigration("Create authors") { db in
    try db.create(table: "author") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("name", .text)
    }
}

// NOT RECOMMENDED — breaks if type is renamed
migrator.registerMigration("Create authors") { db in
    try db.create(table: Author.databaseTableName) { t in
        t.autoIncrementedPrimaryKey(Author.Columns.id.name)
    }
}
```

**Never modify existing migrations** once shipped to users.

### Recreating a Table

When SQLite's `ALTER TABLE` is insufficient:

```swift
migrator.registerMigration("Add NOT NULL check on author.name") { db in
    try db.create(table: "new_author") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("creationDate", .datetime)
        t.column("name", .text).notNull()
    }
    try db.execute(sql: "INSERT INTO new_author SELECT * FROM author")
    try db.drop(table: "author")
    try db.rename(table: "new_author", to: "author")
}
```

### Foreign Key Checks

Each migration runs with deferred foreign key checks by default. For faster migrations on large databases:

```swift
// Immediate checks (faster, but can't recreate tables)
migrator.registerMigration("Fast migration", foreignKeyChecks: .immediate) { db in ... }

// Disable deferred checks globally (manual responsibility)
migrator = migrator.disablingDeferredForeignKeyChecks()
migrator.registerMigration("Unchecked") { db in
    ...
    // Manually check specific tables
    try db.checkForeignKeys(in: "book")
}
```

### Renaming a Foreign Key

```swift
// IMPORTANT: use immediate foreign key checks when renaming foreign keys
migrator.registerMigration("Guilds", foreignKeyChecks: .immediate) { db in
    try db.rename(table: "team", to: "guild")
    try db.alter(table: "player") { t in
        t.rename(column: "teamId", to: "guildId")
    }
}
```

---

## Full-Text Search (FTS5)

GRDB supports SQLite's FTS3, FTS4, and FTS5 full-text search engines. **FTS5 is recommended** for new projects.

> **Note**: FTS5 requires a custom SQLite build that activates `SQLITE_ENABLE_FTS5`. FTS3 and FTS4 are available in the default SQLite build.

### Choosing an Engine

| Feature | FTS3 | FTS4 | FTS5 |
|---------|:----:|:----:|:----:|
| Word searches | X | X | X |
| Prefix searches | X | X | X |
| Phrase searches | X | X | X |
| Boolean searches | X | X | X |
| Unicode case-insensitivity | X | X | X |
| Latin diacritics stripping | X | X | X |
| English stemming | X | X | X |
| Relevance ranking | — | — | X |
| External content tables | — | X | X |
| Contentless tables | — | X | X |

### Creating FTS5 Virtual Tables

```swift
// Basic FTS5 table
try db.create(virtualTable: "document", using: FTS5()) { t in
    t.column("content")
}

// With tokenizer and multiple columns
try db.create(virtualTable: "book", using: FTS5()) { t in
    t.tokenizer = .porter()   // or .unicode61(), .ascii
    t.column("author")
    t.column("title")
    t.column("body")
}

// With additional options
try db.create(virtualTable: "document", using: FTS5()) { t in
    t.column("content")
    t.column("uuid").notIndexed()  // UNINDEXED — stored but not indexed
    t.content = "table"            // external content table
    t.contentRowID = "id"
    t.prefixes = [2, 4]
    t.columnSize = 0
    t.detail = "column"
}
```

### FTS5 Tokenizers

```swift
try db.create(virtualTable: "book", using: FTS5()) { t in
    t.tokenizer = .unicode61()                           // default: case-insensitive, strips diacritics
    t.tokenizer = .unicode61(diacritics: .keep)          // keep diacritics
    t.tokenizer = .ascii()                               // ASCII case-insensitive only
    t.tokenizer = .porter()                              // English stemming + unicode61
    t.tokenizer = .porter(.ascii())                      // English stemming + ascii
    t.tokenizer = .porter(.unicode61(diacritics: .keep)) // English stemming, no diacritics stripping
}
```

| Tokenizer | Example Match |
|-----------|--------------|
| `unicode61` | "Jérôme" matches "JÉRÔME", "Jerome" |
| `ascii` | "Foo" matches "FOO" (ASCII only) |
| `porter` | "database" matches "databases", "frustration" matches "frustrated" |

### FTS3/FTS4 Tokenizers

```swift
try db.create(virtualTable: "book", using: FTS4()) { t in
    t.tokenizer = .simple     // default — ASCII case-insensitive
    t.tokenizer = .porter     // English stemming (ASCII)
    t.tokenizer = .unicode61(...)
}
```

### Populating Full-Text Tables

```swift
// Insert via records
try Book(author: "Melville", title: "Moby-Dick", body: "...").insert(db)

// Insert via SQL
try db.execute(
    sql: "INSERT INTO book (author, title, body) VALUES (?, ?, ?)",
    arguments: ["Melville", "Moby-Dick", "..."])
```

### Search Patterns

**FTS5Pattern:**

```swift
let query = "SQLite database"

// Matches documents containing "SQLite" or "database"
let pattern = FTS5Pattern(matchingAnyTokenIn: query)

// Matches documents containing both "SQLite" and "database"
let pattern = FTS5Pattern(matchingAllTokensIn: query)

// Matches documents containing words starting with "SQLite" and "database"
let pattern = FTS5Pattern(matchingAllPrefixesIn: query)

// Matches documents containing the phrase "SQLite database"
let pattern = FTS5Pattern(matchingPhrase: query)

// Matches documents starting with "SQLite database"
let pattern = FTS5Pattern(matchingPrefixPhrase: query)

// Validate a raw pattern (throws DatabaseError for invalid patterns)
let pattern = try db.makeFTS5Pattern(rawPattern: "sqlite AND database", forTable: "book")
```

**FTS3Pattern (FTS3/FTS4):**

```swift
let pattern = FTS3Pattern(matchingPhrase: "Moby-Dick")
let pattern = FTS3Pattern(matchingAllTokensIn: "SQLite database")
let pattern = FTS3Pattern(matchingAnyTokenIn: "SQLite database")
let pattern = FTS3Pattern(matchingAllPrefixesIn: "sql dat")
let pattern = try FTS3Pattern(rawPattern: "sqlite AND database")  // throws if invalid
```

Patterns return `nil` when they cannot be built from empty or invalid input:

```swift
FTS5Pattern(matchingAnyTokenIn: "")   // nil
FTS5Pattern(matchingAnyTokenIn: "*")  // nil
```

### Querying Full-Text Tables

```swift
// Query interface — search all columns
let books = try Book.matching(pattern).fetchAll(db)

// Query interface — search specific column
let books = try Book.filter { $0.body.match(pattern) }.fetchAll(db)

// Raw SQL
let books = try Book.fetchAll(db,
    sql: "SELECT * FROM book WHERE book MATCH ?",
    arguments: [pattern])
```

### Sorting by Relevance (FTS5 Only)

```swift
// SQL
let documents = try Document.fetchAll(db,
    sql: "SELECT * FROM document WHERE document MATCH ? ORDER BY rank",
    arguments: [pattern])

// Query interface
let documents = try Document.matching(pattern).order(Column.rank).fetchAll(db)
```

### External Content Tables (FTS4/FTS5)

Index a regular table without duplicating data:

```swift
// A regular table with mixed column types
try db.create(table: "book") { t in
    t.column("author", .text)
    t.column("title", .text)
    t.column("content", .text)
    t.column("publicationDate", .date)  // non-textual — can't be in FTS table directly
}

// A synchronized full-text table
try db.create(virtualTable: "book_ft", using: FTS5()) { t in
    t.synchronize(withTable: "book")
    t.column("author")
    t.column("title")
    t.column("content")
}
// Inserts, updates, and deletes on "book" are automatically reflected in "book_ft"
```

Querying with an external content table:

```swift
// Must join to avoid "unable to use function MATCH in the requested context"
let sql = """
    SELECT book.*
    FROM book
    JOIN book_ft ON book_ft.rowid = book.rowid AND book_ft MATCH ?
    """
let books = try Book.fetchAll(db, sql: sql, arguments: [pattern])
```

Dropping synchronized tables:

```swift
try db.drop(table: "book_ft")
try db.dropFTS5SynchronizationTriggers(forTable: "book_ft")
```

### Unicode Gotchas

- Matches may fail when content and query use different Unicode normalizations (NFC vs NFD)
- Use `String.precomposedStringWithCanonicalMapping` (NFC) for content from HFS+ or untrusted sources
- Use `String.precomposedStringWithCompatibilityMapping` (NFKC) to match ligatures ("ﬁ" → "fi")
- Use `String.applyingTransform` for advanced normalization (e.g., diacritics stripping, transliteration)

For complex Unicode requirements, write a custom FTS5 tokenizer.

---

## Combine and Swift Concurrency

### ValueObservation

`ValueObservation` tracks changes in database values and notifies fresh values whenever the database is modified.

```swift
// Define the observed value
let observation = ValueObservation.tracking { db in
    try Player.fetchAll(db)
}

// Start observation (callback-based)
let cancellable = observation.start(
    in: dbQueue,
    onError: { error in print("Error:", error) },
    onChange: { (players: [Player]) in print("Fresh players:", players) })
```

`ValueObservation` notifies an initial value immediately, then any subsequent changes. It may coalesce multiple changes into a single notification.

### Swift Concurrency (async/await)

```swift
// Async sequence — iterate fresh values
for try await players in observation.values(in: dbQueue) {
    print("Fresh players:", players)
}
```

### Combine Support

```swift
// Publisher that emits fresh values
let publisher = observation.publisher(in: dbQueue)

let cancellable = publisher.sink(
    receiveCompletion: { completion in ... },
    receiveValue: { (players: [Player]) in print("Fresh players:", players) })

// Immediate scheduling — emits initial value synchronously (must subscribe on main thread)
let cancellable = observation
    .publisher(in: dbQueue, scheduling: .immediate)
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { (players: [Player]) in
            // Initial value is already available here
        })
```

### Async Database Access (Combine Publishers)

```swift
// Read
let players = dbQueue.readPublisher { db in
    try Player.fetchAll(db)
}

// Write
let write = dbQueue.writePublisher { db in
    try Player(...).insert(db)
}

// Write and read (optimized for DatabasePool — avoids blocking writes during fetch)
let newCount = dbQueue.writePublisher(
    updates: { db in try Player(...).insert(db) },
    thenRead: { db, _ in try Player.fetchCount(db) })

// Migrate
let migrator: DatabaseMigrator = ...
let publisher = migrator.migratePublisher(dbQueue)
```

### DatabaseRegionObservation

Notifies all transactions that impact a tracked database region (provides a write-locked `Database` connection):

```swift
let observation = DatabaseRegionObservation.tracking(Player.all())

// Callback-based
let cancellable = observation.start(in: dbQueue) { (db: Database) in
    print("Players table was modified")
}

// Combine publisher
let cancellable = observation
    .publisher(in: dbQueue)
    .sink(
        receiveCompletion: { _ in },
        receiveValue: { (db: Database) in
            print("Exclusive write access after player change")
        })
```

### SharedValueObservation

Shares a single observation among multiple subscribers, reducing database reads:

```swift
let sharedObservation = ValueObservation
    .tracking { db in try Player.fetchAll(db) }
    .shared(in: dbQueue)

// Multiple subscribers share one database observation
for try await players in sharedObservation.values() {
    print(players)
}

let publisher = sharedObservation.publisher()
```

### Data Consistency Warning

When combining multiple database publishers, data consistency is **not guaranteed**. Each publisher has its own view of the database, and a concurrent write can produce inconsistent values. Always use a single publisher for related data:

```swift
// CORRECT: One publisher, always consistent
let hallOfFamePublisher = ValueObservation
    .tracking { db -> HallOfFame in
        let totalCount = try Player.fetchCount(db)
        let bestPlayers = try Player.order(\.score.desc).limit(10).fetchAll(db)
        // Guaranteed: bestPlayers.count <= totalCount
        return HallOfFame(totalPlayerCount: totalCount, bestPlayers: bestPlayers)
    }
    .publisher(in: dbQueue)

// WRONG: Two publishers combined — consistency NOT guaranteed
let hallOfFamePublisher = totalCountPublisher
    .combineLatest(bestPlayersPublisher)  // concurrent write can break invariants
    .map(HallOfFame.init(totalPlayerCount:bestPlayers:))
```

### Swift 6 / Sendable

In Swift 6 mode, record types must be `Sendable` for use with GRDB's async APIs. The easiest approach is to use structs (which are `Sendable` by default when all properties are `Sendable`):

```swift
// Sendable — works with async GRDB APIs
struct Player: Codable, Identifiable, FetchableRecord, PersistableRecord {
    var id: Int64
    var name: String
    var score: Int
}
```

For classes, you must either:
- Mark as `@unchecked Sendable` and ensure thread-safety manually, or
- Make the class immutable (`let` properties), or
- Refactor to a struct

---

## Errors

### DatabaseError

Thrown for SQLite errors:

```swift
do {
    try Pet(masterId: 1, name: "Bobby").insert(db)
} catch let error as DatabaseError {
    error.resultCode         // Int — primary result code (e.g., 19 = SQLITE_CONSTRAINT)
    error.extendedResultCode // Int — extended result code (e.g., 787 = SQLITE_CONSTRAINT_FOREIGNKEY)
    error.message            // String? — e.g., "FOREIGN KEY constraint failed"
    error.sql                // String? — e.g., "INSERT INTO pet ..."
    error.arguments          // StatementArguments? — bound values
    error.description        // Full description string
}
```

**Matching on result codes:**

```swift
do {
    try ...
} catch DatabaseError.SQLITE_CONSTRAINT_FOREIGNKEY {
    // foreign key violation
} catch DatabaseError.SQLITE_CONSTRAINT {
    // other constraint violation
} catch {
    // other database error
}
```

Or using a switch:

```swift
} catch let error as DatabaseError {
    switch error {
    case DatabaseError.SQLITE_CONSTRAINT_FOREIGNKEY:
        // handle
    default:
        // handle
    }
}
```

**Common result codes:**

| Code | Constant | Meaning |
|------|----------|---------|
| 1 | `SQLITE_ERROR` | Generic error |
| 5 | `SQLITE_BUSY` | Database is locked |
| 19 | `SQLITE_CONSTRAINT` | Constraint violation |
| 787 | `SQLITE_CONSTRAINT_FOREIGNKEY` | Foreign key violation |
| 2067 | `SQLITE_CONSTRAINT_UNIQUE` | Unique constraint violation |

**Error logging:**

```swift
// Configure early (before any connections are opened)
Database.logError = { (resultCode, message) in
    NSLog("%@", "SQLite error \(resultCode): \(message)")
}
```

### RecordError

Thrown when `update` can't find a row, or `find` can't find a record:

```swift
do {
    try player.update(db)  // throws if player.id not found
} catch RecordError.recordNotFound(let databaseTableName, let key) {
    print("Key \(key) was not found in table \(databaseTableName).")
}

do {
    let player = try Player.find(db, id: 42)  // throws if not found
} catch RecordError.recordNotFound(let table, let key) {
    print("Player \(key) not found in \(table).")
}
```

### RowDecodingError

Thrown when a value cannot be decoded from a row:

```swift
let row = try Row.fetchOne(db, sql: "SELECT NULL AS name")!
// RowDecodingError: could not decode String from database value NULL.
let name = try row.decode(String.self, forColumn: "name")
```

### Fatal Errors

Fatal errors indicate programming errors:

```swift
// fatal error: could not convert NULL to String.
let name: String = row["name"]  // fix: use String? instead

// fatal error: could not convert "Mom's birthday" to Date.
let date: Date = row["date"]    // fix: use DatabaseValue to handle all cases

// fatal error: table player has no unique index on column email
try Player.deleteOne(db, key: ["email": "arthur@example.com"])
// fix: add unique index on email, or use deleteAll
```

Avoid fatal errors from untrusted data using `DatabaseValue`:

```swift
let dbValue: DatabaseValue = row["date"]
if dbValue.isNull {
    // handle NULL
} else if let date = Date.fromDatabaseValue(dbValue) {
    // handle valid date
} else {
    // handle unparseable value
}
```

### Transactions and Savepoints

See also: [GRDB Transactions documentation](https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/transactions)

```swift
// Explicit transaction
try dbQueue.write { db in
    // This entire closure runs in a single transaction
    // Throws roll back; normal return commits
    try Player(name: "Arthur").insert(db)
    try Player(name: "Barbara").insert(db)
}

// Manual transaction control
try dbQueue.inTransaction { db in
    try Player(name: "Arthur").insert(db)

    // Rollback by returning .rollback
    return .commit  // or .rollback
}

// Savepoint
try dbQueue.write { db in
    try db.inSavepoint {
        try Player(name: "Arthur").insert(db)
        return .commit  // or .rollback
    }
}
```

---

## Additional Resources

- [GRDB Reference Documentation](https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/)
- [Migration Guide: GRDB 6 → GRDB 7](https://github.com/groue/GRDB.swift/blob/master/Documentation/GRDB7MigrationGuide.md)
- [Associations and Joins](https://github.com/groue/GRDB.swift/blob/master/Documentation/AssociationsBasics.md)
- [Recommended Practices for Record Types](https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/recordrecommendedpractices)
- [Concurrency Guide](https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/concurrency)
- [GRDBQuery — SwiftUI Integration](https://github.com/groue/GRDBQuery)
- [GRDBSnapshotTesting — Database Testing](https://github.com/groue/GRDBSnapshotTesting)
- [Demo Applications](https://github.com/groue/GRDB.swift/tree/master/Documentation/DemoApps)
- [Common Table Expressions](https://github.com/groue/GRDB.swift/blob/master/Documentation/CommonTableExpressions.md)
