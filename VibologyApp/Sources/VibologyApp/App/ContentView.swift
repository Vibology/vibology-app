import SwiftUI

struct ContentView: View {
    @State private var vm = BlueprintViewModel()

    var body: some View {
        Group {
            switch vm.state {
            case .input, .error:
                BirthDataInputView(vm: vm)
                    .frame(minWidth: 360, minHeight: 500)

            case .loading:
                VStack(spacing: 16) {
                    ProgressView()
                        .controlSize(.large)
                    Text("Calculating…")
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 360, minHeight: 500)

            case .loaded(let blueprint):
                TabView {
                    Tab("Bodygraph", systemImage: "person.fill") {
                        GeometryReader { geo in
                            let scale = max(0.6, geo.size.height / 700.0)
                            HStack(alignment: .top, spacing: 8) {
                                PlanetColumnView(planets: blueprint.humanDesign.planets.design,       isDesign: true,  scale: scale)
                                BodygraphView(data: blueprint.humanDesign, scale: scale)
                                PlanetColumnView(planets: blueprint.humanDesign.planets.personality, isDesign: false, scale: scale)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }

                    Tab("Astrology", systemImage: "sparkles") {
                        AstrologyWheelView(astrology: blueprint.astrology)
                    }
                }
                .frame(minWidth: 620, idealWidth: 800, minHeight: 500)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New Chart") { vm.reset() }
                    }
                }
            }
        }
        .padding()
    }
}
