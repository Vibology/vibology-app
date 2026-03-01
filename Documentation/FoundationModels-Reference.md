# FoundationModels Framework Reference
> Extracted from macOS 26.2 SDK (Swift 6.2 / swiftlang-6.2.3.3.2)
> Module version: 1.1.7 · Package: com.apple.foundationmodels
> Last updated: February 2026

---

## Table of Contents

1. [Overview](#overview)
2. [Availability & Requirements](#availability--requirements)
3. [Quick Start](#quick-start)
4. [SystemLanguageModel](#systemlanguagemodel)
   - [Availability Enum](#availability-enum)
   - [UnavailableReason](#unavailablereason)
   - [Use Cases](#use-cases)
   - [Guardrails](#guardrails)
   - [Locale Support](#locale-support)
5. [LanguageModelSession](#languagemodelsession)
   - [Initializers](#initializers)
   - [Prewarm](#prewarm)
   - [respond Methods](#respond-methods)
   - [streamResponse Methods](#streamresponse-methods)
   - [Response Struct](#response-struct)
   - [Session Properties](#session-properties)
6. [Guided Generation](#guided-generation)
   - [@Generable Macro](#generable-macro)
   - [@Guide Macro](#guide-macro)
   - [Generable Protocol](#generable-protocol)
   - [ConvertibleFromGeneratedContent](#convertiblefromgeneratedcontent)
   - [ConvertibleToGeneratedContent](#convertibledtogeneratedcontent)
   - [Built-in Generable Conformances](#built-in-generable-conformances)
   - [GenerationGuide](#generationguide)
   - [GenerationSchema](#generationschema)
   - [DynamicGenerationSchema](#dynamicgenerationschema)
7. [Prompt & Instructions Builders](#prompt--instructions-builders)
   - [Prompt](#prompt)
   - [Instructions](#instructions)
   - [PromptBuilder](#promptbuilder)
   - [InstructionsBuilder](#instructionsbuilder)
8. [Streaming](#streaming)
   - [ResponseStream](#responsestream)
   - [Snapshot](#snapshot)
   - [collect()](#collect)
9. [Tool Use](#tool-use)
   - [Tool Protocol](#tool-protocol)
   - [Primitive Arguments Restriction](#primitive-arguments-restriction)
10. [Transcript](#transcript)
    - [Transcript.Entry](#transcriptentry)
    - [Transcript.Segment](#transcriptsegment)
    - [Transcript.TextSegment](#transcripttextsegment)
    - [Transcript.StructuredSegment](#transcriptstructuredsegment)
    - [Transcript.Instructions](#transcriptinstructions)
    - [Transcript.ToolDefinition](#transcripttooldefinition)
    - [Transcript.Prompt](#transcriptprompt)
    - [Transcript.ResponseFormat](#transcriptresponseformat)
    - [Transcript.ToolCalls & ToolCall](#transcripttoolcalls--toolcall)
    - [Transcript.ToolOutput](#transcripttooloutput)
    - [Transcript.Response](#transcriptresponse)
11. [GeneratedContent & GenerationID](#generatedcontent--generationid)
    - [GeneratedContent](#generatedcontent)
    - [GeneratedContent.Kind](#generatedcontentkind)
    - [GenerationID](#generationid)
12. [GenerationOptions & SamplingMode](#generationoptions--samplingmode)
13. [Errors](#errors)
    - [GenerationError](#generationerror)
    - [GenerationError.Refusal](#generationerrorrefusal)
    - [ToolCallError](#toolcallerror)
    - [GenerationSchema.SchemaError](#generationschemaschemaerror)
    - [Adapter.AssetError](#adapterasseterror)
14. [Adapters](#adapters)
    - [SystemLanguageModel.Adapter](#systemlanguagemodeladapter)
15. [Feedback](#feedback)
    - [LanguageModelFeedback](#languagemodelfeedback)
    - [Sentiment](#sentiment)
    - [Issue & Category](#issue--category)
    - [logFeedbackAttachment](#logfeedbackattachment)
16. [Practical Code Examples](#practical-code-examples)
    - [Basic Text Generation](#basic-text-generation)
    - [Streaming Responses](#streaming-responses)
    - [Guided Generation](#guided-generation-example)
    - [Tool Use](#tool-use-example)
    - [Availability Checking](#availability-checking)
    - [Session Prewarming](#session-prewarming)
    - [Error Handling](#error-handling)

---

## Overview

FoundationModels is Apple's on-device language model framework, introduced in iOS 26, macOS 26, and visionOS 26. It provides Swift-native access to the Apple Intelligence language model running locally on the device. All inference happens on-device — no network calls, no API keys.

Key capabilities:

- **Text generation** — freeform responses via `LanguageModelSession`
- **Guided generation** — structured output constrained to Swift types via `@Generable`, `@Guide`, and `GenerationSchema`
- **Streaming** — incremental output as `AsyncSequence` via `ResponseStream`
- **Tool use** — model-invoked Swift functions via the `Tool` protocol
- **Multi-turn sessions** — automatic transcript management across conversation turns
- **Adapters** — fine-tuned model weights distributed via the App Store

The framework integrates with Swift Concurrency (`async/await`, `AsyncSequence`) and the Observation framework (`@Observable`). All public types conform to `Sendable` where appropriate.

---

## Availability & Requirements

```
iOS 26.0+   macOS 26.0+   visionOS 26.0+
tvOS — unavailable
watchOS — unavailable
Swift 6.2+ / Xcode 26+
```

**Runtime requirements beyond OS version:**
The OS version check is necessary but not sufficient. The device must also satisfy the conditions described by `SystemLanguageModel.Availability`. Always check `SystemLanguageModel.default.availability` before creating a session. The model may be unavailable on eligible hardware if Apple Intelligence has not been enabled in Settings, or if the required model weights have not finished downloading.

---

## Quick Start

```swift
import FoundationModels

// 1. Verify the model is available
guard SystemLanguageModel.default.isAvailable else {
    print("Apple Intelligence not available")
    return
}

// 2. Create a session
let session = LanguageModelSession()

// 3. Generate a response
let response = try await session.respond(to: "What is the golden ratio?")
print(response.content)
// → "The golden ratio, approximately 1.618..."
```

---

## SystemLanguageModel

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
final public class SystemLanguageModel: Sendable, Observable
```

Represents the on-device Apple Intelligence language model. This class is `Observable` — use it directly in SwiftUI views to react to availability changes.

### Properties & Static Members

| Member | Type | Description |
|--------|------|-------------|
| `static let default` | `SystemLanguageModel` | The general-purpose model instance. Use this for most tasks. |
| `availability` | `Availability` | The current availability state. Observable. |
| `isAvailable` | `Bool` | Convenience: `availability == .available`. Observable. |
| `supportedLanguages` | `Set<Locale.Language>` | Languages the model can generate in. |

### Initializers

```swift
// Use a specific use case and guardrail level
convenience init(useCase: SystemLanguageModel.UseCase = .general,
                 guardrails: SystemLanguageModel.Guardrails = .default)

// Use a custom fine-tuned adapter
convenience init(adapter: SystemLanguageModel.Adapter,
                 guardrails: SystemLanguageModel.Guardrails = .default)
```

### Instance Methods

```swift
// Returns true if the model supports the given locale
func supportsLocale(_ locale: Locale = Locale.current) -> Bool
```

---

### Availability Enum

```swift
@frozen public enum Availability: Equatable, Sendable {
    case available
    case unavailable(UnavailableReason)
}
```

Use pattern matching to extract the reason when unavailable:

```swift
switch SystemLanguageModel.default.availability {
case .available:
    // proceed
case .unavailable(let reason):
    handleUnavailable(reason)
}
```

---

### UnavailableReason

```swift
public enum UnavailableReason: Equatable, Sendable, Hashable {
    case deviceNotEligible          // Hardware cannot run Apple Intelligence
    case appleIntelligenceNotEnabled // User has not enabled Apple Intelligence in Settings
    case modelNotReady              // Model weights are still downloading
}
```

| Case | User-Facing Action |
|------|--------------------|
| `.deviceNotEligible` | Cannot be resolved; inform user this feature requires a newer device |
| `.appleIntelligenceNotEnabled` | Deep-link to Settings → Apple Intelligence & Siri |
| `.modelNotReady` | Display a "downloading" progress indicator; retry later |

---

### Use Cases

```swift
public struct UseCase: Sendable, Equatable {
    public static let general: UseCase         // Full-capability general assistant (default)
    public static let contentTagging: UseCase  // Optimized for classification and tagging tasks
}
```

Use `.contentTagging` when the task is purely classification or labeling — it may use a lighter model path optimized for that workload.

---

### Guardrails

```swift
public struct Guardrails: Sendable {
    public static let `default`: Guardrails
    public static let permissiveContentTransformations: Guardrails
}
```

`Guardrails.default` applies Apple's standard content policies. `permissiveContentTransformations` relaxes restrictions on content transformation tasks (e.g., rewriting user-provided text that contains mature themes). This is intended for apps such as writing assistants where the app itself is responsible for content policy.

**Note:** If content violates guardrails at inference time, the session throws `GenerationError.guardrailViolation`.

---

### Locale Support

```swift
let model = SystemLanguageModel.default

// Check if the model supports the current device locale
if model.supportsLocale() {
    // Generate in the user's locale
}

// Check a specific locale
if model.supportsLocale(Locale(identifier: "fr-FR")) {
    // French is supported
}

// Enumerate all supported languages
for language in model.supportedLanguages {
    print(language.languageCode?.identifier ?? "unknown")
}
```

---

## LanguageModelSession

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
final public class LanguageModelSession: @unchecked Sendable, Observable
```

The central API surface for interacting with the model. Each session maintains a `Transcript` that accumulates the conversation history. Multiple turns in the same session share context — the model sees the full prior conversation on each call.

`LanguageModelSession` is `Observable` — `transcript` and `isResponding` can be observed in SwiftUI.

---

### Initializers

```swift
// Simplest — plain string instructions
convenience init(model: SystemLanguageModel = .default,
                 tools: [any Tool] = [],
                 instructions: String? = nil)

// Structured Instructions value
convenience init(model: SystemLanguageModel = .default,
                 tools: [any Tool] = [],
                 instructions: Instructions? = nil)

// Instructions DSL builder
convenience init(model: SystemLanguageModel = .default,
                 tools: [any Tool] = [],
                 @InstructionsBuilder instructions: () throws -> Instructions) rethrows

// Resume from an existing transcript (e.g. persisted session)
convenience init(model: SystemLanguageModel = .default,
                 tools: [any Tool] = [],
                 transcript: Transcript)
```

**Notes:**
- All initializers default to `SystemLanguageModel.default`. Pass a custom model to use an adapter or a specific use case.
- Tools registered at init are the only tools the model can call for the lifetime of the session.
- Instructions set the system-level persona or constraints. They appear as the first `Transcript.Entry.instructions` entry.

---

### Prewarm

```swift
func prewarm(promptPrefix: Prompt? = nil)
```

Hints to the system that this session will be used soon, allowing the runtime to load model weights into memory proactively. Call this when you know the user is likely to interact (e.g., a view is about to appear) but before the actual prompt is known.

Optionally pass a `promptPrefix` if you know the beginning of the prompt — this can allow more targeted cache warming.

This call is non-blocking and best-effort. It has no effect if the model is already warm.

```swift
// Prewarm as a view appears
.onAppear {
    session.prewarm()
}
```

---

### respond Methods

All `respond` variants are `async throws` and return `Response<Content>`. They append to the session's transcript automatically.

#### Plain text response

```swift
@discardableResult
nonisolated(nonsending) func respond(
    to prompt: Prompt,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<String>

// Convenience: pass a String directly
@discardableResult
nonisolated(nonsending) func respond(
    to prompt: String,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<String>

// DSL builder variant
@discardableResult
nonisolated(nonsending) func respond(
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder prompt: () throws -> Prompt
) async throws -> Response<String>
```

#### Structured response using GenerationSchema (dynamic schema)

```swift
@discardableResult
nonisolated(nonsending) func respond(
    to prompt: Prompt,
    schema: GenerationSchema,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<GeneratedContent>

// String prompt overload
@discardableResult
nonisolated(nonsending) func respond(
    to prompt: String,
    schema: GenerationSchema,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<GeneratedContent>

// Builder overload
@discardableResult
nonisolated(nonsending) func respond(
    schema: GenerationSchema,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder prompt: () throws -> Prompt
) async throws -> Response<GeneratedContent>
```

#### Typed structured response using @Generable type

```swift
@discardableResult
nonisolated(nonsending) func respond<Content: Generable>(
    to prompt: Prompt,
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<Content>

// String prompt overload
@discardableResult
nonisolated(nonsending) func respond<Content: Generable>(
    to prompt: String,
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) async throws -> Response<Content>

// Builder overload
@discardableResult
nonisolated(nonsending) func respond<Content: Generable>(
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder prompt: () throws -> Prompt
) async throws -> Response<Content>
```

**`includeSchemaInPrompt`** — when `true` (default), the framework appends a JSON schema description to the prompt, helping the model understand the expected output shape. Set to `false` if the schema is already described in your instructions.

---

### streamResponse Methods

All `streamResponse` variants return synchronously (no `async`) and produce a `ResponseStream<Content>` that is consumed with `for await`. The stream itself is `sending` under Swift 6 strict concurrency.

#### Plain text stream

```swift
func streamResponse(
    to prompt: Prompt,
    options: GenerationOptions = GenerationOptions()
) -> ResponseStream<String>

func streamResponse(
    to prompt: String,
    options: GenerationOptions = GenerationOptions()
) -> ResponseStream<String>

func streamResponse(
    options: GenerationOptions = GenerationOptions(),
    @PromptBuilder prompt: () throws -> Prompt
) rethrows -> ResponseStream<String>
```

#### Structured stream (GenerationSchema)

```swift
func streamResponse(
    to prompt: Prompt,
    schema: GenerationSchema,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) -> ResponseStream<GeneratedContent>

// String and builder overloads also exist
```

#### Typed structured stream (@Generable)

```swift
func streamResponse<Content: Generable>(
    to prompt: Prompt,
    generating type: Content.Type = Content.self,
    includeSchemaInPrompt: Bool = true,
    options: GenerationOptions = GenerationOptions()
) -> ResponseStream<Content>

// String and builder overloads also exist
```

---

### Response Struct

```swift
public struct Response<Content: Generable> {
    public let content: Content
    public let rawContent: GeneratedContent
    public let transcriptEntries: ArraySlice<Transcript.Entry>
}
```

| Property | Description |
|----------|-------------|
| `content` | The decoded, typed result. For plain text, this is `String`. |
| `rawContent` | The raw `GeneratedContent` tree before decoding. Useful for debugging schema conformance. |
| `transcriptEntries` | The slice of the session's `Transcript` that was added by this response (prompt + response entries). |

---

### Session Properties

| Property | Type | Description |
|----------|------|-------------|
| `transcript` | `Transcript` | The full conversation history. Starts empty (plus instructions, if any). Observable. |
| `isResponding` | `Bool` | `true` while a `respond` or `streamResponse` call is in flight. Observable. |

---

## Guided Generation

The guided generation system lets you constrain model output to match a Swift type. The model generates JSON that is decoded into your type — you get compile-time safety rather than parsing free text.

---

### @Generable Macro

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@attached(extension, conformances: Generable, names: named(init(_:)), named(generatedContent))
@attached(member, names: arbitrary)
public macro Generable(description: String? = nil)
```

Apply to any `struct` or `enum` to make it generable by the model. The macro synthesizes:
- `Generable` conformance (and thus `ConvertibleFromGeneratedContent` + `ConvertibleToGeneratedContent`)
- `init(_ content: GeneratedContent) throws`
- `var generatedContent: GeneratedContent`
- `static var generationSchema: GenerationSchema`

```swift
@Generable(description: "A synthesized astrological interpretation")
struct AstroReading {
    @Guide(description: "The dominant planetary influence at the time of birth")
    var dominantPlanet: String

    @Guide(description: "Overall energy quality", .anyOf(["receptive", "active", "transformative"]))
    var energyQuality: String

    @Guide(description: "Intensity on a scale of 1–10", .range(1...10))
    var intensity: Int

    var summary: String
}
```

**Rules:**
- All stored properties must themselves be `Generable` (or `Optional<Generable>`).
- Works on `struct` only at this time; `class` is not supported.
- Enum support: enums with raw `String` values are automatically generable as string enumerations.

---

### @Guide Macro

Three overloads for different constraint types.

#### Generable-constrained guide

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@attached(peer)
public macro Guide<T: Generable>(
    description: String? = nil,
    _ guides: GenerationGuide<T>...
)
```

#### Regex-constrained guide

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@attached(peer)
public macro Guide<RegexOutput>(
    description: String? = nil,
    _ guides: Regex<RegexOutput>
)
```

#### Description-only guide

```swift
@available(iOS 26.0, macOS 26.0, visionOS 26.0, *)
@attached(peer)
public macro Guide(description: String)
```

`@Guide` is always applied to a stored property inside a `@Generable` type. Multiple `GenerationGuide` values can be passed to the first overload — all constraints are applied simultaneously.

```swift
@Generable
struct CardReading {
    // Description only
    @Guide(description: "The card's symbolic meaning in this context")
    var interpretation: String

    // Constrained to a set of values
    @Guide(description: "Upright or reversed", .anyOf(["upright", "reversed"]))
    var orientation: String

    // Numeric range
    @Guide(description: "Shadow intensity from 0 to 100", .range(0...100))
    var shadowIntensity: Int

    // Regex pattern
    @Guide(description: "ISO 8601 date", /\d{4}-\d{2}-\d{2}/)
    var drawDate: String
}
```

---

### Generable Protocol

```swift
public protocol Generable: ConvertibleFromGeneratedContent, ConvertibleToGeneratedContent {
    associatedtype PartiallyGenerated: ConvertibleFromGeneratedContent = Self
    static var generationSchema: GenerationSchema { get }
}

extension Generable {
    public func asPartiallyGenerated() -> PartiallyGenerated
}
```

`PartiallyGenerated` is the type used during streaming snapshots. For most types, `PartiallyGenerated == Self`. For `Array<Element: Generable>`, `PartiallyGenerated == [Element.PartiallyGenerated]`, meaning you receive a partial array as generation proceeds.

Do not implement this protocol manually — use the `@Generable` macro.

---

### ConvertibleFromGeneratedContent

```swift
public protocol ConvertibleFromGeneratedContent: SendableMetatype {
    init(_ content: GeneratedContent) throws
}
```

Implemented automatically by `@Generable`. Can be implemented manually for custom decoding from `GeneratedContent`.

---

### ConvertibleToGeneratedContent

```swift
public protocol ConvertibleToGeneratedContent: InstructionsRepresentable, PromptRepresentable {
    var generatedContent: GeneratedContent { get }
}
```

Any type conforming to this protocol can be used as prompt or instructions content directly — the framework converts it to its `GeneratedContent` representation and embeds it in the prompt.

---

### Built-in Generable Conformances

The following standard library and Foundation types conform to `Generable` out of the box:

| Type | Notes |
|------|-------|
| `Bool` | JSON boolean |
| `String` | JSON string |
| `Int` | JSON integer |
| `Float` | JSON number |
| `Double` | JSON number |
| `Decimal` | JSON number (arbitrary precision) |
| `Array<Element: Generable>` | JSON array; `PartiallyGenerated = [Element.PartiallyGenerated]` |
| `Optional<Wrapped: Generable>` | JSON null or the wrapped value |
| `Never` | Used as a phantom type; always throws on init |
| `GeneratedContent` | Passthrough — returns itself |

---

### GenerationGuide

```swift
public struct GenerationGuide<Value> {}
```

A type-safe constraint applied to a generated property. Specialized per value kind:

#### String guides

```swift
extension GenerationGuide where Value == String {
    static func constant(_ value: String) -> GenerationGuide<String>
    static func anyOf(_ values: [String]) -> GenerationGuide<String>
    static func pattern<Output>(_ regex: Regex<Output>) -> GenerationGuide<String>
}
```

| Guide | Effect |
|-------|--------|
| `.constant("fixed")` | Model must produce exactly this string |
| `.anyOf(["a", "b", "c"])` | Model must choose one of these values |
| `.pattern(/regex/)` | Model output must match the regex |

#### Integer guides

```swift
extension GenerationGuide where Value == Int {
    static func minimum(_ value: Int) -> GenerationGuide<Int>
    static func maximum(_ value: Int) -> GenerationGuide<Int>
    static func range(_ range: ClosedRange<Int>) -> GenerationGuide<Int>
}
```

#### Float / Double / Decimal guides

Same three methods (`.minimum`, `.maximum`, `.range`) specialized for each numeric type.

#### Array guides

```swift
extension GenerationGuide {
    static func minimumCount<Element>(_ count: Int) -> GenerationGuide<[Element]>
        where Value == [Element]
    static func maximumCount<Element>(_ count: Int) -> GenerationGuide<[Element]>
        where Value == [Element]
    static func count<Element>(_ range: ClosedRange<Int>) -> GenerationGuide<[Element]>
        where Value == [Element]
    static func count<Element>(_ count: Int) -> GenerationGuide<[Element]>
        where Value == [Element]
    static func element<Element>(_ guide: GenerationGuide<Element>) -> GenerationGuide<[Element]>
        where Value == [Element]
}
```

`.element(_:)` applies a guide to every element of the array:

```swift
@Generable
struct SynthesisResult {
    // Exactly 3 keywords, each at most 20 characters
    @Guide(.count(3), .element(.maximum(20)))
    var keywords: [String]  // wait — String guides are .anyOf/.pattern/.constant
    // For strings in arrays, use element with a string guide:
    // @Guide(.count(1...5))
    var themes: [String]
}
```

---

### GenerationSchema

```swift
public struct GenerationSchema: Sendable, Codable, CustomDebugStringConvertible {
    var debugDescription: String { get }
}
```

A serializable description of the output shape expected from the model. Normally you obtain `GenerationSchema` from a `@Generable` type via `MyType.generationSchema`. For dynamic use cases, construct it directly.

#### Nested Property type

```swift
public struct GenerationSchema.Property: Sendable {
    // Required Generable type
    init<Value: Generable>(name: String, description: String? = nil,
                           type: Value.Type,
                           guides: [GenerationGuide<Value>] = [])

    // Optional Generable type
    init<Value: Generable>(name: String, description: String? = nil,
                           type: Value?.Type,
                           guides: [GenerationGuide<Value>] = [])

    // String with regex guides
    init<RegexOutput>(name: String, description: String? = nil,
                      type: String.Type,
                      guides: [Regex<RegexOutput>] = [])

    // Optional String with regex guides
    init<RegexOutput>(name: String, description: String? = nil,
                      type: String?.Type,
                      guides: [Regex<RegexOutput>] = [])
}
```

#### Schema initializers

```swift
// Struct with named properties
init(type: any Generable.Type,
     description: String? = nil,
     properties: [GenerationSchema.Property])

// Enum constrained to a fixed set of strings
init(type: any Generable.Type,
     description: String? = nil,
     anyOf choices: [String])

// Union of Generable types
init(type: any Generable.Type,
     description: String? = nil,
     anyOf types: [any Generable.Type])

// Built from DynamicGenerationSchema (supports recursive/forward-reference schemas)
init(root: DynamicGenerationSchema, dependencies: [DynamicGenerationSchema]) throws
```

#### SchemaError

```swift
public enum GenerationSchema.SchemaError: Error, LocalizedError {
    case duplicateType(schema: String?, type: String,
                       context: GenerationSchema.SchemaError.Context)
    case duplicateProperty(schema: String, property: String,
                           context: GenerationSchema.SchemaError.Context)
    case emptyTypeChoices(schema: String,
                          context: GenerationSchema.SchemaError.Context)
    case undefinedReferences(schema: String?, references: [String],
                             context: GenerationSchema.SchemaError.Context)
}

public struct GenerationSchema.SchemaError.Context: Sendable {
    public let debugDescription: String
    public init(debugDescription: String)
}
```

---

### DynamicGenerationSchema

```swift
public struct DynamicGenerationSchema: Sendable {}
```

Allows building schemas at runtime, including recursive structures and forward references. Use when the schema shape is not known at compile time.

#### Initializers

```swift
// Object with named properties
init(name: String,
     description: String? = nil,
     properties: [DynamicGenerationSchema.Property])

// Enum: one of several named sub-schemas
init(name: String,
     description: String? = nil,
     anyOf choices: [DynamicGenerationSchema])

// Enum: one of fixed string values
init(name: String,
     description: String? = nil,
     anyOf choices: [String])

// Array of a sub-schema
init(arrayOf itemSchema: DynamicGenerationSchema,
     minimumElements: Int? = nil,
     maximumElements: Int? = nil)

// Wrap a static Generable type with optional guides
init<Value: Generable>(type: Value.Type, guides: [GenerationGuide<Value>] = [])

// Forward reference to a schema defined elsewhere in the dependency list
init(referenceTo name: String)
```

#### DynamicGenerationSchema.Property

```swift
public struct DynamicGenerationSchema.Property {
    init(name: String,
         description: String? = nil,
         schema: DynamicGenerationSchema,
         isOptional: Bool = false)
}
```

**Recursive schema example:**

```swift
// A tree node that can contain child nodes
let nodeSchema = DynamicGenerationSchema(
    name: "TreeNode",
    properties: [
        .init(name: "label", schema: DynamicGenerationSchema(type: String.self)),
        .init(name: "children",
              schema: DynamicGenerationSchema(
                  arrayOf: DynamicGenerationSchema(referenceTo: "TreeNode")
              ),
              isOptional: true)
    ]
)

let schema = try GenerationSchema(root: nodeSchema, dependencies: [nodeSchema])
```

---

## Prompt & Instructions Builders

---

### Prompt

```swift
public struct Prompt: Sendable {
    init(_ content: some PromptRepresentable)
    init(@PromptBuilder _ content: () throws -> Prompt) rethrows
}

public protocol PromptRepresentable {
    @PromptBuilder var promptRepresentation: Prompt { get }
}
```

`Prompt` is the type passed to `respond` and `streamResponse` calls. Any `PromptRepresentable` can be used anywhere a `Prompt` is expected.

**Types that conform to `PromptRepresentable`:**
- `String`
- `Prompt` itself
- `Array<Element: PromptRepresentable>`
- Any `ConvertibleToGeneratedContent` (which includes all `@Generable` types)

```swift
// All equivalent:
let response1 = try await session.respond(to: "Describe the Moon in three words")
let response2 = try await session.respond(to: Prompt("Describe the Moon in three words"))
let response3 = try await session.respond {
    "Describe the Moon in three words"
}

// Compose a prompt with structured data
let chart = BlueprintResponse(...)  // @Generable type
let response4 = try await session.respond {
    "Interpret this natal chart:"
    chart  // embedded as its GeneratedContent representation
}
```

---

### Instructions

```swift
public struct Instructions: Sendable {
    init(_ content: some InstructionsRepresentable)
    init(@InstructionsBuilder _ content: () throws -> Instructions) rethrows
}

public protocol InstructionsRepresentable {
    @InstructionsBuilder var instructionsRepresentation: Instructions { get }
}
```

`Instructions` sets the system-level context for the session. Appears as the first entry in the transcript.

**Types that conform to `InstructionsRepresentable`:**
- `String`
- `Instructions` itself
- `Array<Element: InstructionsRepresentable>`
- Any `ConvertibleToGeneratedContent`

```swift
let session = LanguageModelSession {
    "You are a symbolic interpreter specializing in Jungian archetypes."
    "Respond in a reflective, non-prescriptive tone."
    "Use present tense."
}
```

---

### PromptBuilder

```swift
@resultBuilder
public struct PromptBuilder {
    static func buildBlock<each P: PromptRepresentable>(_ components: repeat each P) -> Prompt
    static func buildArray(_ prompts: [some PromptRepresentable]) -> Prompt
    static func buildEither(first component: some PromptRepresentable) -> Prompt
    static func buildEither(second component: some PromptRepresentable) -> Prompt
    static func buildOptional(_ component: Prompt?) -> Prompt
    static func buildLimitedAvailability(_ prompt: some PromptRepresentable) -> Prompt
    static func buildExpression<P: PromptRepresentable>(_ expression: P) -> P
    static func buildExpression(_ expression: Prompt) -> Prompt
}
```

Supports `if/else`, `for` loops, and optional unwrapping inside the prompt closure.

---

### InstructionsBuilder

```swift
@resultBuilder
public struct InstructionsBuilder {
    static func buildBlock<each I: InstructionsRepresentable>(_ components: repeat each I) -> Instructions
    static func buildArray(_ instructions: [some InstructionsRepresentable]) -> Instructions
    static func buildEither(first component: some InstructionsRepresentable) -> Instructions
    static func buildEither(second component: some InstructionsRepresentable) -> Instructions
    static func buildOptional(_ instructions: Instructions?) -> Instructions
    static func buildLimitedAvailability(_ instructions: some InstructionsRepresentable) -> Instructions
    static func buildExpression<I: InstructionsRepresentable>(_ expression: I) -> I
    static func buildExpression(_ expression: Instructions) -> Instructions
}
```

---

## Streaming

---

### ResponseStream

```swift
public struct LanguageModelSession.ResponseStream<Content: Generable>
```

An `AsyncSequence` of `Snapshot` values. Obtain one via any `streamResponse` method. Consuming the stream drives generation — each awaited `Snapshot` contains the content generated so far.

```swift
extension LanguageModelSession.ResponseStream: AsyncSequence {
    public typealias Element = Snapshot
    func makeAsyncIterator() -> AsyncIterator
}
```

---

### Snapshot

```swift
public struct LanguageModelSession.ResponseStream<Content: Generable>.Snapshot {
    public var content: Content.PartiallyGenerated
    public var rawContent: GeneratedContent
}
```

| Property | Description |
|----------|-------------|
| `content` | Partially generated content of the associated type. For `String`, each snapshot extends the previous string. For `@Generable` structs, fields fill in as generation proceeds. |
| `rawContent` | The raw `GeneratedContent` for the snapshot. `isComplete` is `false` until the final snapshot. |

---

### collect()

```swift
nonisolated(nonsending) func collect() async throws -> Response<Content>
```

Awaits the entire stream and returns the final `Response<Content>`, equivalent to using `respond` instead of `streamResponse`. Useful when you create a stream (e.g., to get a non-`async` return site) but later decide you want the full result.

```swift
let stream = session.streamResponse(to: "Summarize this session")
let finalResponse = try await stream.collect()
print(finalResponse.content)
```

---

## Tool Use

---

### Tool Protocol

```swift
public protocol Tool<Arguments, Output>: Sendable {
    associatedtype Output: PromptRepresentable
    associatedtype Arguments: ConvertibleFromGeneratedContent

    var name: String { get }            // Defaults to type name
    var description: String { get }     // Shown to the model
    var parameters: GenerationSchema { get }  // Derived from Arguments if Generable
    var includesSchemaInInstructions: Bool { get }  // Defaults to true

    func call(arguments: Arguments) async throws -> Output
}
```

**Default implementations:**
- `name` — the Swift type name of the conforming type
- `parameters` — `Arguments.generationSchema` (when `Arguments: Generable`)
- `includesSchemaInInstructions` — `true`

**Constraints:**
- `Arguments` must be a `@Generable` struct. Primitive types (`String`, `Int`, `Double`, `Float`, `Bool`, `Decimal`) are explicitly **unsupported** as `Arguments` and will produce a compile-time error. Wrap them in a `@Generable` struct.
- `Output` must conform to `PromptRepresentable`. `String` works. `@Generable` types work (via `ConvertibleToGeneratedContent`).

**Example:**

```swift
struct EphemerisLookupTool: Tool {
    let description = "Look up an Obsidian note from the Ephemeris by title"

    @Generable
    struct Arguments {
        @Guide(description: "The exact title of the Ephemeris note to retrieve")
        var noteTitle: String
    }

    func call(arguments: Arguments) async throws -> String {
        // Query GRDB for the note content
        let note = try await EphemerisService.shared.note(titled: arguments.noteTitle)
        return note?.content ?? "Note not found: \(arguments.noteTitle)"
    }
}

// Register at session creation
let session = LanguageModelSession(tools: [EphemerisLookupTool()])
```

When the model decides to call a tool, FoundationModels:
1. Generates a structured `ToolCall` entry in the transcript
2. Invokes `call(arguments:)` on the tool
3. Appends the result as a `ToolOutput` entry in the transcript
4. Resumes generation using the tool result

If `call(arguments:)` throws, the session throws `ToolCallError` to the caller.

---

### Primitive Arguments Restriction

The following produce a compile-time `unavailable` error as `Arguments`:

```
String, Int, Double, Float, Float, Bool, Decimal
```

Error message: `'Tool' that uses 'String' as 'Arguments' type is unsupported. Use '@Generable' struct instead.`

Always wrap tool parameters in a dedicated `@Generable` struct, even for a single parameter.

---

## Transcript

```swift
public struct Transcript: Sendable, Equatable, RandomAccessCollection, Codable {
    typealias Index = Int
    var startIndex: Int { get }
    var endIndex: Int { get }
    subscript(index: Int) -> Entry { get set }
    init(entries: some Sequence<Entry> = [])
}
```

A `RandomAccessCollection` of `Transcript.Entry` values representing the full conversation history. `Codable` — persist and restore sessions by encoding/decoding the transcript.

---

### Transcript.Entry

```swift
public enum Transcript.Entry: Sendable, Identifiable, Equatable, CustomStringConvertible {
    case instructions(Transcript.Instructions)
    case prompt(Transcript.Prompt)
    case toolCalls(Transcript.ToolCalls)
    case toolOutput(Transcript.ToolOutput)
    case response(Transcript.Response)

    public var id: String { get }
    public var description: String { get }
}
```

Each turn in a session adds one or more `Entry` values to the transcript. A typical exchange adds `.prompt` then `.response`. A tool-use turn adds `.prompt`, `.toolCalls`, `.toolOutput`, then `.response`.

---

### Transcript.Segment

```swift
public enum Transcript.Segment: Sendable, Identifiable, Equatable, CustomStringConvertible {
    case text(Transcript.TextSegment)
    case structure(Transcript.StructuredSegment)

    public var id: String { get }
    public var description: String { get }
}
```

Segments are the atomic content units within entries. A single entry may contain multiple segments interleaving text and structured data.

---

### Transcript.TextSegment

```swift
public struct Transcript.TextSegment: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var content: String
    public init(id: String = UUID().uuidString, content: String)
    public var description: String { get }
}
```

---

### Transcript.StructuredSegment

```swift
public struct Transcript.StructuredSegment: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var source: String             // The type name that produced this content
    public var content: GeneratedContent  // get + set
    public init(id: String = UUID().uuidString, source: String, content: GeneratedContent)
    public var description: String { get }
}
```

---

### Transcript.Instructions

```swift
public struct Transcript.Instructions: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var segments: [Transcript.Segment]
    public var toolDefinitions: [Transcript.ToolDefinition]
    public init(id: String = UUID().uuidString,
                segments: [Transcript.Segment],
                toolDefinitions: [Transcript.ToolDefinition])
    public var description: String { get }
}
```

The first entry in a session's transcript if instructions were provided at init.

---

### Transcript.ToolDefinition

```swift
public struct Transcript.ToolDefinition: Sendable, Equatable {
    public var name: String
    public var description: String
    public init(name: String, description: String, parameters: GenerationSchema)
    public init(tool: some Tool)
}
```

Describes a tool that was registered with the session. Stored inside `Transcript.Instructions`.

---

### Transcript.Prompt

```swift
public struct Transcript.Prompt: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var segments: [Transcript.Segment]
    public var options: GenerationOptions
    public var responseFormat: Transcript.ResponseFormat?
    public init(id: String = UUID().uuidString,
                segments: [Transcript.Segment],
                options: GenerationOptions = GenerationOptions(),
                responseFormat: Transcript.ResponseFormat? = nil)
    public var description: String { get }
}
```

---

### Transcript.ResponseFormat

```swift
public struct Transcript.ResponseFormat: Sendable, Equatable, CustomStringConvertible {
    public var name: String { get }
    public init<Content: Generable>(type: Content.Type)
    public init(schema: GenerationSchema)
    public var description: String { get }
}
```

Specifies the expected output format for a prompt. Set automatically by `respond(generating:)` and `respond(schema:)`.

---

### Transcript.ToolCalls & ToolCall

```swift
public struct Transcript.ToolCalls: Sendable, Identifiable, Equatable,
                                     RandomAccessCollection, CustomStringConvertible {
    public var id: String
    public init<S: Sequence>(id: String = UUID().uuidString, _ calls: S)
        where S.Element == Transcript.ToolCall
    public subscript(position: Int) -> Transcript.ToolCall { get }
    public var startIndex: Int { get }
    public var endIndex: Int { get }
}

public struct Transcript.ToolCall: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var toolName: String
    public var arguments: GeneratedContent  // get + set
    public init(id: String, toolName: String, arguments: GeneratedContent)
}
```

---

### Transcript.ToolOutput

```swift
public struct Transcript.ToolOutput: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var toolName: String
    public var segments: [Transcript.Segment]
    public init(id: String, toolName: String, segments: [Transcript.Segment])
}
```

---

### Transcript.Response

```swift
public struct Transcript.Response: Sendable, Identifiable, Equatable, CustomStringConvertible {
    public var id: String
    public var assetIDs: [String]          // Internal asset tracking
    public var segments: [Transcript.Segment]
    public init(id: String = UUID().uuidString,
                assetIDs: [String],
                segments: [Transcript.Segment])
}
```

---

## GeneratedContent & GenerationID

---

### GeneratedContent

```swift
public struct GeneratedContent: Sendable, Equatable, Generable, CustomDebugStringConvertible {
    public var id: GenerationID?
    public var isComplete: Bool { get }
    public var jsonString: String { get }
    public var debugDescription: String { get }

    // Construct from another ConvertibleToGeneratedContent
    public init(_ value: some ConvertibleToGeneratedContent)
    public init(_ value: some ConvertibleToGeneratedContent, id: GenerationID)

    // Construct from kind
    public init(kind: GeneratedContent.Kind, id: GenerationID? = nil)

    // Construct a structure from ordered key-value pairs
    public init(properties: KeyValuePairs<String, any ConvertibleToGeneratedContent>,
                id: GenerationID? = nil)

    // Construct a structure from a sequence, deduplicating keys
    public init<S: Sequence>(properties: S,
                             id: GenerationID? = nil,
                             uniquingKeysWith combine: (GeneratedContent, GeneratedContent)
                                 throws -> some ConvertibleToGeneratedContent) rethrows
        where S.Element == (String, any ConvertibleToGeneratedContent)

    // Construct an array
    public init<S: Sequence>(elements: S, id: GenerationID? = nil)
        where S.Element == any ConvertibleToGeneratedContent

    // Parse from a JSON string
    public init(json: String) throws

    // Self-referential init (Generable conformance)
    public init(_ content: GeneratedContent) throws
}
```

#### Value extraction

```swift
// Extract a typed value from the top-level content
func value<Value: ConvertibleFromGeneratedContent>(
    _ type: Value.Type = Value.self
) throws -> Value

// Extract a typed value from a named property
func value<Value: ConvertibleFromGeneratedContent>(
    _ type: Value.Type = Value.self,
    forProperty property: String
) throws -> Value

// Extract an optional value from a named property
func value<Value: ConvertibleFromGeneratedContent>(
    _ type: Value?.Type = Value?.self,
    forProperty property: String
) throws -> Value?
```

```swift
// Manual extraction example
let content: GeneratedContent = ...
let planet = try content.value(String.self, forProperty: "dominantPlanet")
let intensity = try content.value(Int.self, forProperty: "intensity")
```

---

### GeneratedContent.Kind

```swift
public enum GeneratedContent.Kind: Equatable, Sendable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([GeneratedContent])
    case structure(properties: [String: GeneratedContent], orderedKeys: [String])
}
```

Access the kind of any `GeneratedContent` value:

```swift
switch content.kind {
case .string(let s):   print("String: \(s)")
case .number(let n):   print("Number: \(n)")
case .bool(let b):     print("Bool: \(b)")
case .array(let a):    print("Array with \(a.count) elements")
case .structure(_, let keys): print("Structure with keys: \(keys)")
case .null:            print("Null")
}
```

`orderedKeys` preserves the generation order of properties in a structure, which may differ from the dictionary iteration order of `properties`.

---

### GenerationID

```swift
public struct GenerationID: Sendable, Hashable {
    public init()
    public func hash(into hasher: inout Hasher)
    public var hashValue: Int { get }
}
```

An opaque identifier for a generated content value. Used to correlate streaming snapshots with their final values.

---

## GenerationOptions & SamplingMode

```swift
public struct GenerationOptions: Sendable, Equatable {
    public var sampling: SamplingMode?
    public var temperature: Double?
    public var maximumResponseTokens: Int?

    public init(sampling: SamplingMode? = nil,
                temperature: Double? = nil,
                maximumResponseTokens: Int? = nil)
}
```

| Property | Default | Description |
|----------|---------|-------------|
| `sampling` | `nil` (system default) | Sampling strategy |
| `temperature` | `nil` (system default) | Generation temperature; higher = more varied |
| `maximumResponseTokens` | `nil` (unlimited) | Hard cap on response length in tokens |

```swift
public struct GenerationOptions.SamplingMode: Sendable, Equatable {
    // Deterministic: always picks the highest-probability token
    static var greedy: SamplingMode { get }

    // Top-k sampling: sample from the k highest-probability tokens
    static func random(top k: Int, seed: UInt64? = nil) -> SamplingMode

    // Nucleus (top-p) sampling: sample from tokens whose cumulative probability
    // meets the threshold
    static func random(probabilityThreshold: Double, seed: UInt64? = nil) -> SamplingMode
}
```

**Usage examples:**

```swift
// Deterministic output (useful for structured generation or testing)
let deterministicOptions = GenerationOptions(sampling: .greedy)

// Creative text with top-k sampling, reproducible via seed
let creativeOptions = GenerationOptions(
    sampling: .random(top: 50, seed: 42),
    temperature: 0.8
)

// Constrained length
let shortOptions = GenerationOptions(maximumResponseTokens: 100)

let response = try await session.respond(
    to: "Write a haiku about Mercury retrograde",
    options: creativeOptions
)
```

**Notes:**
- `nil` values for all properties use the system's recommended defaults.
- `temperature` is applied on top of the sampling mode — not all combinations may be meaningful.
- If `maximumResponseTokens` is hit, the response is truncated and `GeneratedContent.isComplete` will be `false` on the resulting raw content.

---

## Errors

---

### GenerationError

```swift
public enum LanguageModelSession.GenerationError: Error, LocalizedError {
    case exceededContextWindowSize(Context)
    case assetsUnavailable(Context)
    case guardrailViolation(Context)
    case unsupportedGuide(Context)
    case unsupportedLanguageOrLocale(Context)
    case decodingFailure(Context)
    case rateLimited(Context)
    case concurrentRequests(Context)
    case refusal(Refusal, Context)

    public var errorDescription: String? { get }
    public var recoverySuggestion: String? { get }
    public var failureReason: String? { get }
}
```

| Case | Meaning |
|------|---------|
| `.exceededContextWindowSize` | The accumulated transcript + prompt exceeds the model's context limit. Start a new session or truncate the transcript. |
| `.assetsUnavailable` | Model weights are not available on this device at this time (e.g., still downloading). |
| `.guardrailViolation` | The prompt or generated content triggered a content safety filter. |
| `.unsupportedGuide` | A `GenerationGuide` or `GenerationSchema` constraint is not supported by this model version. |
| `.unsupportedLanguageOrLocale` | The prompt is in a language the model does not support. Check `supportsLocale(_:)` first. |
| `.decodingFailure` | The model generated output that could not be decoded into the requested `Generable` type. |
| `.rateLimited` | Too many requests in a short period. Back off and retry. |
| `.concurrentRequests` | A response is already in flight on this session. Wait for it to complete. |
| `.refusal` | The model declined to answer. See `Refusal` for details and explanation. |

#### GenerationError.Context

```swift
public struct LanguageModelSession.GenerationError.Context: Sendable {
    public let debugDescription: String
    public init(debugDescription: String)
}
```

Pattern-match to access the context:

```swift
catch LanguageModelSession.GenerationError.exceededContextWindowSize(let ctx) {
    print("Context overflow:", ctx.debugDescription)
}
```

---

### GenerationError.Refusal

```swift
public struct LanguageModelSession.GenerationError.Refusal: Sendable {
    public init(transcriptEntries: [Transcript.Entry])

    // Async: get the model's explanation of the refusal
    public var explanation: LanguageModelSession.Response<String> { get async throws }

    // Stream the explanation
    public var explanationStream: LanguageModelSession.ResponseStream<String> { get }
}
```

When the model refuses, you can ask it to explain why:

```swift
catch LanguageModelSession.GenerationError.refusal(let refusal, _) {
    let explanation = try await refusal.explanation
    print("Refused because:", explanation.content)
}
```

---

### ToolCallError

```swift
public struct LanguageModelSession.ToolCallError: Error, LocalizedError {
    public var tool: any Tool
    public var underlyingError: any Error
    public init(tool: any Tool, underlyingError: any Error)
    public var errorDescription: String? { get }
}
```

Thrown when a tool's `call(arguments:)` method throws. Wraps the original error alongside the tool that failed. The session appends an error marker to the transcript and stops generation.

---

### GenerationSchema.SchemaError

```swift
public enum GenerationSchema.SchemaError: Error, LocalizedError {
    case duplicateType(schema: String?, type: String,
                       context: GenerationSchema.SchemaError.Context)
    case duplicateProperty(schema: String, property: String,
                           context: GenerationSchema.SchemaError.Context)
    case emptyTypeChoices(schema: String,
                          context: GenerationSchema.SchemaError.Context)
    case undefinedReferences(schema: String?, references: [String],
                             context: GenerationSchema.SchemaError.Context)

    public var errorDescription: String? { get }
    public var recoverySuggestion: String? { get }
}

public struct GenerationSchema.SchemaError.Context: Sendable {
    public let debugDescription: String
    public init(debugDescription: String)
}
```

Thrown by `GenerationSchema.init(root:dependencies:)` when the schema graph has structural problems.

---

### Adapter.AssetError

```swift
public enum SystemLanguageModel.Adapter.AssetError: Error, LocalizedError {
    case invalidAsset(Context)
    case invalidAdapterName(Context)
    case compatibleAdapterNotFound(Context)

    public var errorDescription: String? { get }
    public var recoverySuggestion: Swift.String? { get }
}

public struct SystemLanguageModel.Adapter.AssetError.Context: Sendable {
    public let debugDescription: String
    public init(debugDescription: String)
}
```

---

## Adapters

---

### SystemLanguageModel.Adapter

```swift
public struct SystemLanguageModel.Adapter {
    public var creatorDefinedMetadata: [String: Any] { get }
}
```

A fine-tuned model adapter that extends the base Apple Intelligence model for a specific task or domain. Adapters are distributed as App Store assets using the BackgroundAssets framework.

#### Initializers

```swift
// Load from a local file URL (e.g., bundled in the app)
init(fileURL: URL) throws

// Load by name from the BackgroundAssets store
init(name: String) throws
```

#### Instance methods

```swift
// Compile the adapter if needed (async, may take time)
func compile() async throws
```

#### Static methods

```swift
// Returns the list of adapter identifiers compatible with the named adapter on this device
static func compatibleAdapterIdentifiers(name: String) -> [String]

// Remove adapter files that are no longer compatible with the installed OS
static func removeObsoleteAdapters() throws

// Check whether a BackgroundAssets AssetPack contains a compatible adapter
static func isCompatible(_ assetPack: BackgroundAssets.AssetPack) -> Bool
```

**Usage:**

```swift
import FoundationModels
import BackgroundAssets

// Load an adapter by name (must match the asset name in BackgroundAssets)
let adapter = try SystemLanguageModel.Adapter(name: "MyDomainAdapter")

// Compile it (only required once; compilation result is cached)
try await adapter.compile()

// Create a model using the adapter
let model = SystemLanguageModel(adapter: adapter)
let session = LanguageModelSession(model: model)
```

---

## Feedback

---

### LanguageModelFeedback

```swift
public struct LanguageModelFeedback {}
```

A namespace for types used to report feedback on model responses. Feedback is attached to a `Foundation.Data` blob logged to the system via `logFeedbackAttachment` on `LanguageModelSession`. Apple uses this data to improve the model.

---

### Sentiment

```swift
public enum LanguageModelFeedback.Sentiment: Sendable, CaseIterable, Equatable, Hashable {
    case positive
    case negative
    case neutral
}
```

---

### Issue & Category

```swift
public struct LanguageModelFeedback.Issue: Sendable {
    public init(category: Category, explanation: String? = nil)

    public enum Category: Sendable, CaseIterable, Equatable, Hashable {
        case unhelpful
        case tooVerbose
        case didNotFollowInstructions
        case incorrect
        case stereotypeOrBias
        case suggestiveOrSexual
        case vulgarOrOffensive
        case triggeredGuardrailUnexpectedly
    }
}
```

---

### logFeedbackAttachment

Three overloads on `LanguageModelSession`:

```swift
// General-purpose — pass any Transcript.Entry as desired output
@discardableResult
func logFeedbackAttachment(
    sentiment: LanguageModelFeedback.Sentiment?,
    issues: [LanguageModelFeedback.Issue] = [],
    desiredOutput: Transcript.Entry? = nil
) -> Data

// Convenience — pass desired response as a plain String
// @backDeployed(before: iOS 26.1, macOS 26.1, visionOS 26.1)
@discardableResult
func logFeedbackAttachment(
    sentiment: LanguageModelFeedback.Sentiment?,
    issues: [LanguageModelFeedback.Issue] = [],
    desiredResponseText: String?
) -> Data

// Convenience — pass desired response as any ConvertibleToGeneratedContent
// @backDeployed(before: iOS 26.1, macOS 26.1, visionOS 26.1)
@discardableResult
func logFeedbackAttachment(
    sentiment: LanguageModelFeedback.Sentiment?,
    issues: [LanguageModelFeedback.Issue] = [],
    desiredResponseContent: (any ConvertibleToGeneratedContent)?
) -> Data
```

```swift
// Example: thumbs-down with explanation
session.logFeedbackAttachment(
    sentiment: .negative,
    issues: [
        LanguageModelFeedback.Issue(
            category: .didNotFollowInstructions,
            explanation: "Model used past tense despite instructions specifying present tense"
        )
    ],
    desiredResponseText: "The Moon in Scorpio brings heightened emotional sensitivity."
)
```

The returned `Data` is an opaque system blob. Discard the return value or log it as needed. The data is transmitted to Apple through the system's feedback pipeline, not directly from your app.

---

## Practical Code Examples

---

### Basic Text Generation

```swift
import FoundationModels

func generateInterpretation(for planet: String, in sign: String) async throws -> String {
    guard SystemLanguageModel.default.isAvailable else {
        throw InterpretationError.modelUnavailable
    }

    let session = LanguageModelSession {
        "You are a classical astrologer writing in the style of William Lilly."
        "Interpretations should be vivid, precise, and 2–3 sentences."
    }

    let response = try await session.respond {
        "Interpret \(planet) in \(sign) for a natal chart."
    }

    return response.content
}
```

---

### Streaming Responses

```swift
import FoundationModels
import SwiftUI

@Observable
class ReadingViewModel {
    var streamedText = ""
    var isStreaming = false

    private let session = LanguageModelSession {
        "You are a Tarot reader synthesizing card meanings with personal context."
    }

    func streamReading(for cards: [String]) async throws {
        isStreaming = true
        streamedText = ""
        defer { isStreaming = false }

        let cardList = cards.joined(separator: ", ")
        let stream = session.streamResponse {
            "The cards drawn are: \(cardList)."
            "Weave them into a single coherent reading."
        }

        for try await snapshot in stream {
            streamedText = snapshot.content
        }
    }
}
```

In SwiftUI:

```swift
struct ReadingView: View {
    @State private var viewModel = ReadingViewModel()

    var body: some View {
        ScrollView {
            Text(viewModel.streamedText)
                .padding()
        }
        .overlay(alignment: .bottom) {
            if viewModel.isStreaming {
                ProgressView()
            }
        }
        .task {
            try? await viewModel.streamReading(for: ["The Tower", "The Star", "Judgement"])
        }
    }
}
```

---

### Guided Generation Example

```swift
import FoundationModels

@Generable(description: "A synthesized Human Design interpretation")
struct HumanDesignReading {
    @Guide(description: "The person's Human Design type",
           .anyOf(["Manifestor", "Generator", "Manifesting Generator",
                   "Projector", "Reflector"]))
    var type: String

    @Guide(description: "Their defined centers as keywords (e.g. 'Head, Ajna, Throat')")
    var definedCenters: String

    @Guide(description: "A theme for the current transit cycle")
    var transitTheme: String

    @Guide(description: "Practical guidance for navigating this period",
           .count(2...4))
    var guidancePhrases: [String]

    @Guide(description: "Overall alignment score from 1 to 10", .range(1...10))
    var alignmentScore: Int
}

func generateHDReading(birthData: BirthData) async throws -> HumanDesignReading {
    let session = LanguageModelSession {
        "You are a Human Design analyst. Use technical accuracy alongside accessible language."
    }

    let response = try await session.respond(
        to: "Generate a Human Design reading for someone born \(birthData.description).",
        generating: HumanDesignReading.self
    )

    return response.content
}
```

Streaming a `@Generable` type — fields populate incrementally:

```swift
let stream = session.streamResponse(
    to: "Generate a Human Design reading for \(birthData.description).",
    generating: HumanDesignReading.self
)

for try await snapshot in stream {
    // snapshot.content is HumanDesignReading.PartiallyGenerated
    // Fields that haven't generated yet are nil/empty depending on type
    print("Type so far:", snapshot.content.type)
    print("Score so far:", snapshot.content.alignmentScore)
}
```

---

### Tool Use Example

```swift
import FoundationModels
import GRDB

// Define the tool
struct EphemerisSearchTool: Tool {
    let description = """
        Search the Ephemeris (Obsidian vault index) for notes relevant to a symbol or theme.
        Returns matching note titles and their first paragraph.
        """

    @Generable
    struct Arguments {
        @Guide(description: "Search query — a planet, sign, archetype, or theme name")
        var query: String

        @Guide(description: "Maximum number of results to return", .range(1...5))
        var limit: Int
    }

    private let dbQueue: DatabaseQueue

    init(dbQueue: DatabaseQueue) {
        self.dbQueue = dbQueue
    }

    func call(arguments: Arguments) async throws -> String {
        let results = try await dbQueue.read { db in
            try EphemerisNote
                .filter(EphemerisNote.Columns.ftsContent.match(arguments.query))
                .limit(arguments.limit)
                .fetchAll(db)
        }

        if results.isEmpty {
            return "No Ephemeris notes found for '\(arguments.query)'."
        }

        return results.map { note in
            "**\(note.title)**\n\(note.excerpt)"
        }.joined(separator: "\n\n")
    }
}

// Use it in a session
func synthesizeReading(chart: BlueprintResponse, dbQueue: DatabaseQueue) async throws -> String {
    let session = LanguageModelSession(
        tools: [EphemerisSearchTool(dbQueue: dbQueue)]
    ) {
        "You are a synthesis engine combining astrological data with esoteric research notes."
        "Use the EphemerisSearchTool to retrieve relevant Ephemeris entries before synthesizing."
    }

    let response = try await session.respond {
        "Synthesize a reading for this chart:"
        chart  // BlueprintResponse conforms to Generable → embeds as structured content
    }

    return response.content
}
```

---

### Availability Checking

```swift
import FoundationModels
import SwiftUI

@Observable
class IntelligenceAvailabilityMonitor {
    private let model = SystemLanguageModel.default

    var isAvailable: Bool { model.isAvailable }
    var availability: SystemLanguageModel.Availability { model.availability }

    var unavailableMessage: String? {
        guard case .unavailable(let reason) = model.availability else { return nil }
        switch reason {
        case .deviceNotEligible:
            return "Apple Intelligence requires a newer device."
        case .appleIntelligenceNotEnabled:
            return "Enable Apple Intelligence in Settings → Apple Intelligence & Siri."
        case .modelNotReady:
            return "Apple Intelligence is still downloading. Check back soon."
        }
    }

    var supportsCurrentLocale: Bool {
        model.supportsLocale()
    }
}

struct IntelligenceGatedView<Content: View>: View {
    @State private var monitor = IntelligenceAvailabilityMonitor()
    @ViewBuilder var content: () -> Content

    var body: some View {
        if monitor.isAvailable {
            if monitor.supportsCurrentLocale {
                content()
            } else {
                ContentUnavailableView(
                    "Language Not Supported",
                    systemImage: "globe.slash",
                    description: Text("Apple Intelligence does not support your current language.")
                )
            }
        } else {
            ContentUnavailableView(
                "Apple Intelligence Unavailable",
                systemImage: "brain.slash",
                description: Text(monitor.unavailableMessage ?? "Apple Intelligence is not available.")
            )
        }
    }
}
```

---

### Session Prewarming

```swift
import FoundationModels

@Observable
class ConsultationViewModel {
    // Create the session early so prewarm() can be called before it's needed
    private let session = LanguageModelSession {
        "You are an esoteric synthesis engine combining five symbolic instruments."
    }

    func onSessionSelected() {
        // Called when the user taps into the consultation screen,
        // before they have entered any data
        session.prewarm()
    }

    func onSessionSelectedWithKnownContext(clientName: String) {
        // Prewarm with a prefix if the beginning of the prompt is known
        session.prewarm(promptPrefix: Prompt("Client: \(clientName)\n"))
    }

    func generateReading(for client: Client) async throws -> String {
        // By now the session is likely warm; first token arrives faster
        let response = try await session.respond {
            "Client name: \(client.name)"
            "Sun sign: \(client.sunSign)"
            "Generate an opening synthesis for this consultation."
        }
        return response.content
    }
}
```

---

### Error Handling

```swift
import FoundationModels

func robustGenerate(session: LanguageModelSession, prompt: String) async -> String {
    do {
        let response = try await session.respond(to: prompt)
        return response.content

    } catch LanguageModelSession.GenerationError.exceededContextWindowSize(let ctx) {
        // The conversation is too long. Start fresh or summarize.
        print("Context overflow:", ctx.debugDescription)
        return "Session context is full. Please start a new consultation."

    } catch LanguageModelSession.GenerationError.refusal(let refusal, let ctx) {
        // Model declined. Optionally fetch its explanation.
        print("Refused:", ctx.debugDescription)
        if let explanation = try? await refusal.explanation {
            print("Model says:", explanation.content)
        }
        return "This topic could not be addressed in this context."

    } catch LanguageModelSession.GenerationError.guardrailViolation(let ctx) {
        print("Guardrail:", ctx.debugDescription)
        return "That request cannot be completed."

    } catch LanguageModelSession.GenerationError.rateLimited(let ctx) {
        print("Rate limited:", ctx.debugDescription)
        // Back off; the system will clear automatically
        try? await Task.sleep(for: .seconds(2))
        return await robustGenerate(session: session, prompt: prompt)

    } catch LanguageModelSession.GenerationError.concurrentRequests {
        // Another response is in flight — wait for isResponding to clear
        return "Please wait for the current response to complete."

    } catch LanguageModelSession.GenerationError.assetsUnavailable {
        return "Apple Intelligence model assets are not available right now."

    } catch LanguageModelSession.GenerationError.decodingFailure(let ctx) {
        // Structured generation failed to decode into the target type
        print("Decoding failed:", ctx.debugDescription)
        return "The model produced output that could not be interpreted. Please try again."

    } catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale {
        return "The current language is not supported by Apple Intelligence."

    } catch LanguageModelSession.GenerationError.unsupportedGuide(let ctx) {
        // A GenerationGuide or schema feature isn't supported on this model version
        print("Unsupported guide:", ctx.debugDescription)
        return "A generation constraint is not supported on this device."

    } catch LanguageModelSession.ToolCallError.init(tool: let tool, underlyingError: let err) {
        print("Tool '\(tool.name)' failed:", err)
        return "A tool call failed: \(err.localizedDescription)"

    } catch {
        print("Unexpected error:", error)
        return "An unexpected error occurred."
    }
}
```

**Structured generation with decoding failure recovery:**

```swift
func generateWithFallback(session: LanguageModelSession, prompt: String) async -> String {
    // Try structured first
    do {
        let response = try await session.respond(
            to: prompt,
            generating: AstroReading.self
        )
        return formatReading(response.content)
    } catch LanguageModelSession.GenerationError.decodingFailure {
        // Fall back to plain text
        let response = try? await session.respond(to: prompt)
        return response?.content ?? "Generation failed."
    } catch {
        return "Error: \(error.localizedDescription)"
    }
}
```
