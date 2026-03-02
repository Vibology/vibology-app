import Foundation
import CryptoKit

// MARK: - Blueprint Cache

/// Two-level cache (memory + disk) for BlueprintResponse objects.
/// Keyed by SHA-256 of the JSON-encoded BlueprintRequest so repeated
/// lookups for the same birth data are instant during development iteration.
/// No TTL — clear manually by deleting ~/Library/Caches/com.vibology.app/blueprints/
actor BlueprintCache {
    static let shared = BlueprintCache()

    private var mem: [String: BlueprintResponse] = [:]

    private let cacheDir: URL = {
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let dir = base.appendingPathComponent("com.vibology.app/blueprints", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private let encoder = JSONEncoder()

    // MARK: - Hash

    /// SHA-256 hex string of the JSON-encoded request.
    nonisolated func requestHash(_ req: BlueprintRequest) -> String {
        let data = (try? JSONEncoder().encode(req)) ?? Data()
        return SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Read

    func get(_ hash: String) -> BlueprintResponse? {
        if let hit = mem[hash] { return hit }
        let file = cacheDir.appendingPathComponent("\(hash).json")
        guard
            let data = try? Data(contentsOf: file),
            let response = try? decoder.decode(BlueprintResponse.self, from: data)
        else { return nil }
        mem[hash] = response
        return response
    }

    // MARK: - Write

    func set(_ hash: String, _ value: BlueprintResponse) {
        mem[hash] = value
        let file = cacheDir.appendingPathComponent("\(hash).json")
        if let data = try? encoder.encode(value) {
            try? data.write(to: file, options: .atomic)
        }
    }
}
