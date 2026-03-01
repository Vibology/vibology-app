# URLSession Reference

URLSession is the Foundation networking layer Vibology uses exclusively to call the Cartographer REST API (a FastAPI service on Google Cloud Run). All requests are async POST calls with JSON bodies and JSON responses. This reference covers only the patterns the app actually uses.

**Source:** `Foundation.framework` — `arm64e-apple-macos.swiftinterface` (Xcode 26 SDK)

---

## Core Async/Await API

The primary entry point for all Cartographer calls:

```swift
// From Foundation.swiftinterface (line 19840)
public func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse)

// Convenience — GET from a bare URL (not used by CartographerService)
public func data(from url: URL, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse)
```

**Always use `URLSession.shared`** — no custom session needed for Cartographer.

```swift
let (data, response) = try await URLSession.shared.data(for: request)
```

The call suspends on the current actor until the response arrives. Propagates `URLError` on network failures, or any error thrown by the delegate.

---

## Building a URLRequest

```swift
// From Foundation.swiftinterface (line 20636)
public init(url: URL, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0)

public var httpMethod: String?          // "GET", "POST", "PUT", etc.
public var httpBody: Data?
public mutating func setValue(_ value: String?, forHTTPHeaderField field: String)
public var timeoutInterval: TimeInterval
```

**Standard pattern for a Cartographer POST:**

```swift
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("application/json", forHTTPHeaderField: "Accept")
request.timeoutInterval = 30  // override default 60s if desired
request.httpBody = try JSONEncoder().encode(body)
```

**Optional authentication header** (when `HD_API_TOKEN` is set on Cartographer):

```swift
request.setValue(token, forHTTPHeaderField: "X-Api-Token")
```

---

## JSON Encoding Requests

```swift
let encoder = JSONEncoder()
// Cartographer expects snake_case field names — match Swift struct names to JSON keys
// or use a custom CodingKeys enum. Do NOT set .convertToSnakeCase on encoder unless
// all Swift property names map cleanly.
request.httpBody = try encoder.encode(body)
```

**Cartographer request model:**

```swift
struct BlueprintRequest: Encodable {
    let name: String
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let place: String
    // Optional fields
    var second: Int = 0
    var houseSystem: String?

    enum CodingKeys: String, CodingKey {
        case name, year, month, day, hour, minute, place, second
        case houseSystem = "house_system"
    }
}
```

---

## JSON Decoding Responses

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
// Cartographer returns snake_case JSON; this maps e.g. "birth_date" → birthDate automatically
let response = try decoder.decode(BlueprintResponse.self, from: data)
```

`.convertFromSnakeCase` handles the common case. Use explicit `CodingKeys` only when the mapping is irregular (e.g., `human_design` → `humanDesign` works automatically; `g_center` → `gCenter` also works).

---

## Checking HTTP Status Codes

`URLSession.data(for:)` does **not** throw on non-2xx HTTP status codes — it only throws for transport-level failures. You must cast `URLResponse` to `HTTPURLResponse` and check `statusCode` manually.

```swift
// NSHTTPURLResponse (bridged to Swift as HTTPURLResponse)
// property: var statusCode: Int  (from NSURLResponse.h line 148)
// property: var allHeaderFields: [AnyHashable: Any]

guard let http = response as? HTTPURLResponse else {
    throw CartographerError.invalidResponse
}
guard (200..<300).contains(http.statusCode) else {
    throw CartographerError.httpError(statusCode: http.statusCode)
}
```

**Cartographer status codes to handle:**

| Code | Meaning |
|------|---------|
| 200 | Success — decode body |
| 422 | Validation error — body contains Pydantic error detail |
| 500 | Server error — Cartographer calculation failed |
| 503 | Cloud Run cold start timeout or scaling limit |

---

## URLError Handling

`URLSession` throws `URLError` for transport and infrastructure failures:

```swift
// From Foundation.swiftinterface (line 21569)
public struct URLError : _BridgedStoredNSError { ... }
```

**Common error codes for Cartographer (Cloud Run over HTTPS):**

```swift
// From Foundation.swiftinterface (lines 21591–21738)
URLError.Code.timedOut               // request exceeded timeoutInterval
URLError.Code.cannotConnectToHost    // Cloud Run unreachable
URLError.Code.notConnectedToInternet // offline
URLError.Code.networkConnectionLost  // connection dropped mid-request
URLError.Code.cannotFindHost         // DNS failure
URLError.Code.secureConnectionFailed // TLS/cert problem
URLError.Code.cancelled              // Task.cancel() was called
```

**Pattern for typed error handling:**

```swift
do {
    let blueprint = try await cartographer.fetchBlueprint(for: client)
} catch let urlError as URLError {
    switch urlError.code {
    case .timedOut:
        // Show "Request timed out — Cloud Run may be cold-starting"
    case .notConnectedToInternet:
        // Show offline state
    case .cancelled:
        break  // User cancelled, no UI update needed
    default:
        // Generic network error
    }
} catch let cartographerError as CartographerError {
    // HTTP-level errors: 422, 500, etc.
} catch {
    // Decoding errors (DecodingError), etc.
}
```

---

## Timeout Configuration

`URLRequest.timeoutInterval` (default: `60.0`) controls how long to wait before throwing `.timedOut`. Cloud Run cold starts can take 3–8 seconds; warm instances respond in under 1 second.

```swift
// Set per-request timeout:
request.timeoutInterval = 30  // seconds; appropriate for Cartographer

