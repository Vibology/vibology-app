# Turso / libSQL Swift SDK Reference
> `libsql-swift` — Swift bindings for libSQL (Turso's SQLite fork)
> Package: https://github.com/tursodatabase/libsql-swift
> Turso SDK docs: https://docs.turso.tech/sdk/swift/reference

## Installation (Swift Package Manager)

In `Package.swift`:
```swift
.package(url: "https://github.com/tursodatabase/libsql-swift", from: "0.1.1")
```

Or in Xcode: **File → Add Package Dependencies** → paste the URL above.

Add to your target:
```swift
.target(name: "VibologyApp", dependencies: ["Libsql"])
```

---

## Connection Modes

### Remote (Turso cloud — primary mode for Vibology)
```swift
import Libsql

let db = try Database(
    path: "./local-replica.db",          // local embedded replica path
    url: "libsql://your-db.turso.io",    // TURSO_DATABASE_URL
    authToken: "your-auth-token"          // from Keychain at runtime
)
let conn = try db.connect()
```

### In-memory (for testing/development)
```swift
let db = Database(":memory:")
let conn = try db.connect()
```

### Local file (offline, no Turso)
```swift
let db = Database("vibology-local.db")
let conn = try db.connect()
```

---

## Auth Token (Keychain storage)

Store and retrieve the Turso auth token from macOS Keychain — never hardcode it:

```swift
import Security

// Store token
func storeToken(_ token: String, for service: String) {
    let data = token.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String:       kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecValueData as String:   data
    ]
    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
}

// Retrieve token
func retrieveToken(for service: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String:       kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecReturnData as String:  true,
        kSecMatchLimit as String:  kSecMatchLimitOne
    ]
    var result: AnyObject?
    guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
          let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
}

// Usage
let token = retrieveToken(for: "com.vibology.turso") ?? ""
let db = try Database(path: "./replica.db", url: dbURL, authToken: token)
```

---

## Executing Queries

### Execute (INSERT / UPDATE / DELETE)
```swift
try conn.execute("INSERT INTO clients (name, birth_date) VALUES (?, ?)", ["Alice", "1990-06-15"])
```

### Query (SELECT — returns rows)
```swift
let rows = try conn.query("SELECT * FROM clients")
let rows = try conn.query("SELECT * FROM clients WHERE id = ?", [clientId])
```

---

## Reading Results

```swift
let rows = try conn.query("SELECT id, name, birth_date FROM clients")
for row in rows {
    let id: Int = try row.get(0)          // positional
    let name: String = try row.get(1)
    let birthDate: String = try row.get(2)
}
```

---

## Prepared Statements

```swift
let stmt = try conn.prepare("SELECT * FROM clients WHERE id = ?")
stmt.bind([clientId])
let rows = try stmt.query()
```

---

## Named Parameters

```swift
try conn.execute(
    "INSERT INTO sessions (client_id, notes) VALUES (:id, :notes)",
    [":id": clientId, ":notes": sessionNotes]
)
```

---

## Sync (Embedded Replica)

```swift
// Manual sync — pull latest from Turso cloud
try db.sync()

// Auto-sync interval (set at init)
let db = try Database(
    path: "./local-replica.db",
    url: tursoURL,
    authToken: token,
    syncInterval: 60     // sync every 60 seconds
)
```

`readYourWrites` is enabled by default — writes are immediately visible to subsequent reads on the same connection.

---

## Integration with GRDB

CLAUDE.md notes that GRDB connects via the Turso Swift SDK since libSQL is wire-compatible with SQLite. In practice this means using GRDB's standard `DatabasePool` or `DatabaseQueue` pointed at the local embedded replica file, while libsql-swift handles sync with Turso cloud:

```swift
import GRDB
import Libsql

// 1. Open libSQL embedded replica (syncs with Turso)
let tursoDB = try Database(
    path: dbPath,
    url: tursoURL,
    authToken: token
)
try tursoDB.sync()

// 2. Open GRDB on same local file for reactive queries
let grdbPool = try DatabasePool(path: dbPath)

// 3. Use GRDB for all reads/writes (GRDB handles SQLite directly)
// 4. Call tursoDB.sync() periodically or on app foreground to push/pull
```

---

## Schema Reference (Vibology)

```sql
-- Clients
CREATE TABLE clients (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    birth_date  TEXT NOT NULL,          -- ISO 8601
    birth_time  TEXT,
    birth_lat   REAL,
    birth_lon   REAL,
    timezone    TEXT,
    created_at  TEXT NOT NULL
);

-- Sessions
CREATE TABLE sessions (
    id          TEXT PRIMARY KEY,
    client_id   TEXT REFERENCES clients(id),
    date        TEXT NOT NULL,
    notes       TEXT,                   -- Markdown
    blueprint   TEXT,                   -- JSON from Cartographer
    created_at  TEXT NOT NULL
);

-- Ephemeris index (mirrors Obsidian vault structure)
CREATE VIRTUAL TABLE ephemeris_fts USING fts5(
    title, body, tags, path,
    tokenize = 'porter ascii'
);
```
