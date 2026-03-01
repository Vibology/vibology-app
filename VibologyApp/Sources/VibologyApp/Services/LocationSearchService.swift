import MapKit
import Observation

@Observable
@MainActor
final class LocationSearchService {
    var suggestions: [PlaceSuggestion] = []

    @ObservationIgnored private let completer = MKLocalSearchCompleter()
    @ObservationIgnored private var _delegate: _Delegate?

    init() {
        let d = _Delegate { [weak self] results in
            self?.suggestions = results
        }
        _delegate = d
        completer.delegate = d
        completer.resultTypes = .address
    }

    func search(_ query: String, country: String) {
        guard !query.isEmpty else { suggestions = []; completer.queryFragment = ""; return }
        completer.queryFragment = country.isEmpty ? query : "\(query), \(country)"
    }

    func clear() {
        suggestions = []
        completer.queryFragment = ""
    }
}

// MARK: - Supporting types

struct PlaceSuggestion: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let subtitle: String
    var display: String { subtitle.isEmpty ? title : "\(title), \(subtitle)" }
}

// MARK: - Delegate shim
// _Delegate is immutable after init and only ever called on the main thread,
// so @unchecked Sendable is safe.

private final class _Delegate: NSObject, MKLocalSearchCompleterDelegate, @unchecked Sendable {
    let callback: @MainActor ([PlaceSuggestion]) -> Void

    init(callback: @escaping @MainActor ([PlaceSuggestion]) -> Void) {
        self.callback = callback
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = Array(completer.results.prefix(6).map {
            PlaceSuggestion(title: $0.title, subtitle: $0.subtitle)
        })
        let cb = callback
        Task { @MainActor in cb(results) }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        let cb = callback
        Task { @MainActor in cb([]) }
    }
}