// For a custom session with a different default:
let config = URLSessionConfiguration.default
config.timeoutIntervalForRequest = 30   // per-request (replaces URLRequest.timeoutInterval)
config.timeoutIntervalForResource = 60  // total resource lifetime
let session = URLSession(configuration: config)
```

For Vibology's single-purpose use, setting `request.timeoutInterval` directly on the `URLRequest` is sufficient — no need for a custom session.

---

## Complete CartographerService Implementation

```swift
import Foundation

// MARK: - Errors

enum CartographerError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:          return "Invalid Cartographer URL"
        case .invalidResponse:     return "Unexpected response format"
        case .httpError(let code): return "Cartographer returned HTTP \(code)"
        case .decodingError(let e): return "Failed to decode response: \(e.localizedDescription)"
        }
    }
}

// MARK: - Service

actor CartographerService {
    static let shared = CartographerService()

    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        // Store production URL in a config file or Info.plist; never hard-code in source
        self.baseURL = URL(string: AppConfig.cartographerBaseURL)!
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder = JSONEncoder()
    }

    // MARK: - Blueprint

    func fetchBlueprint(for client: Client) async throws -> BlueprintResponse {
        let endpoint = baseURL.appendingPathComponent("blueprint")
        let requestBody = BlueprintRequest(from: client)
        return try await post(to: endpoint, body: requestBody)
    }

    // MARK: - Health Check

    func checkHealth() async throws -> Bool {
        let endpoint = baseURL.appendingPathComponent("health")
        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 10
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { return false }
        return http.statusCode == 200
    }

    // MARK: - Private

    private func post<RequestBody: Encodable, ResponseBody: Decodable>(
        to url: URL,
        body: RequestBody
    ) async throws -> ResponseBody {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 30

        // Optional: API token auth (when HD_API_TOKEN is set on Cartographer)
        if let token = AppConfig.cartographerAPIToken {
            request.setValue(token, forHTTPHeaderField: "X-Api-Token")
        }

        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw CartographerError.decodingError(error)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw CartographerError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw CartographerError.httpError(statusCode: http.statusCode)
        }

        do {
            return try decoder.decode(ResponseBody.self, from: data)
        } catch {
            throw CartographerError.decodingError(error)
        }
    }
}
```

**Calling from a ViewModel:**

```swift
@MainActor
class BlueprintViewModel: ObservableObject {
    @Published var blueprint: BlueprintResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var currentTask: Task<Void, Never>?

    func loadBlueprint(for client: Client) {
        currentTask?.cancel()
        currentTask = Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }

            do {
                blueprint = try await CartographerService.shared.fetchBlueprint(for: client)
            } catch is CancellationError {
                // Task was cancelled — no error shown
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func cancel() {
        currentTask?.cancel()
    }
}
```

---

## Combine: dataTaskPublisher (Reference Only)

Vibology uses async/await, not Combine, for network calls. For reference, the Combine publisher exists if you ever need to chain network calls into a Combine pipeline:

```swift
// From Foundation.swiftinterface (lines 17851–17859)
extension URLSession {
    public func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    public func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

// Output: (data: Data, response: URLResponse)
// Failure: URLError
```

Prefer `async/await` in new code. `dataTaskPublisher` is useful when integrating with existing Combine pipelines (e.g., chaining network results into a `@Published` property via `sink`).

---

## Key Points

- `URLSession.shared.data(for:)` is the only URLSession API Vibology uses
- `URLResponse` must be cast to `HTTPURLResponse` to read `statusCode` — this never throws automatically on 4xx/5xx
- Use `decoder.keyDecodingStrategy = .convertFromSnakeCase` for all Cartographer responses
- Set `request.timeoutInterval = 30` — appropriate for Cloud Run (handles cold starts)
- Wrap calls in a Swift `actor` (`CartographerService`) to avoid data races
- Propagate `CancellationError` silently — it means the user navigated away
