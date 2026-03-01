# Observation Framework Reference

> Extracted from Xcode 26.2 SDK (macOS 26.2 / Swift 6.2)
> Module: `Observation` (swiftlang-6.2.3.3.2)
> Availability: macOS 14.0+ / iOS 17.0+ — `@Observable` is the canonical ViewModel pattern for macOS 26

---

## Table of Contents

1. [Overview](#overview)
2. [Full API](#full-api)
   - [Observable Protocol](#observable-protocol)
   - [@Observable Macro](#observable-macro)
   - [@ObservationTracked and @ObservationIgnored](#observationtracked-and-observationignored)
   - [ObservationRegistrar](#observationregistrar)
   - [withObservationTracking](#withobservationtracking)
   - [Observations (macOS 26 AsyncSequence)](#observations-macos-26-asyncsequence)
3. [SwiftUI Integration](#swiftui-integration)
   - [@State for Owned Models](#state-for-owned-models)
   - [@Bindable for Mutable Binding](#bindable-for-mutable-binding)
   - [No Wrapper for Passed-In Objects](#no-wrapper-for-passed-in-objects)
   - [@Environment with Observable](#environment-with-observable)
4. [Comparison: @Observable vs ObservableObject](#comparison-observable-vs-observableobject)
5. [Vibology ViewModel Patterns](#vibology-viewmodel-patterns)
   - [HubViewModel](#hubviewmodel)
   - [ClientDetailViewModel](#clientdetailviewmodel)
   - [EphemerisViewModel](#ephemerisviewmodel)
   - [SynthesisService](#synthesisservice)
6. [Combine Interoperability](#combine-interoperability)
7. [Thread Safety and @MainActor](#thread-safety-and-mainactor)
8. [Migration: ObservableObject to @Observable](#migration-observableobject-to-observable)
9. [Common Pitfalls](#common-pitfalls)

---

## Overview

The `Observation` framework (introduced in macOS 14 / Swift 5.9, refined in Swift 6.2) replaces the `ObservableObject + @Published` pattern with a macro-based system that provides per-property granularity. SwiftUI redraws only the views that read the specific properties that changed, rather than redrawing every view that holds a reference to the object.

For Vibology on macOS 26, **use `@Observable` for all new ViewModels and services**. The `ObservableObject` protocol remains in the SDK and is still valid, but it is the legacy path. Do not mix the two systems on the same type.

**Key mental model shift:**

- `ObservableObject` publishes a single `objectWillChange` signal for the entire object; every observing view re-renders on any change.
- `@Observable` synthesizes per-property access tracking; a view re-renders only when a property it actually *read* during its last render pass changes.

---

## Full API

### Observable Protocol

*macOS 14.0, iOS 17.0 — module `Observation`*

```swift
public protocol Observable {}
```

A marker protocol. Types that conform are eligible for observation tracking. The `@Observable` macro automatically synthesizes conformance. You can also conform manually (rare) and implement the registrar calls yourself.

`Observable` carries no required methods — its presence is a signal to the runtime and to SwiftUI that the type participates in the observation system.

---

### @Observable Macro

*macOS 14.0, iOS 17.0*

```swift
@attached(member, names: named(_$observationRegistrar), named(access), named(withMutation), named(shouldNotifyObservers))
@attached(memberAttribute)
@attached(extension, conformances: Observation.Observable)
public macro Observable()
```

Apply `@Observable` to a class to opt into observation. The macro:

1. Adds a hidden `_$observationRegistrar: ObservationRegistrar` stored property.
2. Synthesizes `access(_:keyPath:)` and `withMutation(_:keyPath:_:)` wrapper calls on every stored property.
3. Adds conformance to `Observable`.
4. Marks all stored properties with `@ObservationTracked` (see below).

**Canonical declaration pattern:**

```swift
import Observation

@Observable
final class HubViewModel {
    var clients: [Client] = []
    var selectedClient: Client?
    var isLoading = false
    var errorMessage: String?

    // Dependencies injected at init — not tracked
    @ObservationIgnored private let cartographerService: CartographerService
    @ObservationIgnored private let database: DatabaseService

    init(cartographerService: CartographerService, database: DatabaseService) {
        self.cartographerService = cartographerService
        self.database = database
    }
}
```

The macro expands the above into roughly:

```swift
final class HubViewModel: Observable {
    private let _$observationRegistrar = ObservationRegistrar()

    private var _clients: [Client] = []
    var clients: [Client] {
        get {
            _$observationRegistrar.access(self, keyPath: \.clients)
            return _clients
        }
        set {
            _$observationRegistrar.withMutation(of: self, keyPath: \.clients) {
                _clients = newValue
            }
        }
    }
    // … same for other stored properties
}
```

This expansion is invisible to the caller but explains why **no `@Published` annotation is needed** — the macro generates the observation hooks directly on the getter and setter.

---

### @ObservationTracked and @ObservationIgnored

*macOS 14.0, iOS 17.0*

```swift
// Adds observation tracking accessors — applied automatically by @Observable to all stored properties
@attached(accessor, names: named(init), named(get), named(set), named(_modify))
@attached(peer, names: prefixed(`_`))
public macro ObservationTracked()

// Opts a stored property OUT of observation — applied manually
@attached(accessor)
public macro ObservationIgnored()
```

**`@ObservationIgnored`** is the escape hatch for properties that should not trigger re-renders. Use it for:

- Injected dependencies (services, database handles)
- Caches and memoized values that are always recomputed
- Combine `AnyCancellable` bags
- Anything that is mutated without semantic relevance to the view

```swift
@Observable
final class EphemerisViewModel {
    var notes: [EphemerisNote] = []
    var searchText = ""

    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    @ObservationIgnored private let grdb: DatabaseService
}
```

---

### ObservationRegistrar

*macOS 14.0, iOS 17.0*

```swift
public struct ObservationRegistrar: Sendable, Codable, Hashable {
    public init()

    // Called in the getter of each observed property
    public func access<Subject, Member>(
        _ subject: Subject,
        keyPath: KeyPath<Subject, Member>
    ) where Subject: Observable

    // Called before a mutation begins
    public func willSet<Subject, Member>(
        _ subject: Subject,
        keyPath: KeyPath<Subject, Member>
    ) where Subject: Observable

    // Called after a mutation completes
    public func didSet<Subject, Member>(
        _ subject: Subject,
        keyPath: KeyPath<Subject, Member>
    ) where Subject: Observable

    // Preferred: wraps willSet + mutation + didSet atomically
    public func withMutation<Subject, Member, T>(
        of subject: Subject,
        keyPath: KeyPath<Subject, Member>,
        _ mutation: () throws -> T
    ) rethrows -> T where Subject: Observable
}
```

`ObservationRegistrar` is the runtime bookkeeper. It is always created by `@Observable` automatically. You interact with it directly only when implementing observation manually (uncommon).

The `Sendable` conformance means the registrar is safe to hold on `@MainActor` types. It is not a Combine publisher — it has no `sink` or `subscribe` API.

---

### withObservationTracking

*macOS 14.0, iOS 17.0*

```swift
public func withObservationTracking<T>(
    _ apply: () -> T,
    onChange: @autoclosure () -> @Sendable () -> Void
) -> T
```

The non-SwiftUI entry point for observation. Executes `apply`, tracking every `Observable` property accessed during execution. When any tracked property later changes, `onChange` is called exactly once on an unspecified thread.

**The `onChange` closure fires once and does not re-register.** To create a continuous loop, re-call `withObservationTracking` inside the `onChange` closure.

```swift
// Drive a non-SwiftUI component (e.g. AppKit layer, background task)
func observeSearchText(viewModel: EphemerisViewModel) {
    func track() {
        withObservationTracking {
            _ = viewModel.searchText  // registers access
        } onChange: {
            Task { @MainActor in
                self.performSearch(query: viewModel.searchText)
                track()  // re-register for next change
            }
        }
    }
    track()
}
```

Use this when driving non-SwiftUI layers: AppKit delegates, background processing pipelines, or test harnesses.

---

### Observations (macOS 26 AsyncSequence)

*macOS 26.0, iOS 26.0 — new in Swift 6.2*

```swift
public struct Observations<Element, Failure>: AsyncSequence, Sendable
    where Element: Sendable, Failure: Error
{
    public enum Iteration: Sendable {
        case next(Element)
        case finish
    }

    public init(
        _ emit: @escaping @isolated(any) @Sendable () throws(Failure) -> Element
    )

    public static func untilFinished(
        _ emit: @escaping @isolated(any) @Sendable () throws(Failure) -> Iteration
    ) -> Observations<Element, Failure>
}
```

`Observations` is a Swift 6.2 addition that wraps repeated `withObservationTracking` calls into an `AsyncSequence`. It provides a clean `for await` interface for driving observation loops in Swift Concurrency contexts.

```swift
// Emit a new value every time viewModel.searchText changes
let stream = Observations {
    viewModel.searchText
}

for await query in stream {
    await performSearch(query: query)
}
```

`Observations.untilFinished` allows the closure to signal completion by returning `.finish` instead of `.next(value)`.

---

## SwiftUI Integration

SwiftUI's observation integration lives in `SwiftUICore` (available macOS 14+). The three relevant property wrappers have distinct roles depending on where the `@Observable` object lives relative to the view hierarchy.

### @State for Owned Models

When a **view creates and owns** the model object, use `@State`. The view controls the lifetime of the object.

```swift
// SwiftUICore declaration (macOS 14+):
// internal init(wrappedValue thunk: @autoclosure @escaping () -> Value)
//     where Value: AnyObject, Value: Observable

struct ClientListView: View {
    @State private var viewModel = HubViewModel(
        cartographerService: .shared,
        database: .shared
    )

    var body: some View {
        List(viewModel.clients) { client in
            ClientRow(client: client)
        }
        .task { await viewModel.loadClients() }
    }
}
```

`@State` with an `@Observable` class stores the instance in the SwiftUI identity graph (not on the stack), ensuring it survives view re-renders. **Do not use `@StateObject`** — that is for `ObservableObject` only.

### @Bindable for Mutable Binding

When you need to **derive `Binding<T>` from an `@Observable` object's properties** — for example to pass to a `TextField` or `Toggle` — use `@Bindable`.

```swift
// SwiftUICore declaration:
// @dynamicMemberLookup @propertyWrapper public struct Bindable<Value>
// extension Bindable where Value: AnyObject, Value: Observable {
//     public init(wrappedValue: Value)
//     public init(_ wrappedValue: Value)
// }
// extension Bindable where Value: AnyObject {
//     public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>)
//         -> Binding<Subject> { get }
// }

struct ClientDetailView: View {
    @Bindable var viewModel: ClientDetailViewModel  // passed in from parent

    var body: some View {
        Form {
            TextField("Name", text: $viewModel.clientName)  // $viewModel.clientName is a Binding<String>
            DatePicker("Birth Date", selection: $viewModel.birthDate, displayedComponents: .date)
        }
    }
}
```

`@Bindable` can also be used as a local wrapper to extract bindings from an already-held reference without changing property wrapper semantics:

```swift
struct SomeView: View {
    var viewModel: ClientDetailViewModel  // no wrapper — just a reference

    var body: some View {
        @Bindable var vm = viewModel   // local @Bindable to derive bindings
        TextField("Name", text: $vm.clientName)
    }
}
```

**`@Bindable` is explicitly unavailable on `ObservableObject` types** — the SDK marks that overload `@available(*, unavailable, message: "@Bindable only works with Observable types. For ObservableObject types, use @ObservedObject instead.")`.

### No Wrapper for Passed-In Objects

When a parent view **passes an `@Observable` object down** and the child only reads from it (no bindings needed), use **no property wrapper at all**. SwiftUI's view rendering machinery tracks property accesses automatically — any property the view's `body` reads will cause a re-render when it changes.

```swift
// Parent creates and owns the model
struct HubView: View {
    @State private var viewModel = HubViewModel(...)

    var body: some View {
        NavigationSplitView {
            ClientSidebar(viewModel: viewModel)   // passed by reference, no wrapper needed
        } detail: {
            SynthesisPanel(viewModel: viewModel)
        }
    }
}

// Child reads from it — no @ObservedObject, no @Bindable needed
struct ClientSidebar: View {
    var viewModel: HubViewModel  // plain stored property

    var body: some View {
        List(viewModel.clients) { client in   // access to .clients is tracked automatically
            Text(client.name)
        }
    }
}
```

Contrast this with the old pattern, where `@ObservedObject var viewModel: HubViewModel` would have been required. The wrapper is now unnecessary because SwiftUI tracks accesses at read time rather than through explicit subscription.

### @Environment with Observable

`@Environment` gains an `init(_ objectType:)` overload for `Observable` types (macOS 14+). This replaces `@EnvironmentObject` for the new system.

```swift
// SwiftUICore declarations:
// extension Environment {
//     public init(_ objectType: Value.Type) where Value: AnyObject, Value: Observable
//     public init<T>(_ objectType: T.Type) where Value == T?, T: AnyObject, T: Observable
// }
// extension View {
//     nonisolated public func environment<T>(_ object: T?) -> some View
//         where T: AnyObject, T: Observable
// }
// extension EnvironmentValues {
//     public subscript<T>(objectType: T.Type) -> T?
//         where T: AnyObject, T: Observable { get set }
// }

// Injecting at the scene level:
@main
struct VibologyApp: App {
    @State private var synthesisService = SynthesisService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(synthesisService)  // Observable overload, no key needed
        }
    }
}

// Reading from the environment:
struct SynthesisPanel: View {
    @Environment(SynthesisService.self) private var synthesisService

    var body: some View {
        Text(synthesisService.currentSynthesis ?? "No synthesis active")
    }
}
```

The type-keyed subscript (`EnvironmentValues[SynthesisService.self]`) stores at most one instance per type. If no parent injects the object, reading it returns `nil` (when declared as `@Environment(T?.self)`) or crashes at runtime (when declared as `@Environment(T.self)`). Prefer the optional form when the value may legitimately be absent.

**Do not use `@EnvironmentObject`** with `@Observable` types — that property wrapper requires `ObservableObject` conformance.

---

## Comparison: @Observable vs ObservableObject

| Aspect | `@Observable` | `ObservableObject + @Published` |
|---|---|---|
| **Availability** | macOS 14+ / iOS 17+ | macOS 10.15+ / iOS 13+ |
| **Type** | Class only | Class only (`AnyObject`) |
| **Granularity** | Per-property access tracking | Whole-object `objectWillChange` signal |
| **View re-render scope** | Only views that read the changed property | All views holding the object |
| **Property annotation** | None needed (macro handles it) | `@Published` on every reactive property |
| **`@Published` dollar sign** | Not available | `$property` is a `Publisher` |
| **SwiftUI owner wrapper** | `@State` | `@StateObject` |
| **SwiftUI reference wrapper** | None (plain `var`) | `@ObservedObject` |
| **SwiftUI binding** | `@Bindable` | `@ObservedObject` (projectedValue) |
| **Environment injection** | `.environment(_:)` (type-keyed) | `.environmentObject(_:)` |
| **Environment reading** | `@Environment(T.self)` | `@EnvironmentObject` |
| **Combine interop** | Not native — requires manual bridge | Native via `objectWillChange`, `@Published.Publisher` |
| **Thread safety** | Requires explicit `@MainActor` | Requires explicit `@MainActor` |
| **Subclassing** | Supported, but subclass must also be `@Observable` or conform manually | Supported |
| **Protocol conformance** | `Observable` (marker) | `ObservableObject` (has `objectWillChange`) |
| **`objectWillChange` publisher** | Absent | `ObservableObjectPublisher` |

**When to use `@Observable`:** All new Vibology ViewModels and services. This is the canonical pattern on macOS 14+.

**When to keep `ObservableObject`:** When a type needs direct Combine integration — for example, a service that emits values to `.sink` subscribers in non-SwiftUI code, or when you need to be deployment-target compatible with macOS 13 or earlier. In Vibology's case, the minimum deployment target is macOS 26, so there is no reason to use `ObservableObject` for new code.

**Never mix both on the same type.** A class that is both `@Observable` and `ObservableObject` will compile but produce undefined re-render behavior.

---

## Vibology ViewModel Patterns

All Vibology ViewModels follow this structure:

- `@Observable final class`, isolated to `@MainActor`
- Dependencies injected at `init` and marked `@ObservationIgnored`
- State as plain `var` properties (no `@Published`)
- Async methods for network/database operations
- `@ObservationIgnored private var cancellables` for any Combine subscriptions

### HubViewModel

The root-level ViewModel owned by `ContentView`. Manages the client list and navigation state.

```swift
import Observation
import Foundation

@Observable
@MainActor
final class HubViewModel {
    // Observed state — drives sidebar and navigation
    var clients: [Client] = []
    var selectedClientID: Client.ID?
    var isLoading = false
    var errorMessage: String?

    // Dependencies — never trigger re-renders
    @ObservationIgnored private let database: DatabaseService

    init(database: DatabaseService = .shared) {
        self.database = database
    }

    func loadClients() async {
        isLoading = true
        errorMessage = nil
        do {
            clients = try await database.fetchAllClients()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func deleteClient(id: Client.ID) async {
        do {
            try await database.deleteClient(id: id)
            clients.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

**Usage in view:**

```swift
struct ContentView: View {
    @State private var viewModel = HubViewModel()

    var body: some View {
        NavigationSplitView {
            ClientSidebar(viewModel: viewModel)
        } detail: {
            if let id = viewModel.selectedClientID,
               let client = viewModel.clients.first(where: { $0.id == id }) {
                ClientDetailView(client: client)
            } else {
                Text("Select a client")
            }
        }
        .task { await viewModel.loadClients() }
    }
}
```

### ClientDetailViewModel

Manages the session workflow for a single client: calling Cartographer, pulling Tarot, and assembling the synthesis view.

```swift
@Observable
@MainActor
final class ClientDetailViewModel {
    // Observed — views read these directly
    var client: Client
    var blueprint: BlueprintResponse?
    var selectedTarotCards: [TarotCard] = []
    var synthesisMarkdown: String = ""
    var isCalculating = false
    var errorMessage: String?

    @ObservationIgnored private let cartographer: CartographerService
    @ObservationIgnored private let database: DatabaseService

    init(
        client: Client,
        cartographer: CartographerService = .shared,
        database: DatabaseService = .shared
    ) {
        self.client = client
        self.cartographer = cartographer
        self.database = database
    }

    func calculateBlueprint() async {
        guard let birthData = client.birthData else { return }
        isCalculating = true
        errorMessage = nil
        do {
            blueprint = try await cartographer.fetchBlueprint(for: birthData)
        } catch {
            errorMessage = error.localizedDescription
        }
        isCalculating = false
    }

    func selectCard(_ card: TarotCard) async {
        selectedTarotCards.append(card)
        // GRDB join: card ID → Obsidian note
        if let note = try? await database.fetchNote(for: card.id) {
            synthesisMarkdown += "\n\n" + note.content
        }
    }
}
```

**Note on `@Bindable` in the detail view:**

```swift
struct ClientDetailView: View {
    @Bindable var viewModel: ClientDetailViewModel

    var body: some View {
        VStack {
            TextField("Client Name", text: $viewModel.client.name)
            // $viewModel.client.name is a Binding<String> via @Bindable's dynamic member lookup
            if viewModel.isCalculating {
                ProgressView("Calculating...")
            }
        }
    }
}
```

### EphemerisViewModel

Manages the Ephemeris browser: full-text search across the Obsidian note index in Turso.

```swift
@Observable
@MainActor
final class EphemerisViewModel {
    var notes: [EphemerisNote] = []
    var searchText = ""
    var isSearching = false

    @ObservationIgnored private let database: DatabaseService
    @ObservationIgnored private var searchTask: Task<Void, Never>?

    init(database: DatabaseService = .shared) {
        self.database = database
    }

    // Debounced search — cancel previous task before launching new one
    func onSearchTextChanged() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await performSearch()
        }
    }

    private func performSearch() async {
        isSearching = true
        do {
            notes = try await database.searchNotes(query: searchText)
        } catch {
            notes = []
        }
        isSearching = false
    }
}
```

**Triggering the debounce from a view:**

```swift
struct EphemerisView: View {
    @State private var viewModel = EphemerisViewModel()

    var body: some View {
        List(viewModel.notes) { note in
            NoteRow(note: note)
        }
        .searchable(text: Binding(
            get: { viewModel.searchText },
            set: { viewModel.searchText = $0; viewModel.onSearchTextChanged() }
        ))
    }
}
```

Alternatively, use `onChange(of:)`:

```swift
.onChange(of: viewModel.searchText) {
    viewModel.onSearchTextChanged()
}
```

### SynthesisService

A shared service (not a ViewModel) that holds cross-session state and is injected via `@Environment`. Services that are `@Observable` follow the same pattern as ViewModels.

```swift
@Observable
@MainActor
final class SynthesisService {
    var currentSynthesis: String?
    var activeInstruments: Set<Instrument> = [.astrology, .humanDesign]

    @ObservationIgnored private let database: DatabaseService

    init(database: DatabaseService = .shared) {
        self.database = database
    }

    func toggleInstrument(_ instrument: Instrument) {
        if activeInstruments.contains(instrument) {
            activeInstruments.remove(instrument)
        } else {
            activeInstruments.insert(instrument)
        }
    }
}
```

**Injection and reading:**

```swift
// App root
WindowGroup {
    ContentView()
        .environment(SynthesisService())
}

// Any descendant view
struct InstrumentPicker: View {
    @Environment(SynthesisService.self) private var synthesisService

    var body: some View {
        // Reading activeInstruments — tracked automatically
        ForEach(Instrument.allCases) { instrument in
            Toggle(
                instrument.displayName,
                isOn: Binding(
                    get: { synthesisService.activeInstruments.contains(instrument) },
                    set: { _ in synthesisService.toggleInstrument(instrument) }
                )
            )
        }
    }
}
```

---

## Combine Interoperability

`@Observable` has no native Combine integration. There is no `objectWillChange` publisher and no `$property` publisher syntax. If you need Combine publishers from an `@Observable` type, bridge manually using one of the following patterns.

### Pattern 1: Subject Bridge

Use a `PassthroughSubject` or `CurrentValueSubject` as a side-channel. Mark it `@ObservationIgnored` so it does not itself trigger re-renders.

```swift
@Observable
@MainActor
final class CartographerService {
    var latestBlueprint: BlueprintResponse?

    // Combine bridge for legacy consumers
    @ObservationIgnored
    let blueprintPublisher = PassthroughSubject<BlueprintResponse, Never>()

    func fetchBlueprint(for birthData: BirthData) async throws -> BlueprintResponse {
        let result = try await performNetworkRequest(birthData)
        latestBlueprint = result
        blueprintPublisher.send(result)   // notify Combine subscribers
        return result
    }
}
```

### Pattern 2: withObservationTracking → Subject

Wrap `withObservationTracking` to push values into a Combine subject whenever a specific property changes. This is useful for bridging a single property to a Combine pipeline.

```swift
extension Observable {
    /// Creates a publisher that emits when the given keyPath changes.
    @MainActor
    static func publisher<T: Observable & AnyObject, V>(
        for object: T,
        keyPath: KeyPath<T, V>
    ) -> AnyPublisher<V, Never> where V: Sendable {
        let subject = PassthroughSubject<V, Never>()

        @Sendable func observe() {
            withObservationTracking {
                _ = object[keyPath: keyPath]
            } onChange: {
                Task { @MainActor in
                    subject.send(object[keyPath: keyPath])
                    observe()
                }
            }
        }
        observe()
        return subject.eraseToAnyPublisher()
    }
}

// Usage:
let searchPublisher = Observable.publisher(for: viewModel, keyPath: \.searchText)
searchPublisher
    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    .sink { query in performSearch(query: query) }
    .store(in: &cancellables)
```

### Pattern 3: Observations AsyncSequence (macOS 26)

On macOS 26, prefer `Observations` over the Combine bridge for new code. It is a first-party async alternative.

```swift
@MainActor
func observeSearchText(viewModel: EphemerisViewModel) async {
    let searchStream = Observations { viewModel.searchText }
    for await query in searchStream {
        await viewModel.performSearch(for: query)
    }
}
```

### What Combine is still good for in Vibology

- **GRDB reactive queries** — GRDB's `ValueObservation.publisher(in:)` is a Combine publisher; it drives the Ephemeris index updates.
- **Network request chaining** — Existing `URLSession.DataTaskPublisher` pipelines remain valid.
- **FSEvents feed** — The FSEvents watcher emits through a `PassthroughSubject`.

These Combine pipelines can assign their output to `@Observable` properties via `.assign(to:)` or `.sink`:

```swift
// GRDB publisher → @Observable property
grdb.clientsPublisher
    .receive(on: DispatchQueue.main)
    .sink { [weak self] clients in
        self?.clients = clients
    }
    .store(in: &cancellables)
```

---

## Thread Safety and @MainActor

`@Observable` provides no automatic thread isolation. The observation registrar is `Sendable`, but the class itself may be mutated from any thread unless explicitly constrained.

**Always annotate Vibology ViewModels with `@MainActor`**:

```swift
@Observable
@MainActor
final class HubViewModel { ... }
```

`@MainActor` ensures:

1. All property accesses and mutations happen on the main thread, so SwiftUI re-renders are correctly dispatched.
2. Swift 6 strict concurrency checking enforces this — accessing the ViewModel from a non-`@MainActor` context is a compile error.

**Async methods are fine.** Swift's structured concurrency suspends on the main actor, performs async work on a background executor, and resumes on the main actor:

```swift
@MainActor
func loadClients() async {
    isLoading = true               // main thread — safe
    let result = try? await database.fetchAllClients()  // suspends, background work
    clients = result ?? []         // resumed on main thread — safe
    isLoading = false
}
```

**Do not use `DispatchQueue.main.async` inside `@MainActor` methods.** It is redundant and can cause ordering issues with SwiftUI's render scheduling.

**`ObservationRegistrar` is `Sendable`** — it is safe to hold on a `@MainActor` type and have its internal bookkeeping happen across threads.

---

## Migration: ObservableObject to @Observable

The conversion is mechanical and can be done incrementally — both systems coexist in the same app.

### Step-by-step

**Before (ObservableObject):**

```swift
import Combine

final class EphemerisViewModel: ObservableObject {
    @Published var notes: [EphemerisNote] = []
    @Published var searchText = ""
    @Published var isSearching = false

    private var cancellables: Set<AnyCancellable> = []
    private let database: DatabaseService

    init(database: DatabaseService) {
        self.database = database
    }
}
```

**SwiftUI usage (before):**

```swift
struct EphemerisView: View {
    @StateObject private var viewModel = EphemerisViewModel(database: .shared)
    // or: @ObservedObject var viewModel: EphemerisViewModel
}
```

**After (@Observable):**

```swift
import Observation

@Observable
@MainActor
final class EphemerisViewModel {
    var notes: [EphemerisNote] = []      // drop @Published
    var searchText = ""
    var isSearching = false

    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    @ObservationIgnored private let database: DatabaseService

    init(database: DatabaseService) {
        self.database = database
    }
}
```

**SwiftUI usage (after):**

```swift
struct EphemerisView: View {
    @State private var viewModel = EphemerisViewModel(database: .shared)
    // or (passed in, no binding needed): var viewModel: EphemerisViewModel
    // or (needs binding):               @Bindable var viewModel: EphemerisViewModel
}
```

### Migration Checklist

| Old | New |
|---|---|
| `: ObservableObject` | `@Observable` (macro handles conformance) |
| `@Published var x` | `var x` (plain stored property) |
| `@StateObject` | `@State` |
| `@ObservedObject` | No wrapper (plain `var`) |
| `@EnvironmentObject` | `@Environment(T.self)` |
| `.environmentObject(_:)` | `.environment(_:)` |
| `$viewModel.property` (two-level) | `@Bindable var vm = viewModel; $vm.property` |
| `objectWillChange.send()` | Not needed — macro handles mutations |
| `AnyCancellable` bags | Keep, but mark `@ObservationIgnored` |

---

## Common Pitfalls

### 1. Accessing properties outside the `body` closure loses tracking

SwiftUI only tracks accesses that occur during the rendering of `body`. If you read a property in a `Task`, `onChange`, or `onAppear` closure, that access is not tracked and will not trigger a re-render.

```swift
// Wrong — reading inside a task does not register a tracked access for body
.task {
    print(viewModel.clients.count)  // not tracked
}

// Correct — bind the value into body directly
Text("\(viewModel.clients.count) clients")  // tracked
```

### 2. Capturing self in a non-isolated closure drops @MainActor

A closure passed to a non-`@MainActor` context (e.g., a network callback) captures `self` but may run off the main actor.

```swift
// Risky — closure isolation is unclear
URLSession.shared.dataTask(with: request) { data, _, _ in
    self.clients = parse(data)  // possible data race
}

// Safe — use async/await and structured concurrency
func loadClients() async {
    let data = try await URLSession.shared.data(from: url).0
    clients = parse(data)   // always on @MainActor via structured concurrency
}
```

### 3. Computed properties are not tracked

`@Observable` only synthesizes tracking hooks for **stored** properties. Computed properties do not get tracking wrappers, so views reading only a computed property will not re-render when its backing stored properties change — unless those stored properties are also read directly in body, or unless the computed property explicitly accesses them through the `_$observationRegistrar`.

```swift
@Observable
final class ViewModel {
    var firstName = ""
    var lastName = ""

    // This computed property is NOT tracked
    var fullName: String { "\(firstName) \(lastName)" }
}

struct NameView: View {
    var viewModel: ViewModel

    var body: some View {
        // This WILL re-render when firstName or lastName changes,
        // because accessing fullName reads the stored properties,
        // which triggers their tracked getters.
        Text(viewModel.fullName)
    }
}
```

In practice this works as expected because the computed property's getter reads the tracked stored properties. Be aware of cases where a computed property uses a cache or external state that does not go through the registrar.

### 4. Collection mutations must reassign, not mutate in place

The observation hook wraps the `set` accessor. Mutating a collection element in-place (subscript assignment on a stored `Array`) does invoke the setter and will trigger observation — but only for the top-level array property, not for changes to nested reference type elements.

```swift
// This triggers observation (setter on clients is called)
viewModel.clients.append(newClient)
viewModel.clients.removeAll { $0.id == id }

// This ALSO triggers observation for the array (subscript set goes through setter)
viewModel.clients[0].name = "Updated"  // triggers clients setter

// But if Client is a class (@Observable itself), changes to its properties
// are tracked separately — the parent ViewModel does NOT re-render for Client mutations
```

For nested `@Observable` models, changes to the nested object's properties are tracked by the nested object's own registrar, not the parent's.

### 5. Do not use @Published or objectWillChange.send() on @Observable types

The `@Published` property wrapper is defined in Combine and is unrelated to `@Observable`. Applying it to a property on an `@Observable` class compiles but does nothing for SwiftUI observation — the macro-generated tracking and `@Published`'s Combine machinery operate independently and will produce confusing double-notification behavior.

### 6. @Bindable requires Observable — it does not work with ObservableObject

The `@Bindable` struct has a compile-time unavailable overload for `ObservableObject` types. If you see the error `@Bindable only works with Observable types`, the type in question still conforms to `ObservableObject` instead of using `@Observable`.

### 7. @State with @Observable is not lazy — the initializer runs eagerly

Unlike `@StateObject`, which evaluates its `wrappedValue` closure lazily (only on first use), `@State` with an `@Observable` object is created when the view's identity is first established. Do not perform expensive work in the `@Observable` class initializer if the view may be conditionally shown.

```swift
// If HeavyViewModel.init() is expensive, this runs when the view tree is built
@State private var viewModel = HeavyViewModel()

// Prefer: move expensive setup to an async init method called from .task {}
```
