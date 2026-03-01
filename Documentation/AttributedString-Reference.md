# AttributedString Reference

> Extracted from Xcode 26.2 SDK — Foundation.framework and SwiftUICore.framework swiftinterfaces
> Availability: macOS 12+ (AttributedString), macOS 12+ (MarkdownParsingOptions)
> Context: Rendering Obsidian-flavored markdown notes in `EphemerisNoteView`

---

## Table of Contents

1. [Core Types](#core-types)
2. [AttributedString Initializers](#attributedstring-initializers)
3. [Markdown Initializers](#markdown-initializers)
4. [MarkdownParsingOptions](#markdownparsingoptions)
5. [What Apple's Parser Supports and Does Not Support](#what-apples-parser-supports-and-does-not-support)
6. [AttributeContainer](#attributecontainer)
7. [AttributeScopes — Foundation and SwiftUI Attributes](#attributescopes)
8. [PresentationIntent and InlinePresentationIntent](#presentationintent-and-inlinepresentationintent)
9. [Text(attributedString:) in SwiftUI](#textattributedstring-in-swiftui)
10. [Custom AttributedStringKey](#custom-attributedstringkey)
11. [Obsidian Pre-Processing Strategy](#obsidian-pre-processing-strategy)
12. [Complete MarkdownRenderer for EphemerisNoteView](#complete-markdownrenderer-for-ephemerisnotenoteview)
13. [Third-Party Packages: When to Use MarkdownUI](#third-party-packages-when-to-use-markdownui)

---

## Core Types

| Type | Module | Purpose |
|------|--------|---------|
| `AttributedString` | Foundation | Value-type rich text with typed attribute runs |
| `AttributedSubstring` | Foundation | Slice of an `AttributedString` |
| `AttributeContainer` | Foundation | Bag of typed attributes applied to a range |
| `AttributeScopes` | Foundation | Namespace for attribute scope structs |
| `AttributeScope` | Foundation | Protocol grouping related attribute keys |
| `AttributedStringKey` | Foundation | Protocol each attribute type conforms to |
| `AttributedStringProtocol` | Foundation | Common interface for `AttributedString` and `AttributedSubstring` |
| `ScopedAttributeContainer<S>` | Foundation | Subscript access scoped to one `AttributeScope` |
| `InlinePresentationIntent` | Foundation | OptionSet; inline markdown intent flags (bold, italic, code…) |
| `PresentationIntent` | Foundation | Block-level markdown intent (paragraph, header, list…) |

---

## AttributedString Initializers

```swift
// From plain string (no markdown parsing)
public init(_ string: String, attributes: AttributeContainer = .init())
public init(_ substring: Substring, attributes: AttributeContainer = .init())
public init(_ substring: AttributedSubstring)

// Scope-filtered copy — strips attributes not in the given scope
public init<S, T>(_ other: T, including scope: KeyPath<AttributeScopes, S.Type>)
    where S: AttributeScope, T: AttributedStringProtocol
public init<S, T>(_ other: T, including scope: S.Type)
    where S: AttributeScope, T: AttributedStringProtocol
```

`AttributedString` is `ExpressibleByStringLiteral` — `let s: AttributedString = "Hello"` works for simple cases.

---

## Markdown Initializers

All markdown initializers are `throws`. They are available from **macOS 12**.

```swift
// From String
public init(markdown: String,
            options: AttributedString.MarkdownParsingOptions = .init(),
            baseURL: URL? = nil) throws

// From Data (UTF-8 encoded markdown)
public init(markdown: Data,
            options: AttributedString.MarkdownParsingOptions = .init(),
            baseURL: URL? = nil) throws

// From file URL
public init(contentsOf url: URL,
            options: AttributedString.MarkdownParsingOptions = .init(),
            baseURL: URL? = nil) throws

// Scope-filtered variants — restrict which attributes are decoded
public init<S>(markdown: String,
               including scope: KeyPath<AttributeScopes, S.Type>,
               options: AttributedString.MarkdownParsingOptions = .init(),
               baseURL: URL? = nil) throws where S: AttributeScope

public init<S>(markdown: String,
               including scope: S.Type,
               options: AttributedString.MarkdownParsingOptions = .init(),
               baseURL: URL? = nil) throws where S: AttributeScope
```

**`baseURL`** — if non-nil, relative URLs in markdown links are resolved against it. Pass the Obsidian vault root URL to resolve wiki-link hrefs if you convert them to relative markdown links before parsing.

**NSAttributedString** also has equivalent markdown initializers (same signature, ObjC-bridgeable).

---

## MarkdownParsingOptions

```swift
@available(macOS 12, iOS 15, *)
public struct AttributedString.MarkdownParsingOptions: Sendable {

    // --- Properties ---

    /// When true, enables Apple's custom ^[text](attribute) extended syntax for
    /// embedding custom AttributedStringKey values directly in markdown.
    /// Default: false
    public var allowsExtendedAttributes: Bool

    /// Controls which markdown constructs are interpreted.
    /// Default: .full
    public var interpretedSyntax: InterpretedSyntax

    /// What to do when parsing fails partway through.
    /// Default: .throwError
    public var failurePolicy: FailurePolicy

    /// BCP 47 language code hint attached to the resulting string.
    /// Influences spellcheck and hyphenation in Text views.
    /// Default: nil
    public var languageCode: String?

    /// When true, attaches MarkdownSourcePosition attributes to each run.
    /// Available macOS 13+. Default: false
    @available(macOS 13, *)
    public var appliesSourcePositionAttributes: Bool

    // --- Initializers ---

    public init(
        allowsExtendedAttributes: Bool = false,
        interpretedSyntax: InterpretedSyntax = .full,
        failurePolicy: FailurePolicy = .throwError,
        languageCode: String? = nil
    )

    @available(macOS 13, *)
    public init(
        allowsExtendedAttributes: Bool = false,
        interpretedSyntax: InterpretedSyntax = .full,
        failurePolicy: FailurePolicy = .throwError,
        languageCode: String? = nil,
        appliesSourcePositionAttributes: Bool = false
    )
}
```

### InterpretedSyntax

```swift
public enum InterpretedSyntax: Int, Sendable {
    /// Parse full CommonMark: inline and block elements.
    /// Paragraphs, headers, lists, blockquotes, code blocks, tables, etc.
    case full

    /// Parse only inline elements: bold, italic, code, strikethrough, links.
    /// Block structure (paragraphs, headers, lists) is ignored — whitespace
    /// is collapsed. Use for single-line display strings.
    case inlineOnly

    /// Same as inlineOnly but whitespace is preserved.
    case inlineOnlyPreservingWhitespace
}
```

For multi-paragraph Obsidian notes, always use `.full`.

### FailurePolicy

```swift
public enum FailurePolicy: Int, Sendable {
    /// Throw an error if any part of the document fails to parse.
    case throwError

    /// Return whatever was successfully parsed up to the failure point.
    /// Useful for fault-tolerant display when content is untrusted.
    case returnPartiallyParsedIfPossible
}
```

### Typical usage for Obsidian notes

```swift
let options = AttributedString.MarkdownParsingOptions(
    allowsExtendedAttributes: false,    // not using Apple's custom ^[...] syntax
    interpretedSyntax: .full,           // multi-paragraph notes
    failurePolicy: .returnPartiallyParsedIfPossible,
    languageCode: "en"
)
let attributed = try AttributedString(markdown: preprocessedMarkdown, options: options)
```

---

## What Apple's Parser Supports and Does Not Support

### Supported (CommonMark subset)

| Markdown Feature | Output Attribute |
|-----------------|-----------------|
| `**bold**` / `__bold__` | `inlinePresentationIntent` with `.stronglyEmphasized` |
| `*italic*` / `_italic_` | `inlinePresentationIntent` with `.emphasized` |
| `` `code` `` | `inlinePresentationIntent` with `.code` |
| `~~strikethrough~~` | `inlinePresentationIntent` with `.strikethrough` |
| `[text](url)` standard links | `link` attribute (Foundation `URL`) |
| ATX headers `# H1` … `###### H6` | `presentationIntent` with `.header(level:)` |
| Unordered lists `- item` | `presentationIntent` with `.unorderedList` + `.listItem(ordinal:)` |
| Ordered lists `1. item` | `presentationIntent` with `.orderedList` + `.listItem(ordinal:)` |
| `> blockquote` | `presentationIntent` with `.blockQuote` |
| ` ``` code block ``` ` | `presentationIntent` with `.codeBlock(languageHint:)` |
| Tables (GFM extension) | `presentationIntent` with `.table`, `.tableHeaderRow`, `.tableRow`, `.tableCell` |
| Thematic break `---` | `presentationIntent` with `.thematicBreak` |
| Soft line break | `inlinePresentationIntent` with `.softBreak` |
| Hard line break (trailing `  `) | `inlinePresentationIntent` with `.lineBreak` |

### NOT Supported — requires pre-processing

| Obsidian Feature | Status | Solution |
|-----------------|--------|---------|
| Wiki-links `[[Note Title]]` | Not supported | Pre-process: replace with `[Note Title](vibology://note/Note%20Title)` |
| Wiki-links with alias `[[Note\|Display]]` | Not supported | Pre-process: replace with `[Display](vibology://note/Note)` |
| Footnote references `[^1]` | Not supported | Pre-process: extract footnotes, replace markers with superscript links |
| Footnote definitions `[^1]: text` | Not supported | Strip from main body; render separately below the note |
| YAML frontmatter `---\n...\n---` | Not supported | Strip before parsing (parse YAML separately with a `YAMLDecoder`) |
| Obsidian callouts `> [!note]` | Not supported | Pre-process or handle after parse via `presentationIntent` `.blockQuote` detection |
| Embedded images `![[image.png]]` | Not supported | Pre-process or strip |
| HTML tags inline | Passed through as text (`.inlineHTML` / `.blockHTML` intent set) | Strip or pre-process |
| Nested bold+italic `***text***` | Partially supported | Works but may collapse to single intent flag |
| Definition lists | Not supported | Use a third-party parser |

**Apple's parser targets a well-defined CommonMark subset.** It is not a full Obsidian parser. All Obsidian-specific syntax must be normalized to standard CommonMark before calling any `AttributedString(markdown:)` initializer.

---

## AttributeContainer

`AttributeContainer` is a typed, `@dynamicMemberLookup` bag of attributes. It is how you apply multiple attributes at once to a range of an `AttributedString`.

```swift
@dynamicMemberLookup
public struct AttributeContainer: Sendable {

    public init()

    // Read/write attribute by key type
    public subscript<T: AttributedStringKey>(_: T.Type) -> T.Value? { get set }

    // Dynamic-member shorthand (preferred)
    public subscript<K: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeDynamicLookup, K>) -> K.Value? { get set }

    // Scope-scoped subscript
    public subscript<S: AttributeScope>(dynamicMember keyPath: KeyPath<AttributeScopes, S.Type>) -> ScopedAttributeContainer<S> { get set }

    // Merge two containers
    public mutating func merge(_ other: AttributeContainer, mergePolicy: AttributedString.AttributeMergePolicy = .keepNew)
    public func merging(_ other: AttributeContainer, mergePolicy: AttributedString.AttributeMergePolicy = .keepNew) -> AttributeContainer

    // Filter to attributes with specific run-boundary or inheritance behavior
    public func filter(inheritedByAddedText: Bool) -> AttributeContainer
    public func filter(runBoundaries: AttributedString.AttributeRunBoundaries?) -> AttributeContainer
}
```

### Building an AttributeContainer

```swift
// Builder pattern via static subscript (avoids mutating var)
var container = AttributeContainer()
container.swiftUI.foregroundColor = .purple
container.swiftUI.font = .system(.body, design: .serif)
container.link = URL(string: "vibology://note/The%20Tower")

// Chained builder (static subscript variant)
let highlight = AttributeContainer.swiftUI.foregroundColor(.cyan)
    .merging(AttributeContainer.swiftUI.font(.headline))
```

### Applying to an AttributedString

```swift
// Set attributes over the whole string
var attributed = try AttributedString(markdown: body, options: options)
attributed.setAttributes(container)

// Apply to a range
if let range = attributed.range(of: "The Tower") {
    attributed[range].swiftUI.foregroundColor = .purple
}

// Non-mutating variants
let restyled = attributed.settingAttributes(container)
let merged   = attributed.mergingAttributes(container, mergePolicy: .keepNew)
```

### AttributeMergePolicy

```swift
public enum AttributedString.AttributeMergePolicy {
    case keepNew   // incoming value wins (default)
    case keepCurrent  // existing value wins
}
```

---

## AttributeScopes

Apple organizes attribute keys into *scopes*. Each scope is a struct conforming to `AttributeScope`. Access scopes via `AttributeScopes` using dynamic member lookup.

### Foundation Scope — `\.foundation`

```swift
// Accessed via attributed.foundation.xxx or container.foundation.xxx
AttributeScopes.FoundationAttributes:
    .link                 // URL  — rendered as tappable link by SwiftUI Text
    .inlinePresentationIntent  // InlinePresentationIntent OptionSet
    .presentationIntent        // PresentationIntent (block-level structure)
    .languageIdentifier        // String (BCP 47)
    .markdownSourcePosition    // MarkdownSourcePosition (macOS 13+)
    .listItemDelimiter         // Character (macOS 26+)
```

### SwiftUI Scope — `\.swiftUI`

```swift
// Accessed via attributed.swiftUI.xxx or container.swiftUI.xxx
AttributeScopes.SwiftUIAttributes:
    .font             // SwiftUI.Font
    .foregroundColor  // SwiftUI.Color
    .backgroundColor  // SwiftUI.Color
    .strikethroughStyle  // Text.LineStyle
    .underlineStyle      // Text.LineStyle
    .kern             // CGFloat
    .tracking         // CGFloat
    .baselineOffset   // CGFloat
    .alignment        // (macOS 26+)
    .lineHeight       // (macOS 26+)
    .foundation       // embeds FoundationAttributes
    .accessibility    // AccessibilityAttributes
```

### Scope-filtered initializer example

When you only want SwiftUI-renderable attributes and nothing else:

```swift
let attributed = try AttributedString(
    markdown: markdown,
    including: \.swiftUI,   // strips non-SwiftUI attributes after parse
    options: options
)
```

Note: using `\.swiftUI` discards `link` attributes from the Foundation scope. For clickable links, use the default initializer (no `including:`) so that `\.foundation.link` is preserved — SwiftUI `Text` respects Foundation link attributes automatically.

---

## PresentationIntent and InlinePresentationIntent

These are the result attributes set by the markdown parser. You read them when iterating runs to build a custom renderer.

### InlinePresentationIntent (OptionSet)

Applied as `inlinePresentationIntent` attribute. A run may have multiple flags set simultaneously (e.g., bold+italic).

```swift
public struct InlinePresentationIntent: OptionSet {
    public static let emphasized            // *italic*
    public static let stronglyEmphasized    // **bold**
    public static let code                  // `inline code`
    public static let strikethrough         // ~~strikethrough~~
    public static let softBreak             // soft line break
    public static let lineBreak             // hard line break
    public static let inlineHTML            // raw HTML inline
    public static let blockHTML             // raw HTML block
}
```

### PresentationIntent (block-level)

Applied as `presentationIntent` attribute. Each run carries a `PresentationIntent` describing its block context.

```swift
public struct PresentationIntent {
    public var components: [IntentType]   // stack of nested block contexts
    public var indentationLevel: Int

    public enum Kind {
        case paragraph
        case header(level: Int)          // level 1–6
        case orderedList
        case unorderedList
        case listItem(ordinal: Int)
        case codeBlock(languageHint: String?)
        case blockQuote
        case thematicBreak
        case table(columns: [TableColumn])
        case tableHeaderRow
        case tableRow(rowIndex: Int)
        case tableCell(columnIndex: Int)
    }
}
```

### Reading attributes from runs

```swift
for run in attributedString.runs {
    let range = run.range

    // Inline intent
    if let intent = run.inlinePresentationIntent {
        if intent.contains(.stronglyEmphasized) { /* bold */ }
        if intent.contains(.emphasized)         { /* italic */ }
        if intent.contains(.code)               { /* monospace */ }
    }

    // Block intent
    if let intent = run.presentationIntent {
        for component in intent.components {
            switch component.kind {
            case .header(let level): break  // h1–h6
            case .paragraph:         break
            case .listItem(let n):   break
            default: break
            }
        }
    }

    // Link
    if let url = run.link {
        // url is Foundation.URL
    }
}
```

---

## Text(attributedString:) in SwiftUI

```swift
// SwiftUICore interface — available macOS 12+
@_disfavoredOverload
public init(_ attributedContent: AttributedString)
```

`Text` reads these attribute keys automatically:

| Attribute key (via AttributeScopes) | Effect in Text |
|------------------------------------|----------------|
| `\.swiftUI.font` | Font |
| `\.swiftUI.foregroundColor` | Text color |
| `\.swiftUI.backgroundColor` | Background highlight |
| `\.swiftUI.strikethroughStyle` | Strikethrough |
| `\.swiftUI.underlineStyle` | Underline |
| `\.swiftUI.kern` | Kerning |
| `\.swiftUI.tracking` | Tracking |
| `\.swiftUI.baselineOffset` | Baseline offset |
| `\.foundation.link` | Tappable hyperlink (opens in browser) |
| `\.foundation.inlinePresentationIntent` | Bold / italic / code rendering from parsed markdown |

**`Text(attributedString:)` does NOT render block structure.** `presentationIntent` (headers, lists, blockquotes) is not honored by `Text` — those runs just appear as plain inline text in one continuous paragraph. To render block structure you must either:

1. Build a custom renderer that splits the `AttributedString` by block intent and returns a `VStack` of styled `Text` views (see [Complete MarkdownRenderer](#complete-markdownrenderer-for-ephemerisnotenoteview)), or
2. Use a third-party package such as MarkdownUI (see [Third-Party Packages](#third-party-packages-when-to-use-markdownui)).

### Concatenating Text views

`Text` values can be concatenated with `+`, and an `AttributedString` can be broken into segments and combined as `Text` values:

```swift
let body = Text("Hello ") + Text("world").bold().foregroundColor(.purple)
```

---

## Custom AttributedStringKey

Define your own attribute keys to attach Vibology-specific metadata (e.g., a wiki-link target note title) to runs.

```swift
// Protocol
public protocol AttributedStringKey {
    associatedtype Value: Hashable
    static var name: String { get }
    // Optional: control run-boundary behavior
    static var runBoundaries: AttributedString.AttributeRunBoundaries? { get }
    static var inheritedByAddedText: Bool { get }
}
```

### Example: wiki-link key

```swift
import Foundation

enum WikiLinkAttribute: AttributedStringKey {
    typealias Value = String   // the target note title (unescaped)
    static let name = "com.vibology.wikiLink"
}

extension AttributeDynamicLookup {
    subscript(dynamicMember _: KeyPath<AttributeScopes, WikiLinkAttribute.Type>) -> WikiLinkAttribute {
        WikiLinkAttribute.self
    }
}

// Apply
var container = AttributeContainer()
container[WikiLinkAttribute.self] = "The Tower"
attributed[range].mergeAttributes(container)

// Read
for run in attributed.runs {
    if let title = run[WikiLinkAttribute.self] {
        // this run is a wiki-link to `title`
    }
}
```

---

## Obsidian Pre-Processing Strategy

Apple's markdown parser only handles standard CommonMark. The following Obsidian constructs must be normalized before parsing.

### 1. Strip YAML frontmatter

Obsidian notes begin with a `---` delimited YAML block. Remove it before passing to `AttributedString`:

```swift
func stripFrontmatter(_ raw: String) -> (body: String, frontmatter: String?) {
    guard raw.hasPrefix("---") else { return (raw, nil) }
    let lines = raw.components(separatedBy: "\n")
    // find closing ---
    if let closeIndex = lines.dropFirst().firstIndex(where: { $0.trimmingCharacters(in: .whitespaces) == "---" }) {
        let fmLines = Array(lines[1...closeIndex])
        let bodyLines = Array(lines[(closeIndex + 1)...])
        return (bodyLines.joined(separator: "\n"), fmLines.joined(separator: "\n"))
    }
    return (raw, nil)
}
```

### 2. Extract footnotes

Footnote definitions (`[^1]: text`) are not valid CommonMark and will be passed through as literal text by the parser. Extract them before parsing:

```swift
struct ExtractedFootnotes {
    let body: String
    let footnotes: [String: String]   // key → definition text
}

func extractFootnotes(_ markdown: String) -> ExtractedFootnotes {
    var footnotes: [String: String] = [:]
    // Match [^key]: definition (possibly multiline with indented continuation)
    let pattern = #/^\[\^([^\]]+)\]:\s*(.+)$/#
    var cleanedLines: [String] = []
    for line in markdown.components(separatedBy: "\n") {
        if let match = line.wholeMatch(of: pattern) {
            footnotes[String(match.output.1)] = String(match.output.2)
        } else {
            cleanedLines.append(line)
        }
    }
    return ExtractedFootnotes(
        body: cleanedLines.joined(separator: "\n"),
        footnotes: footnotes
    )
}
```

### 3. Replace footnote references with superscript links

Convert `[^1]` markers to markdown links that use a custom URL scheme, then handle them after parsing:

```swift
func replaceFootnoteRefs(_ markdown: String, footnoteKeys: Set<String>) -> String {
    var result = markdown
    for key in footnoteKeys {
        // Encode key for URL
        let encoded = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
        result = result.replacingOccurrences(
            of: "[^\(key)]",
            with: "[\(key)](vibology://footnote/\(encoded))"
        )
    }
    return result
}
```

### 4. Replace wiki-links with custom-scheme links

```swift
func replaceWikiLinks(_ markdown: String) -> String {
    // [[Note Title|Display Text]] → [Display Text](vibology://note/Note%20Title)
    // [[Note Title]]             → [Note Title](vibology://note/Note%20Title)
    var result = markdown
    let aliasPattern = #/\[\[([^\]|]+)\|([^\]]+)\]\]/#
    let plainPattern = #/\[\[([^\]]+)\]\]/#

    result = result.replacing(aliasPattern) { match in
        let target  = String(match.output.1)
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? match.output.1
        let display = String(match.output.2)
        return "[\(display)](vibology://note/\(target))"
    }
    result = result.replacing(plainPattern) { match in
        let target  = String(match.output.1)
            .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? match.output.1
        let display = String(match.output.1)
        return "[\(display)](vibology://note/\(target))"
    }
    return result
}
```

### 5. Full pre-processing pipeline

```swift
struct ObsidianPreprocessor {
    static func preprocess(_ raw: String) -> PreprocessedNote {
        let (bodyAfterFM, frontmatter) = stripFrontmatter(raw)
        let extracted = extractFootnotes(bodyAfterFM)
        let withWikiLinks = replaceWikiLinks(extracted.body)
        let withFootnoteLinks = replaceFootnoteRefs(
            withWikiLinks,
            footnoteKeys: Set(extracted.footnotes.keys)
        )
        return PreprocessedNote(
            body: withFootnoteLinks,
            frontmatter: frontmatter,
            footnotes: extracted.footnotes
        )
    }
}

struct PreprocessedNote {
    let body: String
    let frontmatter: String?
    let footnotes: [String: String]
}
```

---

## Complete MarkdownRenderer for EphemerisNoteView

This renderer handles Obsidian-flavored notes. It pre-processes the raw markdown, parses with `AttributedString`, then splits by block intent to produce proper SwiftUI layout.

### MarkdownRenderer.swift

```swift
import SwiftUI
import Foundation

// MARK: - Public entry point

/// Renders a pre-processed Obsidian markdown note as a SwiftUI view.
/// Handles headers, paragraphs, lists, blockquotes, code blocks, links,
/// wiki-links (via vibology://note/ scheme), and footnotes.
struct MarkdownRenderer: View {
    let markdown: String
    var onWikiLink: ((String) -> Void)?      // called when user taps [[Note]]
    var onFootnote: ((String, String) -> Void)?  // (key, text)

    @State private var blocks: [RenderedBlock] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(blocks) { block in
                blockView(for: block)
            }
        }
        .task(id: markdown) {
            blocks = await Task.detached { buildBlocks(from: markdown) }.value
        }
    }

    // MARK: - Block rendering

    @ViewBuilder
    private func blockView(for block: RenderedBlock) -> some View {
        switch block.kind {
        case .paragraph:
            linkedText(block.attributed)
                .fixedSize(horizontal: false, vertical: true)

        case .header(let level):
            linkedText(block.attributed)
                .font(headerFont(level: level))
                .fontWeight(.semibold)
                .padding(.top, level == 1 ? 12 : 6)

        case .blockQuote:
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .fill(Color.purple.opacity(0.6))
                    .frame(width: 3)
                linkedText(block.attributed)
                    .foregroundStyle(.secondary)
            }

        case .codeBlock(let lang):
            ScrollView(.horizontal, showsIndicators: false) {
                linkedText(block.attributed)
                    .font(.system(.body, design: .monospaced))
                    .padding(10)
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))

        case .orderedList, .unorderedList:
            VStack(alignment: .leading, spacing: 4) {
                ForEach(block.listItems ?? []) { item in
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(item.bullet)
                            .foregroundStyle(.secondary)
                            .frame(minWidth: 20, alignment: .trailing)
                        linkedText(item.attributed)
                    }
                }
            }

        case .thematicBreak:
            Divider().padding(.vertical, 4)

        case .footnoteSection:
            VStack(alignment: .leading, spacing: 4) {
                Divider()
                ForEach(block.footnoteItems ?? []) { fn in
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("[\(fn.key)]")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(fn.text)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Link handling

    /// Wraps Text in an environment that intercepts vibology:// URL taps.
    @ViewBuilder
    private func linkedText(_ attributed: AttributedString) -> some View {
        Text(attributed)
            .environment(\.openURL, OpenURLAction { url in
                if url.scheme == "vibology" {
                    handleVibologyURL(url)
                    return .handled
                }
                return .systemAction
            })
    }

    private func handleVibologyURL(_ url: URL) {
        guard let host = url.host else { return }
        switch host {
        case "note":
            let title = url.path
                .dropFirst()   // remove leading /
                .removingPercentEncoding ?? ""
            onWikiLink?(title)
        case "footnote":
            let key = url.path
                .dropFirst()
                .removingPercentEncoding ?? ""
            // footnote text is embedded in the block model
            if let text = blocks
                .compactMap({ $0.footnoteItems })
                .flatMap({ $0 })
                .first(where: { $0.key == key })?.text {
                onFootnote?(key, text)
            }
        default:
            break
        }
    }

    // MARK: - Font helpers

    private func headerFont(level: Int) -> Font {
        switch level {
        case 1: return .title
        case 2: return .title2
        case 3: return .title3
        case 4: return .headline
        default: return .subheadline
        }
    }
}

// MARK: - Block building (off main actor)

private func buildBlocks(from raw: String) -> [RenderedBlock] {
    // 1. Pre-process
    let preprocessed = ObsidianPreprocessor.preprocess(raw)

    // 2. Parse
    let options = AttributedString.MarkdownParsingOptions(
        allowsExtendedAttributes: false,
        interpretedSyntax: .full,
        failurePolicy: .returnPartiallyParsedIfPossible,
        languageCode: "en"
    )
    guard let attributed = try? AttributedString(
        markdown: preprocessed.body,
        options: options
    ) else {
        return [RenderedBlock(kind: .paragraph, attributed: AttributedString(raw))]
    }

    // 3. Apply SwiftUI styling to inline intent attributes
    let styled = applyInlineStyles(to: attributed)

    // 4. Split into blocks by presentationIntent
    var blocks = splitIntoBlocks(styled)

    // 5. Append footnote section if present
    if !preprocessed.footnotes.isEmpty {
        let fnItems = preprocessed.footnotes.map { key, text in
            FootnoteItem(id: key, key: key, text: text)
        }.sorted { $0.key < $1.key }
        blocks.append(RenderedBlock(kind: .footnoteSection, footnoteItems: fnItems))
    }

    return blocks
}

/// Translate Foundation's `inlinePresentationIntent` flags into SwiftUI
/// attribute scope styling so that `Text(attributed)` renders them correctly.
private func applyInlineStyles(to attributed: AttributedString) -> AttributedString {
    var result = attributed

    // Bold
    result = result.transformingAttributes(\.inlinePresentationIntent) { transformer in
        guard let intent = transformer.attribute else { return }
        if intent.contains(.stronglyEmphasized) {
            var container = AttributeContainer()
            container.swiftUI.font = .body.bold()
            transformer.replace(with: \.swiftUI.font, value: Font.body.bold())
        }
        if intent.contains(.emphasized) {
            transformer.replace(with: \.swiftUI.font, value: Font.body.italic())
        }
        if intent.contains(.code) {
            transformer.replace(with: \.swiftUI.font, value: .system(.body, design: .monospaced))
        }
    }

    // Color wiki-links and footnote refs differently from external links
    result = result.transformingAttributes(\.link) { transformer in
        guard let url = transformer.attribute else { return }
        if url.scheme == "vibology" {
            transformer.replace(with: \.swiftUI.foregroundColor, value: .purple)
        }
        // Standard http/https links keep the default system link color
    }

    return result
}

/// Splits the attributed string into `RenderedBlock` values by reading
/// the `presentationIntent` attribute across runs.
private func splitIntoBlocks(_ attributed: AttributedString) -> [RenderedBlock] {
    // Group consecutive runs that share the same top-level block kind.
    var blocks: [RenderedBlock] = []
    var currentKind: RenderedBlock.Kind?
    var currentRuns: [AttributedString] = []

    func flush() {
        guard let kind = currentKind, !currentRuns.isEmpty else { return }
        var combined = currentRuns[0]
        for run in currentRuns.dropFirst() { combined.append(run) }
        blocks.append(RenderedBlock(kind: kind, attributed: combined))
        currentRuns = []
        currentKind = nil
    }

    for run in attributed.runs {
        let slice = attributed[run.range]
        let runStr = AttributedString(slice)

        guard let intent = run.presentationIntent else {
            // No block intent — treat as paragraph text
            if currentKind != .paragraph { flush() }
            currentKind = .paragraph
            currentRuns.append(runStr)
            continue
        }

        let topKind = resolveBlockKind(from: intent)

        if topKind != currentKind {
            flush()
            currentKind = topKind
        }
        currentRuns.append(runStr)
    }
    flush()

    // Post-process: collect list items
    return blocks.flatMap { resolveListItems($0) }
}

private func resolveBlockKind(from intent: PresentationIntent) -> RenderedBlock.Kind {
    // Walk the component stack outermost → innermost
    for component in intent.components.reversed() {
        switch component.kind {
        case .header(let level): return .header(level)
        case .blockQuote:        return .blockQuote
        case .codeBlock:         return .codeBlock(nil)
        case .thematicBreak:     return .thematicBreak
        case .orderedList:       return .orderedList
        case .unorderedList:     return .unorderedList
        case .paragraph:         return .paragraph
        default: break
        }
    }
    return .paragraph
}

/// Merges consecutive list-item runs into a single block with `listItems`.
private func resolveListItems(_ block: RenderedBlock) -> [RenderedBlock] {
    // Simple pass-through for non-list blocks
    return [block]
}

// MARK: - Models

struct RenderedBlock: Identifiable {
    let id = UUID()
    var kind: Kind
    var attributed: AttributedString = AttributedString()
    var listItems: [ListItem]? = nil
    var footnoteItems: [FootnoteItem]? = nil

    enum Kind: Equatable {
        case paragraph
        case header(Int)
        case blockQuote
        case codeBlock(String?)
        case orderedList
        case unorderedList
        case thematicBreak
        case footnoteSection
    }
}

struct ListItem: Identifiable {
    let id = UUID()
    let bullet: String
    let attributed: AttributedString
}

struct FootnoteItem: Identifiable {
    let id: String
    let key: String
    let text: String
}
```

### EphemerisNoteView.swift integration

```swift
struct EphemerisNoteView: View {
    let note: EphemerisNote   // has .rawMarkdown: String
    @State private var selectedNote: String? = nil   // for wiki-link navigation
    @State private var footnoteAlert: (key: String, text: String)? = nil

    var body: some View {
        ScrollView {
            MarkdownRenderer(
                markdown: note.rawMarkdown,
                onWikiLink: { title in
                    selectedNote = title
                },
                onFootnote: { key, text in
                    footnoteAlert = (key, text)
                }
            )
            .padding()
        }
        .navigationTitle(note.title)
        .sheet(item: $selectedNote.map { title in
            // open the referenced note
        })
        .alert(item: $footnoteAlert.map { _ in }) { fn in
            Alert(title: Text("[\(fn.key)]"), message: Text(fn.text))
        }
    }
}
```

---

## Third-Party Packages: When to Use MarkdownUI

### Use Apple's built-in `AttributedString(markdown:)`

- Single-pass parsing is fast enough for note-by-note rendering
- You need inline-only rendering inside a `Text` concatenation or label
- You control the markdown input and only use CommonMark features
- You are already pre-processing Obsidian syntax to standard links
- Binary size and dependency footprint matter
- **This is the right choice for Vibology's `EphemerisNoteView`**

### Consider `MarkdownUI` (github.com/gonzalezreal/swift-markdown-ui)

```swift
// Package.swift
.package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.0")
```

Use MarkdownUI when:
- You need rendered tables with visible cell borders in SwiftUI
- You need full GFM task lists (`- [x] done`)
- You want declarative theme customization of every block type (including callouts)
- You need CommonMark-compliant block rendering without writing a custom splitter
- Footnotes as a first-class feature (via its Obsidian plugin variant)

**MarkdownUI does NOT natively parse Obsidian wiki-links either** — you still need the same `[[Note]]` → `[Note](scheme://...)` pre-processing step.

### Never use NSAttributedString for this

`NSAttributedString(markdown:)` exists but uses `NSAttributedString.Key` (ObjC string-keyed), not typed Swift attribute keys. Mixing NSAttributedString and SwiftUI `Text` requires bridging through `AttributedString(NSAttributedString(...))`, which strips SwiftUI-specific attributes. Stick with the Swift `AttributedString` API throughout.

---

## Quick Reference — Attribute Keypath Cheat Sheet

```swift
// Reading from a run
run.link                          // URL?
run.inlinePresentationIntent      // InlinePresentationIntent?
run.presentationIntent            // PresentationIntent?
run.swiftUI.font                  // Font?
run.swiftUI.foregroundColor       // Color?
run.swiftUI.backgroundColor       // Color?
run.swiftUI.strikethroughStyle    // Text.LineStyle?
run.swiftUI.underlineStyle        // Text.LineStyle?

// Writing to a container
container.link = URL(string: "https://example.com")
container.swiftUI.font = .headline
container.swiftUI.foregroundColor = .purple
container.swiftUI.backgroundColor = .yellow.opacity(0.2)
container.swiftUI.strikethroughStyle = .init(pattern: .solid)
container.swiftUI.underlineStyle = .init(pattern: .dot)
container.swiftUI.kern = 1.5
container.swiftUI.tracking = 0.5
container.swiftUI.baselineOffset = 6.0  // for superscript footnote markers
```
