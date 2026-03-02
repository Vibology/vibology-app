import SwiftUI

struct BirthDataInputView: View {
    @Bindable var vm: BlueprintViewModel
    @State private var locationService = LocationSearchService()
    @FocusState private var focused: Field?
    @State private var suppressPlaceSearch = false

    enum Field: Hashable { case name, date, time, place }

    private var errorMessage: String? {
        guard case .error(let msg) = vm.state else { return nil }
        return msg
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                formFields
                    .padding(20)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.616, green: 0.847, blue: 0.969).opacity(0.45),
                                                Color(red: 0.722, green: 0.647, blue: 0.898).opacity(0.15)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    }
                if let msg = errorMessage {
                    Text(msg)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                generateButton
            }
            .padding(32)
        }
        .frame(width: 380)
        .background(
            LinearGradient(
                colors: [Color(red: 0.027, green: 0.027, blue: 0.102),
                         Color(red: 0.051, green: 0.043, blue: 0.149)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .tint(Color(red: 0.298, green: 0.788, blue: 0.941))
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 6) {
            Text("Vibology")
                .font(.system(size: 32, weight: .thin, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.616, green: 0.847, blue: 0.969),
                                 Color(red: 0.722, green: 0.647, blue: 0.898)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
            Text("Enter birth data to generate a chart")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Form

    private var formFields: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Name
            LabeledField("Name") {
                TextField("Full name", text: $vm.name)
                    .focused($focused, equals: .name)
                    .onSubmit { focused = .date }
            }

            // Birth Date
            LabeledField("Birth Date") {
                TextField("MM/DD/YYYY", text: $vm.dateText)
                    .focused($focused, equals: .date)
                    .onChange(of: vm.dateText) { _, new in vm.dateText = maskedDate(new) }
                    .onSubmit { focused = .time }
            }

            // Time
            LabeledField("Time") {
                TextField("HH:MM", text: $vm.timeText)
                    .focused($focused, equals: .time)
                    .onChange(of: vm.timeText) { _, new in vm.timeText = maskedTime(new) }
                    .onSubmit { focused = .place }
            }

            // Place
            LabeledField("Place") {
                VStack(alignment: .leading, spacing: 0) {
                    TextField("City, Country", text: $vm.place)
                        .focused($focused, equals: .place)
                        .onChange(of: vm.place) { _, new in
                            guard !suppressPlaceSearch else { suppressPlaceSearch = false; return }
                            locationService.search(new, country: "")
                        }
                        .onSubmit { locationService.clear() }
                    if !locationService.suggestions.isEmpty {
                        SuggestionList(items: locationService.suggestions) { s in
                            suppressPlaceSearch = true
                            vm.place = s.display
                            locationService.clear()
                        }
                    }
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }

    // MARK: - Generate Button

    private var generateButton: some View {
        Button {
            Task { await vm.generate() }
        } label: {
            Text("Generate Chart")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!vm.canGenerate)
    }
}

// MARK: - Masking helpers

private func maskedDate(_ input: String) -> String {
    let digits = input.filter(\.isNumber)
    var result = ""
    for (i, ch) in digits.prefix(8).enumerated() {
        if i == 2 || i == 4 { result += "/" }
        result.append(ch)
    }
    return result
}

private func maskedTime(_ input: String) -> String {
    let digits = input.filter(\.isNumber)
    var result = ""
    for (i, ch) in digits.prefix(4).enumerated() {
        if i == 2 { result += ":" }
        result.append(ch)
    }
    return result
}

// MARK: - LabeledField

private struct LabeledField<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content

    init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
    }
}

// MARK: - SuggestionList

private struct SuggestionList: View {
    let items: [PlaceSuggestion]
    let onSelect: (PlaceSuggestion) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items) { item in
                Button { onSelect(item) } label: {
                    Text(item.display)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if item.id != items.last?.id {
                    Divider().padding(.horizontal, 8)
                }
            }
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
        .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Color.secondary.opacity(0.25)))
        .padding(.top, 2)
    }
}
