import SwiftUI

struct ContentView: View {
    @State private var vm = BlueprintViewModel()
    @State private var chartTab = 0

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
                GeometryReader { geo in
                    let scale = max(0.6, geo.size.height / 700.0)
                    VStack(spacing: 0) {
                        Picker("Chart", selection: $chartTab) {
                            Text("Bodygraph").tag(0)
                            Text("Astrology").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)

                        if chartTab == 0 {
                            HStack(alignment: .top, spacing: 8) {
                                PlanetColumnView(planets: blueprint.humanDesign.planets.design,
                                                 isDesign: true,  scale: scale)
                                BodygraphView(data: blueprint.humanDesign, scale: scale)
                                PlanetColumnView(planets: blueprint.humanDesign.planets.personality,
                                                 isDesign: false, scale: scale)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            AstrologyWheelView(data: blueprint.astrology)
                                .padding(8)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(minWidth: 620, idealWidth: 820, minHeight: 500)
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
