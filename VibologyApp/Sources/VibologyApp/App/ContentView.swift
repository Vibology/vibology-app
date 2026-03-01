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

            case .loaded(let hdData):
                BodygraphView(data: hdData)
                    .frame(minWidth: 360, idealWidth: 480, minHeight: 500)
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
