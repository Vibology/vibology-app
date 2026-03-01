import Foundation
import Observation

// MARK: - State

enum BlueprintState {
    case input
    case loading
    case loaded(HumanDesignData)
    case error(String)
}

// MARK: - ViewModel

@Observable
@MainActor
final class BlueprintViewModel {
    var name: String = ""
    var dateText: String = ""       // MM/DD/YYYY, digits auto-masked
    var timeText: String = ""       // HH:MM, digits auto-masked
    var country: String = ""
    var city: String = ""

    var countrySuggestions: [String] = []
    var state: BlueprintState = .input

    // MARK: - Validation

    var parsedDate: (year: Int, month: Int, day: Int)? {
        let d = dateText.filter(\.isNumber)
        guard d.count == 8 else { return nil }
        let mm = Int(d.prefix(2))!, dd = Int(d.dropFirst(2).prefix(2))!, yyyy = Int(d.dropFirst(4))!
        guard (1...12).contains(mm), (1...31).contains(dd), yyyy >= 1000 else { return nil }
        return (yyyy, mm, dd)
    }

    var parsedTime: (hour: Int, minute: Int)? {
        let t = timeText.filter(\.isNumber)
        guard t.count == 4 else { return nil }
        let hh = Int(t.prefix(2))!, mm = Int(t.dropFirst(2))!
        guard (0...23).contains(hh), (0...59).contains(mm) else { return nil }
        return (hh, mm)
    }

    var canGenerate: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        parsedDate != nil &&
        parsedTime != nil &&
        !country.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Country autocomplete (locale, no network)

    private static let allCountries: [String] = Locale.Region.isoRegions
        .compactMap { Locale.current.localizedString(forRegionCode: $0.identifier) }
        .sorted()

    func updateCountrySuggestions() {
        let q = country.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { countrySuggestions = []; return }
        countrySuggestions = Array(
            Self.allCountries.filter { $0.localizedCaseInsensitiveContains(q) }.prefix(6)
        )
    }

    // MARK: - Actions

    func generate() async {
        guard let d = parsedDate, let t = parsedTime else { return }
        let place = [city, country]
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")

        let req = BlueprintRequest(
            name: name.trimmingCharacters(in: .whitespaces),
            year: d.year, month: d.month, day: d.day,
            hour: t.hour, minute: t.minute,
            place: place
        )
        state = .loading
        do {
            let response = try await CartographerService.shared.blueprint(req)
            state = .loaded(response.humanDesign)
        } catch is CancellationError {
            state = .input
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func reset() {
        name = ""
        dateText = ""
        timeText = ""
        country = ""
        city = ""
        countrySuggestions = []
        state = .input
    }
}
