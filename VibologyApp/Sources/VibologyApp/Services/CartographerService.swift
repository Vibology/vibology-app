import Foundation

// MARK: - Errors

enum CartographerError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int, body: String?)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Unexpected response from Cartographer"
        case .httpError(let code, let body):
            if let body {
                return "Cartographer returned HTTP \(code): \(body)"
            }
            return "Cartographer returned HTTP \(code)"
        }
    }
}

// MARK: - Service

actor CartographerService {
    static let shared = CartographerService()

    private let baseURL = URL(string: "https://cartographer-273583413962.us-central1.run.app")!

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private let encoder = JSONEncoder()

    func blueprint(_ request: BlueprintRequest) async throws -> BlueprintResponse {
        let url = baseURL.appendingPathComponent("blueprint")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.timeoutInterval = 30
        req.httpBody = try encoder.encode(request)

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw CartographerError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw CartographerError.httpError(
                statusCode: http.statusCode,
                body: String(data: data, encoding: .utf8)
            )
        }

        return try decoder.decode(BlueprintResponse.self, from: data)
    }
}
