# SwiftUI API Reference

> Auto-generated from Xcode 26.2 SDK symbol graph — macOS 26 / iOS 26
> **⭐ New** = introduced in macOS/iOS 26

**972 types total · 109 new in macOS/iOS 26**

## Contents

- [Materials & Effects (New)](#materials-effects-new) (4 · 4 new ⭐)
- [Core Protocols & Modifiers](#core-protocols-modifiers) (100 · 14 new ⭐)
- [State & Data Flow](#state-data-flow) (20)
- [Layout](#layout) (78 · 3 new ⭐)
- [Navigation & Structure](#navigation-structure) (184 · 7 new ⭐)
- [Controls & Input](#controls-input) (205 · 32 new ⭐)
- [Text, Images & Color](#text,-images-color) (71 · 5 new ⭐)
- [Lists & Collections](#lists-collections) (55 · 1 new ⭐)
- [Animation & Transitions](#animation-transitions) (16 · 3 new ⭐)
- [Presentation](#presentation) (22)
- [Shapes & Drawing](#shapes-drawing) (6)
- [Gestures & Interaction](#gestures-interaction) (56 · 22 new ⭐)
- [Accessibility](#accessibility) (18)
- [Other](#other) (137 · 18 new ⭐)

---

## Materials & Effects (New)

### `GlassButtonStyle` ⭐
*struct · macOS 26.0, iOS 26.0*

A button style that applies glass border artwork based on the button's context.  You can also use ``PrimitiveButtonStyle/glass`` to construct this style.

```swift
struct GlassButtonStyle
```

### `GlassButtonStyle.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `GlassProminentButtonStyle` ⭐
*struct · macOS 26.0, iOS 26.0*

A button style that applies prominent glass border artwork based on the button's context.  You can also use ``PrimitiveButtonStyle/glassProminent`` to construct this style.

```swift
struct GlassProminentButtonStyle
```

### `GlassProminentButtonStyle.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

---

## Core Protocols & Modifiers

### `AnyCompositorContent` ⭐
*struct · macOS 26.0*

Type erased compositor content.

```swift
struct AnyCompositorContent
```

### `AnyCompositorContent.Body` ⭐
*typealias · macOS 26.0*

```swift
typealias Body = Never
```

### `AutomaticImmersionStyle` ⭐
*struct · macOS 26.0*

The default style of immersive spaces.  You don't typically use this style explicitly, but if you need to, use ``ImmersionStyle/automatic`` with the ``Scene/immersionStyle(selection:in:)``modifier to specify this style.

```swift
struct AutomaticImmersionStyle
```

### `CompositorContent` ⭐
*protocol · macOS 26.0*

```swift
@MainActor protocol CompositorContent
```

### `CompositorContentBuilder` ⭐
*struct · macOS 26.0*

A result builder for composing a collection of ``CompositorContent`` elements.

```swift
@resultBuilder struct CompositorContentBuilder
```

### `CompositorContentBuilder.Content` ⭐
*struct · macOS 26.0*

A representation of the content of a compositor content builder.

```swift
struct Content<C> where C : CompositorContent
```

### `CompositorContentBuilder.Content.Body` ⭐
*typealias · macOS 26.0*

```swift
typealias Body = Never
```

### `FindContext` ⭐
*struct · macOS 26.0, iOS 26.0*

The status of the find navigator for views which support text editing.  Views which support text editing can use this information to implement a a find navigator that is controlled using the modifiers used for controlling the find navigator throughout the rest of SwiftUI.  For example, the following shows a minimal find navigator implementation driven by the find context which falls back to local …

```swift
struct FindContext
```

### `FullImmersionStyle` ⭐
*struct · macOS 26.0*

An immersion style that displays unbounded content that completely replaces passthrough video.  When this immersion style is selected, the immersion amount reported by the closure of ``View/onImmersionChange(initial:_:)`` is `1.0`.  Use ``ImmersionStyle/full`` with the ``Scene/immersionStyle(selection:in:)``modifier to specify this style.

```swift
struct FullImmersionStyle
```

### `ImmersionChangeContext` ⭐
*struct · macOS 26.0*

A structure that represents a state of immersion of your app.  You don't use this structure directly. Instead, SwiftUI provides instances of this structure via the `onImmersionChange` modifier's closure.

```swift
struct ImmersionChangeContext
```

### `ImmersionStyle` ⭐
*protocol · macOS 26.0*

The styles that an immersive space can have.  Configure the appearance and behavior of an ``ImmersiveSpace`` by adding the ``Scene/immersionStyle(selection:in:)`` scene modifier to the space and specifying a style that conforms to this protocol, like ``ImmersionStyle/mixed`` or ``ImmersionStyle/full``. For example, the following app defines a solar system scene that uses full immersion:      @main…

```swift
protocol ImmersionStyle
```

### `ImmersiveSpaceContent` ⭐
*protocol · macOS 26.0*

A type that you can use as the content of an immersive space.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but it's not required.…

```swift
@MainActor @preconcurrency protocol ImmersiveSpaceContent
```

### `ImmersiveSpaceContentBuilder` ⭐
*struct · macOS 26.0*

A result builder for composing a collection of immersive space elements.

```swift
@resultBuilder struct ImmersiveSpaceContentBuilder
```

### `ProgressiveImmersionStyle` ⭐
*struct · macOS 26.0*

An immersion style that displays unbounded content that partially replaces passthrough video.  Use ``ImmersionStyle/progressive`` with the ``Scene/immersionStyle(selection:in:)``modifier to specify this style.

```swift
struct ProgressiveImmersionStyle
```

### `AccessoryCircularCapacityGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

A gauge style that displays a closed ring that's partially filled in to indicate the gauge's current value.  Use ``GaugeStyle/accessoryCircularCapacity`` to construct this style.

```swift
@MainActor @preconcurrency struct AccessoryCircularCapacityGaugeStyle
```

### `AccessoryCircularCapacityGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `AccessoryCircularGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

A gauge style that displays an open ring with a marker that appears at a point along the ring to indicate the gauge's current value.  Use ``GaugeStyle/accessoryCircular`` to construct this style.

```swift
@MainActor @preconcurrency struct AccessoryCircularGaugeStyle
```

### `AccessoryCircularGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `AccessoryLinearCapacityGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

A gauge style that displays bar that fills from leading to trailing edges as the gauge's current value increases.  Use ``GaugeStyle/accessoryLinearCapacity`` to construct this style.

```swift
@MainActor @preconcurrency struct AccessoryLinearCapacityGaugeStyle
```

### `AccessoryLinearCapacityGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `AccessoryLinearGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

A gauge style that displays bar with a marker that appears at a point along the bar to indicate the gauge's current value.  Use ``GaugeStyle/accessoryLinear`` to construct this style.

```swift
@MainActor @preconcurrency struct AccessoryLinearGaugeStyle
```

### `AccessoryLinearGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `AnimatableModifier`
*protocol · macOS 10.15, iOS 13.0*

A modifier that can create another modifier with animation.

```swift
protocol AnimatableModifier : Animatable, ViewModifier
```

### `App`
*protocol · macOS 11.0, iOS 14.0*

A type that represents the structure and behavior of an app.  Create an app by declaring a structure that conforms to the `App` protocol. Implement the required ``SwiftUI/App/body-swift.property`` computed property to define the app's content:      @main     struct MyApp: App {         var body: some Scene {             WindowGroup {                 Text("Hello, world!")             }         }   …

```swift
@MainActor @preconcurrency protocol App
```

### `AppStorage`
*struct · macOS 11.0, iOS 14.0*

A property wrapper type that reflects a value from `UserDefaults` and invalidates a view on a change in value in that user default.

```swift
@frozen @propertyWrapper struct AppStorage<Value>
```

### `AutomaticFormStyle`
*struct · macOS 13.0, iOS 16.0*

The default form style.  Use the ``FormStyle/automatic`` static variable to create this style:      Form {        ...     }     .formStyle(.automatic)

```swift
struct AutomaticFormStyle
```

### `AutomaticFormStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the appearance and interaction of a form.

```swift
typealias Body = some View
```

### `CircularProgressViewStyle`
*struct · macOS 11.0, iOS 14.0*

A progress view that uses a circular gauge to indicate the partial completion of an activity.  On watchOS, and in widgets and complications, a circular progress view appears as a gauge with the ``GaugeStyle/accessoryCircularCapacity`` style. If the progress view is indeterminate, the gauge is empty.  In cases where no determinate circular progress view style is available, circular progress views u…

```swift
struct CircularProgressViewStyle
```

### `CircularProgressViewStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view representing the body of a progress view.

```swift
typealias Body = some View
```

### `ContentMarginPlacement`
*struct · macOS 14.0, iOS 17.0*

The placement of margins.  Different views can support customizating margins that appear in different parts of that view. Use values of this type to customize those margins of a particular placement.  For example, use a ``ContentMarginPlacement/scrollIndicators`` placement to customize the margins of scrollable view's scroll indicators separately from the margins of a scrollable view's content.  U…

```swift
struct ContentMarginPlacement
```

### `ContentUnavailableView`
*struct · macOS 14.0, iOS 17.0*

An interface, consisting of a label and additional content, that you display when the content of your app is unavailable to users.  It is recommended to use `ContentUnavailableView` in situations where a view's content cannot be displayed. That could be caused by a network error, a list without items, a search that returns no results etc.  You create an `ContentUnavailableView` in its simplest for…

```swift
struct ContentUnavailableView<Label, Description, Actions> where Label : View, Description : View, Actions : View
```

### `ContentUnavailableView.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

The default gauge view style in the current context of the view being styled.  You can also use ``GaugeStyle/automatic`` to construct this style.

```swift
@MainActor @preconcurrency struct DefaultGaugeStyle
```

### `DefaultGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `DefaultProgressViewStyle`
*struct · macOS 11.0, iOS 14.0*

The default progress view style in the current context of the view being styled.  Use ``ProgressViewStyle/automatic`` to construct this style.

```swift
struct DefaultProgressViewStyle
```

### `DefaultProgressViewStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view representing the body of a progress view.

```swift
typealias Body = some View
```

### `DisplayProxy`
*struct · macOS 15.0*

A type which provides information about display hardware.  You can use this type with your custom window layouts to size and position windows relative to a display's bounds.  For example, your custom window layout can position a window 140 points from the bottom of the screen's visible area:      Window("Status", id: "status") {         StatusView()     }     .windowResizability(.contentSize)     …

```swift
struct DisplayProxy
```

### `DocumentConfiguration`
*struct · macOS 14.0, iOS 17.0*

```swift
struct DocumentConfiguration
```

### `EditableCollectionContent`
*struct · macOS 13.0, iOS 16.0*

An opaque wrapper view that adds editing capabilities to a row in a list.  You don't use this type directly. Instead SwiftUI creates this type on your behalf.

```swift
struct EditableCollectionContent<Content, Data>
```

### `EditableCollectionContent.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `EmptyWidgetConfiguration`
*struct · macOS 11.0, iOS 14.0*

An empty widget configuration.

```swift
@frozen struct EmptyWidgetConfiguration
```

### `EmptyWidgetConfiguration.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of widget configuration representing the body of this configuration.  When you create a custom widget, Swift infers this type from your implementation of the required `body` property.

```swift
typealias Body = Never
```

### `EquatableView`
*struct · macOS 10.15, iOS 13.0*

A view type that compares itself against its previous value and prevents its child updating if its new value is the same as its old value.

```swift
@frozen struct EquatableView<Content> where Content : Equatable, Content : View
```

### `EquatableView.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `FetchRequest.Configuration`
*struct · macOS 12.0, iOS 15.0*

The request's configurable properties.  You initialize a ``FetchRequest`` with an optional predicate and sort descriptors, either explicitly or using a configured <doc://com.apple.documentation/documentation/CoreData/NSFetchRequest>. Later, you can dynamically update the predicate and sort parameters using the request's configuration structure.  You access or bind to a request's configuration comp…

```swift
@MainActor @preconcurrency struct Configuration
```

### `FileDocument.ReadConfiguration`
*typealias · macOS 11.0, iOS 14.0*

The configuration for reading document contents.  This type is an alias for ``FileDocumentReadConfiguration``, which contains a content type and a file wrapper that you use to access the contents of a document file. You get a value of this type as an input to the ``init(configuration:)`` initializer. Use it to load a document from a file.

```swift
typealias ReadConfiguration = FileDocumentReadConfiguration
```

### `FileDocument.WriteConfiguration`
*typealias · macOS 11.0, iOS 14.0*

The configuration for writing document contents.  This type is an alias for ``FileDocumentWriteConfiguration``, which contains a content type and a file wrapper that you use to access the contents of a document file, if one already exists. You get a value of this type as an input to the ``fileWrapper(configuration:)`` method.

```swift
typealias WriteConfiguration = FileDocumentWriteConfiguration
```

### `FileDocumentConfiguration`
*struct · macOS 11.0, iOS 14.0*

The properties of an open file document.  You receive an instance of this structure when you create a ``DocumentGroup`` with a value file type. Use it to access the document in your viewer or editor.

```swift
struct FileDocumentConfiguration<Document> where Document : FileDocument
```

### `FileDocumentReadConfiguration`
*struct · macOS 11.0, iOS 14.0*

The configuration for reading file contents.

```swift
struct FileDocumentReadConfiguration
```

### `FileDocumentWriteConfiguration`
*struct · macOS 11.0, iOS 14.0*

The configuration for serializing file contents.

```swift
struct FileDocumentWriteConfiguration
```

### `FormStyle`
*protocol · macOS 13.0, iOS 16.0*

The appearance and behavior of a form.  To configure the style for a single ``Form`` or for all form instances in a view hierarchy, use the ``View/formStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurr…

```swift
@MainActor @preconcurrency protocol FormStyle
```

### `FormStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

The properties of a form instance.  You receive a `configuration` parameter of this type --- which is an alias for the ``FormStyleConfiguration`` type --- when you implement the required ``makeBody(configuration:)`` method in a custom form style implementation.

```swift
typealias Configuration = FormStyleConfiguration
```

### `FormStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a form instance.

```swift
struct FormStyleConfiguration
```

### `FormStyleConfiguration.Content`
*struct · macOS 13.0, iOS 16.0*

A type-erased content of a form.

```swift
@MainActor @preconcurrency struct Content
```

### `FormStyleConfiguration.Content.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GaugeStyle`
*protocol · macOS 13.0, iOS 16.0*

Defines the implementation of all gauge instances within a view hierarchy.  To configure the style for all the ``Gauge`` instances in a view hierarchy, use the ``View/gaugeStyle(_:)`` modifier. For example, you can configure a gauge to use the ``circular`` style:      Gauge(value: batteryLevel, in: 0...100) {         Text("Battery Level")     }     .gaugeStyle(.circular)  A type conforming to this…

```swift
@MainActor @preconcurrency protocol GaugeStyle
```

### `GaugeStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

The properties of a gauge instance.

```swift
typealias Configuration = GaugeStyleConfiguration
```

### `GaugeStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a gauge instance.

```swift
struct GaugeStyleConfiguration
```

### `LimitedAvailabilityConfiguration`
*struct · macOS 13.0, iOS 16.1*

A type-erased widget configuration.  You don't use this type directly. Instead SwiftUI creates this type on your behalf.

```swift
@MainActor @frozen @preconcurrency struct LimitedAvailabilityConfiguration
```

### `LimitedAvailabilityConfiguration.Body`
*typealias · macOS 13.0, iOS 16.1*

The type of widget configuration representing the body of this configuration.  When you create a custom widget, Swift infers this type from your implementation of the required `body` property.

```swift
typealias Body = Never
```

### `LinearCapacityGaugeStyle`
*struct · macOS 13.0, iOS 16.0*

A gauge style that displays bar that fills from leading to trailing edges as the gauge's current value increases.  Use ``GaugeStyle/linearCapacity`` to construct this style.

```swift
@MainActor @preconcurrency struct LinearCapacityGaugeStyle
```

### `LinearCapacityGaugeStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view representing the body of a gauge.

```swift
typealias Body = some View
```

### `LinearProgressViewStyle`
*struct · macOS 11.0, iOS 14.0*

A progress view that visually indicates its progress using a horizontal bar.  Use ``ProgressViewStyle/linear`` to construct this style.

```swift
struct LinearProgressViewStyle
```

### `LinearProgressViewStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view representing the body of a progress view.

```swift
typealias Body = some View
```

### `NSApplicationDelegateAdaptor`
*struct · macOS 11.0*

A property wrapper type that you use to create an AppKit app delegate.  To handle app delegate callbacks in an app that uses the SwiftUI life cycle, define a type that conforms to the <doc://com.apple.documentation/documentation/AppKit/NSApplicationDelegate> protocol, and implement the delegate methods that you need. For example, you can implement the <doc://com.apple.documentation/documentation/A…

```swift
@MainActor @preconcurrency @propertyWrapper struct NSApplicationDelegateAdaptor<DelegateType> where DelegateType : NSObject, DelegateType : NSApplicationDelegate
```

### `NSHostingView`
*class · macOS 10.15*

An AppKit view that hosts a SwiftUI view hierarchy.  You use `NSHostingView` objects to integrate SwiftUI views into your AppKit view hierarchies. A hosting view is an <doc://com.apple.documentation/documentation/AppKit/NSView> object that manages a single SwiftUI view, which may itself contain other SwiftUI views. Because it is an <doc://com.apple.documentation/documentation/AppKit/NSView> object…

```swift
@MainActor @preconcurrency class NSHostingView<Content> where Content : View
```

### `NSViewRepresentable`
*protocol · macOS 10.15*

A wrapper that you use to integrate an AppKit view into your SwiftUI view hierarchy.  Use an `NSViewRepresentable` instance to create and manage an <doc://com.apple.documentation/documentation/AppKit/NSView> object in your SwiftUI interface. Adopt this protocol in one of your app's custom instances, and use its methods to create, update, and tear down your view. The creation and update processes p…

```swift
@MainActor @preconcurrency protocol NSViewRepresentable : View where Self.Body == Never
```

### `NSViewRepresentable.Context`
*typealias · macOS 10.15*

```swift
typealias Context = NSViewRepresentableContext<Self>
```

### `NSViewRepresentableContext`
*struct · macOS 10.15*

Contextual information about the state of the system that you use to create and update your AppKit view.  An ``NSViewRepresentableContext`` structure contains details about the current state of the system. When creating and updating your view, the system creates one of these structures and passes it to the appropriate method of your custom ``NSViewRepresentable`` instance. Use the information in t…

```swift
@MainActor @preconcurrency struct NSViewRepresentableContext<View> where View : NSViewRepresentable
```

### `PointerStyle`
*struct · macOS 15.0*

A style describing the appearance of the pointer (also called a cursor) when it's hovered over a view.  Use the ``View/pointerStyle(_:)`` view modifier to set a view's pointer style.  For guidance on choosing an appropriate pointer style, refer to <doc://com.apple.documentation/design/human-interface-guidelines/pointing-devices> in the Human Interface Guidelines.

```swift
struct PointerStyle
```

### `PreviewContext`
*protocol · macOS 11.0, iOS 14.0*

A context type for use with a preview.

```swift
protocol PreviewContext
```

### `PreviewContextKey`
*protocol · macOS 11.0, iOS 14.0*

A key type for a preview context.  The default value is `nil`.

```swift
protocol PreviewContextKey
```

### `PreviewModifier`
*protocol · macOS 15.0, iOS 18.0*

A type that defines an environment in which previews can appear.  Conforming types can define shared contexts that will be cached by the preview system, then reused across participating previews. For example, you might create a model container here and populate it with sample data; in your `body` method you would then apply it to the preview using the `.modelContainer` view modifier.  ``` struct S…

```swift
@MainActor protocol PreviewModifier
```

### `PreviewModifier.Content`
*typealias · macOS 15.0, iOS 18.0*

The type-erased content of a preview.

```swift
typealias Content = PreviewModifierContent
```

### `PreviewModifierContent`
*struct · macOS 15.0, iOS 18.0*

The type-erased content of a preview.

```swift
struct PreviewModifierContent
```

### `PreviewModifierContent.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `PreviewProvider`
*protocol · macOS 10.15, iOS 13.0*

A type that produces view previews in Xcode.  > Important: You can use this protocol to define a preview manually, but   you typically use a preview macro like ``Preview(_:body:)`` instead.  You can create an Xcode preview by declaring a structure that conforms to the `PreviewProvider` protocol. Implement the required ``PreviewProvider/previews-swift.type.property`` computed property, and return t…

```swift
@MainActor @preconcurrency protocol PreviewProvider : _PreviewProvider
```

### `ProgressView`
*struct · macOS 11.0, iOS 14.0*

A view that shows the progress toward completion of a task.  Use a progress view to show that a task is incomplete but advancing toward completion. A progress view can show both determinate (percentage complete) and indeterminate (progressing or not) types of progress.  Create a determinate progress view by initializing a `ProgressView` with a binding to a numeric value that indicates the progress…

```swift
struct ProgressView<Label, CurrentValueLabel> where Label : View, CurrentValueLabel : View
```

### `ProgressView.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ProgressViewStyle`
*protocol · macOS 11.0, iOS 14.0*

A type that applies standard interaction behavior to all progress views within a view hierarchy.  To configure the current progress view style for a view hierarchy, use the ``View/progressViewStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomT…

```swift
@MainActor @preconcurrency protocol ProgressViewStyle
```

### `ProgressViewStyle.Configuration`
*typealias · macOS 11.0, iOS 14.0*

A type alias for the properties of a progress view instance.

```swift
typealias Configuration = ProgressViewStyleConfiguration
```

### `ProgressViewStyleConfiguration`
*struct · macOS 11.0, iOS 14.0*

The properties of a progress view instance.

```swift
struct ProgressViewStyleConfiguration
```

### `ReferenceFileDocument.ReadConfiguration`
*typealias · macOS 11.0, iOS 14.0*

The configuration for reading document contents.  This type is an alias for ``FileDocumentReadConfiguration``, which contains a content type and a file wrapper that you use to access the contents of a document file. You get a value of this type as an input to the ``init(configuration:)`` initializer. Use it to load a document from a file.

```swift
typealias ReadConfiguration = FileDocumentReadConfiguration
```

### `ReferenceFileDocument.WriteConfiguration`
*typealias · macOS 11.0, iOS 14.0*

The configuration for writing document contents.  This type is an alias for ``FileDocumentWriteConfiguration``, which contains a content type and a file wrapper that you use to access the contents of a document file, if one already exists. You get a value of this type as an input to the ``fileWrapper(snapshot:configuration:)`` method.

```swift
typealias WriteConfiguration = FileDocumentWriteConfiguration
```

### `ReferenceFileDocumentConfiguration`
*struct · macOS 11.0, iOS 14.0*

The properties of an open reference file document.  You receive an instance of this structure when you create a ``DocumentGroup`` with a reference file type. Use it to access the document in your viewer or editor.

```swift
@MainActor @preconcurrency struct ReferenceFileDocumentConfiguration<Document> where Document : ReferenceFileDocument
```

### `SearchUnavailableContent`
*struct · macOS 14.0, iOS 17.0*

A structure that represents the body of a static placeholder search view.  You don't create this type directly. SwiftUI creates it when you build a search``ContentUnavailableView``.

```swift
struct SearchUnavailableContent
```

### `SearchUnavailableContent.Actions`
*struct · macOS 14.0, iOS 17.0*

A view that represents the actions of a static `ContentUnavailableView.search` view.  You don't create this type directly. SwiftUI creates it when you build a search``ContentUnavailableView``.

```swift
@MainActor @preconcurrency struct Actions
```

### `SearchUnavailableContent.Actions.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SearchUnavailableContent.Description`
*struct · macOS 14.0, iOS 17.0*

A view that represents the description of a static `ContentUnavailableView.search` view.  You don't create this type directly. SwiftUI creates it when you build a search``ContentUnavailableView`.

```swift
@MainActor @preconcurrency struct Description
```

### `SearchUnavailableContent.Description.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SubscriptionView`
*struct · macOS 10.15, iOS 13.0*

A view that subscribes to a publisher with an action.

```swift
@frozen struct SubscriptionView<PublisherType, Content> where PublisherType : Publisher, Content : View, PublisherType.Failure == Never
```

### `SubscriptionView.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `TimelineView`
*struct · macOS 12.0, iOS 15.0*

A view that updates according to a schedule that you provide.  A timeline view acts as a container with no appearance of its own. Instead, it redraws the content it contains at scheduled points in time. For example, you can update the face of an analog timer once per second:      TimelineView(.periodic(from: startDate, by: 1)) { context in         AnalogTimerView(date: context.date)     }  The clo…

```swift
struct TimelineView<Schedule, Content> where Schedule : TimelineSchedule
```

### `TimelineView.Body`
*typealias · macOS 12.0, iOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `TimelineView.Context`
*struct · macOS 12.0, iOS 15.0*

Information passed to a timeline view's content callback.  The context includes both the ``date`` from the schedule that triggered the callback, and a ``cadence-swift.property`` that you can use to customize the appearance of your view. For example, you might choose to display the second hand of an analog clock only when the cadence is ``Cadence-swift.enum/seconds`` or faster.

```swift
struct Context
```

### `TimelineView.Context.Cadence`
*enum · macOS 12.0, iOS 15.0*

A rate at which timeline views can receive updates.  Use the cadence presented to content in a ``TimelineView`` to hide information that updates faster than the view's current update rate. For example, you could hide the millisecond component of a digital timer when the cadence is ``seconds`` or ``minutes``.  Because this enumeration conforms to the <doc://com.apple.documentation/documentation/Swi…

```swift
enum Cadence
```

### `TimelineViewDefaultContext`
*typealias · macOS 12.0, iOS 15.0*

Information passed to a timeline view's content callback.  The context includes both the date from the schedule that triggered the callback, and a cadence that you can use to customize the appearance of your view. For example, you might choose to display the second hand of an analog clock only when the cadence is ``TimelineView/Context/Cadence-swift.enum/seconds`` or faster.  > Note: This type ali…

```swift
typealias TimelineViewDefaultContext = TimelineView<EveryMinuteTimelineSchedule, Never>.Context
```

### `ViewThatFits`
*struct · macOS 13.0, iOS 16.0*

A view that adapts to the available space by providing the first child view that fits.  `ViewThatFits` evaluates its child views in the order you provide them to the initializer. It selects the first child whose ideal size on the constrained axes fits within the proposed size. This means that you provide views in order of preference. Usually this order is largest to smallest, but since a view migh…

```swift
@frozen struct ViewThatFits<Content> where Content : View
```

### `ViewThatFits.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `WidgetConfiguration`
*protocol · macOS 11.0, iOS 14.0*

A type that describes a widget's content.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but it's not required. Declare the conform…

```swift
@MainActor @preconcurrency protocol WidgetConfiguration
```

---

## State & Data Flow

### `AccessibilityFocusState`
*struct · macOS 12.0, iOS 15.0*

A property wrapper type that can read and write a value that SwiftUI updates as the focus of any active accessibility technology, such as VoiceOver, changes.  Use this capability to request that VoiceOver or other accessibility technologies programmatically focus on a specific element, or to determine whether VoiceOver or other accessibility technologies are focused on particular elements. Use ``V…

```swift
@propertyWrapper @frozen struct AccessibilityFocusState<Value> where Value : Hashable
```

### `AccessibilityFocusState.Binding`
*struct · macOS 12.0, iOS 15.0*

```swift
@propertyWrapper @frozen struct Binding
```

### `DefaultFocusEvaluationPriority`
*struct · macOS 13.0, iOS 16.0*

Prioritizations for default focus preferences when evaluating where to move focus in different circumstances.

```swift
struct DefaultFocusEvaluationPriority
```

### `FocusInteractions`
*struct · macOS 14.0, iOS 17.0*

Values describe different focus interactions that a view can support.

```swift
struct FocusInteractions
```

### `FocusInteractions.ArrayLiteralElement`
*typealias · macOS 14.0, iOS 17.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = FocusInteractions
```

### `FocusInteractions.Element`
*typealias · macOS 14.0, iOS 17.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = FocusInteractions
```

### `FocusInteractions.RawValue`
*typealias · macOS 14.0, iOS 17.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `FocusState`
*struct · macOS 12.0, iOS 15.0*

A property wrapper type that can read and write a value that SwiftUI updates as the placement of focus within the scene changes.  Use this property wrapper in conjunction with ``View/focused(_:equals:)`` and ``View/focused(_:)`` to describe views whose appearance and contents relate to the location of focus in the scene. When focus enters the modified view, the wrapped value of this property updat…

```swift
@frozen @propertyWrapper struct FocusState<Value> where Value : Hashable
```

### `FocusState.Binding`
*struct · macOS 12.0, iOS 15.0*

A property wrapper type that can read and write a value that indicates the current focus location.

```swift
@frozen @propertyWrapper struct Binding
```

### `FocusedBinding`
*struct · macOS 11.0, iOS 14.0*

A convenience property wrapper for observing and automatically unwrapping state bindings from the focused view or one of its ancestors.  If multiple views publish bindings using the same key, the wrapped property will reflect the value of the binding from the view closest to focus.

```swift
@propertyWrapper struct FocusedBinding<Value>
```

### `FocusedObject`
*struct · macOS 13.0, iOS 16.0*

A property wrapper type for an observable object supplied by the focused view or one of its ancestors.  Focused objects invalidate the current view whenever the observable object changes. If multiple views publish a focused object using the same key, the wrapped property will reflect the object that's closest to the focused view.

```swift
@MainActor @frozen @propertyWrapper @preconcurrency struct FocusedObject<ObjectType> where ObjectType : ObservableObject
```

### `FocusedObject.Wrapper`
*struct · macOS 13.0, iOS 16.0*

A wrapper around the underlying focused object that can create bindings to its properties using dynamic member lookup.

```swift
@MainActor @preconcurrency @dynamicMemberLookup @frozen struct Wrapper
```

### `FocusedValue`
*struct · macOS 11.0, iOS 14.0*

A property wrapper for observing values from the focused view or one of its ancestors.  If multiple views publish values using the same key, the wrapped property  will reflect the value from the view closest to focus.

```swift
@propertyWrapper struct FocusedValue<Value>
```

### `FocusedValueKey`
*protocol · macOS 11.0, iOS 14.0*

A protocol for identifier types used when publishing and observing focused values.  Unlike ``EnvironmentKey``, `FocusedValueKey` has no default value requirement, because the default value for a key is always `nil`.  Use the ``Entry`` macro to create custom focused values by extending `FocusedValues` with new properties:      extension FocusedValues {         @Entry var selectedItem: Item?     }  …

```swift
protocol FocusedValueKey
```

### `FocusedValues`
*struct · macOS 11.0, iOS 14.0*

A collection of state exported by the focused scene or view and its ancestors.  ## Creating Custom Focused Values  Use the ``Entry`` macro to create custom focused values by extending `FocusedValues` with new properties:      extension FocusedValues {         @Entry var focusedDocument: Binding<MyDocument>?     }  The ``Entry`` macro automatically generates the underlying key type and  provides th…

```swift
struct FocusedValues
```

### `GestureState`
*struct · macOS 10.15, iOS 13.0*

A property wrapper type that updates a property while the user performs a gesture and resets the property back to its initial state when the gesture ends.  Declare a property as `@GestureState`, pass as a binding to it as a parameter to a gesture's ``Gesture/updating(_:body:)`` callback, and receive updates to it. A property that's declared as `@GestureState` implicitly resets when the gesture bec…

```swift
@propertyWrapper @frozen struct GestureState<Value>
```

### `GestureStateGesture`
*struct · macOS 10.15, iOS 13.0*

A gesture that updates the state provided by a gesture's updating callback.  A gesture's ``Gesture/updating(_:body:)`` callback returns a `GestureStateGesture` instance for updating a transient state property that's annotated with the ``GestureState`` property wrapper.

```swift
@frozen struct GestureStateGesture<Base, State> where Base : Gesture
```

### `GestureStateGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `GestureStateGesture.Value`
*typealias · macOS 10.15, iOS 13.0*

The type representing the gesture's value.

```swift
typealias Value = Base.Value
```

### `ResetFocusAction`
*struct · macOS 12.0*

An environment value that provides the ability to reevaluate default focus.  Get the ``EnvironmentValues/resetFocus`` environment value and call it as a function to force a default focus reevaluation at runtime.      @Namespace var mainNamespace     @Environment(\.resetFocus) var resetFocus      var body: some View {         // ...         resetFocus(in: mainNamespace)         // ...     }

```swift
struct ResetFocusAction
```

---

## Layout

### `SpacerSizing` ⭐
*struct · macOS 26.0, iOS 26.0*

A type which defines how spacers should size themselves.  Use this type in coordination with the ``ToolbarSpacer`` type to define if the spacer should be a flexible size, or a fixed size using system-defined sizing rules.  For example, the following adds a fixed-size toolbar spacer between the share and more buttons in the toolbar:      ContentView()         .toolbar(id: "main-toolbar") {         …

```swift
struct SpacerSizing
```

### `ToolbarSpacer` ⭐
*struct · macOS 26.0, iOS 26.0*

A standard space item in toolbars.  A space item creates visual breaks in the toolbar between items. Spacers can have a standard fixed size or be flexible and push items apart.  Spacers can also be used in customizable toolbars:      ContentView()         .toolbar(id: "main-toolbar") {             ToolbarItem(id: "tag") {                TagButton()             }             ToolbarItem(id: "share"…

```swift
struct ToolbarSpacer
```

### `ToolbarSpacer.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of content representing the body of this toolbar content.

```swift
typealias Body = Never
```

### `AutomaticControlGroupStyle`
*struct · macOS 12.0, iOS 15.0*

The default control group style.  You can also use ``ControlGroupStyle/automatic`` to construct this style.

```swift
struct AutomaticControlGroupStyle
```

### `AutomaticControlGroupStyle.Body`
*typealias · macOS 12.0, iOS 15.0*

A view representing the body of a control group.

```swift
typealias Body = some View
```

### `AutomaticDisclosureGroupStyle`
*struct · macOS 13.0, iOS 16.0*

A disclosure group style that resolves its appearance automatically based on the current context.  Use ``DisclosureGroupStyle/automatic`` to construct this style.

```swift
@MainActor @preconcurrency struct AutomaticDisclosureGroupStyle
```

### `AutomaticDisclosureGroupStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the body of a disclosure group.

```swift
typealias Body = some View
```

### `CommandGroup`
*struct · macOS 11.0, iOS 14.0*

Groups of controls that you can add to existing command menus.  In macOS, SwiftUI realizes command groups as collections of menu items in a menu bar menu. In iOS, iPadOS, and tvOS, SwiftUI creates key commands for each of a group's commands that has a keyboard shortcut.

```swift
struct CommandGroup<Content> where Content : View
```

### `CommandGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `CommandGroupPlacement`
*struct · macOS 11.0, iOS 14.0*

The standard locations that you can place new command groups relative to.  The names of these placements aren't visible in the user interface, but the discussion for each placement lists the items that it includes.

```swift
struct CommandGroupPlacement
```

### `CompactMenuControlGroupStyle`
*struct · macOS 13.3, iOS 16.4*

A control group style that presents its content as a compact menu when the user presses the control, or as a submenu when nested within a larger menu.  Use ``ControlGroupStyle/compactMenu`` to construct this style.

```swift
struct CompactMenuControlGroupStyle
```

### `CompactMenuControlGroupStyle.Body`
*typealias · macOS 13.3, iOS 16.4*

A view representing the body of a control group.

```swift
typealias Body = some View
```

### `ControlGroup`
*struct · macOS 12.0, iOS 15.0*

A container view that displays semantically-related controls in a visually-appropriate manner for the context  You can provide an optional label to this view that describes its children. This view may be used in different ways depending on the surrounding context. For example, when you place the control group in a toolbar item, SwiftUI uses the label when the group is moved to the toolbar's overfl…

```swift
struct ControlGroup<Content> where Content : View
```

### `ControlGroup.Body`
*typealias · macOS 12.0, iOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ControlGroupStyle`
*protocol · macOS 12.0, iOS 15.0*

Defines the implementation of all control groups within a view hierarchy.  To configure the current `ControlGroupStyle` for a view hierarchy, use the ``View/controlGroupStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {      …

```swift
@MainActor @preconcurrency protocol ControlGroupStyle
```

### `ControlGroupStyle.Configuration`
*typealias · macOS 12.0, iOS 15.0*

The properties of a `ControlGroup` instance being created.

```swift
typealias Configuration = ControlGroupStyleConfiguration
```

### `ControlGroupStyleConfiguration`
*struct · macOS 12.0, iOS 15.0*

The properties of a control group.

```swift
struct ControlGroupStyleConfiguration
```

### `ControlGroupStyleConfiguration.Content`
*struct · macOS 12.0, iOS 15.0*

A type-erased content of a `ControlGroup`.

```swift
@MainActor @preconcurrency struct Content
```

### `ControlGroupStyleConfiguration.Content.Body`
*typealias · macOS 12.0, iOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `ControlGroupStyleConfiguration.Label`
*struct · macOS 13.0, iOS 16.0*

A type-erased label of a ``ControlGroup``.

```swift
@MainActor @preconcurrency struct Label
```

### `ControlGroupStyleConfiguration.Label.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `DefaultDocumentGroupLaunchActions`
*struct · macOS 15.0, iOS 18.0*

The default actions for the document group launch scene and the document launch view.  This `View` populates ``DocumentGroupLaunchScene`` and ``DocumentLaunchView`` with the default actions.

```swift
struct DefaultDocumentGroupLaunchActions
```

### `DefaultDocumentGroupLaunchActions.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultGroupBoxStyle`
*struct · macOS 11.0, iOS 14.0*

The default style for group box views.  You can also use ``GroupBoxStyle/automatic`` to construct this style.

```swift
struct DefaultGroupBoxStyle
```

### `DefaultGroupBoxStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a group box.

```swift
typealias Body = some View
```

### `DisclosureGroup`
*struct · macOS 11.0, iOS 14.0*

A view that shows or hides another content view, based on the state of a disclosure control.  A disclosure group view consists of a label to identify the contents, and a control to show and hide the contents. Showing the contents puts the disclosure group into the "expanded" state, and hiding them makes the disclosure group "collapsed".  In the following example, a disclosure group contains two to…

```swift
struct DisclosureGroup<Label, Content> where Label : View, Content : View
```

### `DisclosureGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DisclosureGroupStyle`
*protocol · macOS 13.0, iOS 16.0*

A type that specifies the appearance and interaction of disclosure groups within a view hierarchy.  To configure the disclosure group style for a view hierarchy, use the ``View/disclosureGroupStyle(_:)`` modifier.  To create a custom disclosure group style, declare a type that conforms to `DisclosureGroupStyle`. Implement the ``DisclosureGroupStyle/makeBody(configuration:)`` method to return a vie…

```swift
@MainActor @preconcurrency protocol DisclosureGroupStyle
```

### `DisclosureGroupStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

The properties of a disclosure group instance.

```swift
typealias Configuration = DisclosureGroupStyleConfiguration
```

### `DisclosureGroupStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a disclosure group instance.

```swift
struct DisclosureGroupStyleConfiguration
```

### `DisclosureGroupStyleConfiguration.Content`
*struct · macOS 13.0, iOS 16.0*

A type-erased content of a disclosure group.

```swift
@MainActor @preconcurrency struct Content
```

### `DisclosureGroupStyleConfiguration.Content.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `DisclosureGroupStyleConfiguration.Label`
*struct · macOS 13.0, iOS 16.0*

A type-erased label of a disclosure group.

```swift
@MainActor @preconcurrency struct Label
```

### `DisclosureGroupStyleConfiguration.Label.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `Divider`
*struct · macOS 10.15, iOS 13.0*

A visual element that can be used to separate other content.  When contained in a stack, the divider extends across the minor axis of the stack, or horizontally when not in a stack.

```swift
struct Divider
```

### `Divider.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `DocumentGroup`
*struct · macOS 11.0, iOS 14.0*

A scene that enables support for opening, creating, and saving documents.  Use a `DocumentGroup` scene to tell SwiftUI what kinds of documents your app can open when you declare your app using the ``App`` protocol.  Initialize a document group scene by passing in the document model and a view capable of displaying the document type. The document types you supply to `DocumentGroup` must conform to …

```swift
struct DocumentGroup<Document, Content> where Content : View
```

### `DocumentGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `Grid`
*struct · macOS 13.0, iOS 16.0*

A container view that arranges other views in a two dimensional layout.  Create a two dimensional layout by initializing a `Grid` with a collection of ``GridRow`` structures. The first view in each grid row appears in the grid's first column, the second view in the second column, and so on. The following example creates a grid with two rows and two columns:      Grid {         GridRow {           …

```swift
@frozen struct Grid<Content> where Content : View
```

### `Grid.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GridItem`
*struct · macOS 11.0, iOS 14.0*

A description of a row or a column in a lazy grid.  Use an array of `GridItem` instances to configure the layout of items in a lazy grid. Each grid item in the array specifies layout properties like size and spacing for the rows of a ``LazyHGrid`` or the columns of a ``LazyVGrid``. The following example defines four rows for a horizontal grid, each with different characteristics:      struct GridI…

```swift
struct GridItem
```

### `GridItem.Size`
*enum · macOS 11.0, iOS 14.0*

The size in the minor axis of one or more rows or columns in a grid layout.  Use a `Size` instance when you create a ``GridItem``. The value tells a ``LazyHGrid`` how to size its rows, or a ``LazyVGrid`` how to size its columns.

```swift
enum Size
```

### `GridLayout`
*struct · macOS 13.0, iOS 16.0*

A grid that you can use in conditional layouts.  This layout container behaves like a ``Grid``, but conforms to the ``Layout`` protocol so you can use it in the conditional layouts that you construct with ``AnyLayout``. If you don't need a conditional layout, use ``Grid`` instead.

```swift
@frozen struct GridLayout
```

### `GridLayout.AnimatableData`
*typealias · macOS 13.0, iOS 16.0*

The type defining the data to animate.

```swift
typealias AnimatableData = EmptyAnimatableData
```

### `GridLayout.Body`
*typealias · macOS 13.0, iOS 16.0*

```swift
typealias Body = Never
```

### `GridLayout.Cache`
*struct · macOS 13.0, iOS 16.0*

A stateful grid layout algorithm.

```swift
struct Cache
```

### `GridRow`
*struct · macOS 13.0, iOS 16.0*

A horizontal row in a two dimensional grid container.  Use one or more `GridRow` instances to define the rows of a ``Grid`` container. The child views inside the row define successive grid cells. You can add rows to the grid explicitly, or use the ``ForEach`` structure to generate multiple rows. Similarly, you can add cells to the row explicitly or you can use ``ForEach`` to generate multiple cell…

```swift
@frozen struct GridRow<Content> where Content : View
```

### `GridRow.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GroupBox`
*struct · macOS 10.15, iOS 14.0*

A stylized view, with an optional label, that visually collects a logical grouping of content.  Use a group box when you want to visually distinguish a portion of your user interface with an optional title for the boxed content.  The following example sets up a `GroupBox` with the label "End-User Agreement", and a long `agreementText` string in a ``SwiftUI/Text`` view wrapped by a ``SwiftUI/Scroll…

```swift
struct GroupBox<Label, Content> where Label : View, Content : View
```

### `GroupBox.Body`
*typealias · macOS 10.15, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `GroupBoxStyle`
*protocol · macOS 11.0, iOS 14.0*

A type that specifies the appearance and interaction of all group boxes within a view hierarchy.  To configure the current `GroupBoxStyle` for a view hierarchy, use the ``View/groupBoxStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Tra…

```swift
@MainActor @preconcurrency protocol GroupBoxStyle
```

### `GroupBoxStyle.Configuration`
*typealias · macOS 11.0, iOS 14.0*

The properties of a group box instance.

```swift
typealias Configuration = GroupBoxStyleConfiguration
```

### `GroupBoxStyleConfiguration`
*struct · macOS 11.0, iOS 14.0*

The properties of a group box instance.

```swift
struct GroupBoxStyleConfiguration
```

### `GroupBoxStyleConfiguration.Content`
*struct · macOS 11.0, iOS 14.0*

A type-erased content of a group box.

```swift
@MainActor @preconcurrency struct Content
```

### `GroupBoxStyleConfiguration.Content.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GroupBoxStyleConfiguration.Label`
*struct · macOS 11.0, iOS 14.0*

A type-erased label of a group box.

```swift
@MainActor @preconcurrency struct Label
```

### `GroupBoxStyleConfiguration.Label.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GroupedFormStyle`
*struct · macOS 13.0, iOS 16.0*

A form style with grouped rows.  Rows in this form style have leading aligned labels and trailing aligned controls within visually grouped sections.  Use the ``FormStyle/grouped`` static variable to create this style:      Form {        ...     }     .formStyle(.grouped)

```swift
struct GroupedFormStyle
```

### `GroupedFormStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the appearance and interaction of a form.

```swift
typealias Body = some View
```

### `LabeledControlGroupContent`
*struct · macOS 13.0, iOS 16.0*

A view that represents the body of a control group with a specified label.  You don't create this type directly. SwiftUI creates it when you build a ``ControlGroup``.

```swift
struct LabeledControlGroupContent<Content, Label> where Content : View, Label : View
```

### `LabeledControlGroupContent.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `LabeledToolbarItemGroupContent`
*struct · macOS 13.0, iOS 16.0*

A view that represents the view of a toolbar item group with a specified label.  You don't create this type directly. SwiftUI creates it when you build a ``ToolbarItemGroup``.

```swift
struct LabeledToolbarItemGroupContent<Content, Label> where Content : View, Label : View
```

### `LabeledToolbarItemGroupContent.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `LazyHGrid`
*struct · macOS 11.0, iOS 14.0*

A container view that arranges its child views in a grid that grows horizontally, creating items only as needed.  Use a lazy horizontal grid when you want to display a large, horizontally scrollable collection of views arranged in a two dimensional layout. The first view that you provide to the grid's `content` closure appears in the top row of the column that's on the grid's leading edge. Additio…

```swift
struct LazyHGrid<Content> where Content : View
```

### `LazyHGrid.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `LazyVGrid`
*struct · macOS 11.0, iOS 14.0*

A container view that arranges its child views in a grid that grows vertically, creating items only as needed.  Use a lazy vertical grid when you want to display a large, vertically scrollable collection of views arranged in a two dimensional layout. The first view that you provide to the grid's `content` closure appears in the top row of the column that's on the grid's leading edge. Additional vi…

```swift
struct LazyVGrid<Content> where Content : View
```

### `LazyVGrid.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `MenuControlGroupStyle`
*struct · macOS 13.3, iOS 16.4*

A control group style that presents its content as a menu when the user presses the control, or as a submenu when nested within a larger menu.  Use ``ControlGroupStyle/menu`` to construct this style.

```swift
struct MenuControlGroupStyle
```

### `MenuControlGroupStyle.Body`
*typealias · macOS 13.3, iOS 16.4*

A view representing the body of a control group.

```swift
typealias Body = some View
```

### `NSViewControllerRepresentable.LayoutOptions`
*typealias · macOS 13.0*

```swift
typealias LayoutOptions
```

### `NSViewRepresentable.LayoutOptions`
*typealias · macOS 13.0*

```swift
typealias LayoutOptions
```

### `OutlineGroup`
*struct · macOS 11.0, iOS 14.0*

A structure that computes views and disclosure groups on demand from an underlying collection of tree-structured, identified data.  Use an outline group when you need a view that can represent a hierarchy of data by using disclosure views. This allows the user to navigate the tree structure by using the disclosure views to expand and collapse branches.  In the following example, a tree structure o…

```swift
struct OutlineGroup<Data, ID, Parent, Leaf, Subgroup> where Data : RandomAccessCollection, ID : Hashable
```

### `OutlineGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `PaletteControlGroupStyle`
*struct · macOS 14.0, iOS 17.0*

A control group style that presents its content as a palette.  Use ``ControlGroupStyle/palette`` to construct this style.

```swift
struct PaletteControlGroupStyle
```

### `PaletteControlGroupStyle.Body`
*typealias · macOS 14.0, iOS 17.0*

A view representing the body of a control group.

```swift
typealias Body = some View
```

### `RadioGroupPickerStyle`
*struct · macOS 10.15*

A picker style that presents the options as a group of radio buttons.  You can also use ``PickerStyle/radioGroup`` to construct this style.

```swift
struct RadioGroupPickerStyle
```

### `ToolbarItemGroup`
*struct · macOS 11.0, iOS 14.0*

A model that represents a group of `ToolbarItem`s which can be placed in the toolbar or navigation bar.

```swift
struct ToolbarItemGroup<Content> where Content : View
```

### `ToolbarItemGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of content representing the body of this toolbar content.

```swift
typealias Body = Never
```

---

## Navigation & Structure

### `NSHostingSceneRepresentation` ⭐
*class · macOS 26.0*

An AppKit type that hosts and can present SwiftUI scenes  Use instances of this type with ``NSApplication.addSceneRepresentation(_:)`` to include SwiftUI scene functionality in an app which uses the AppKit app lifecycle.  For example, you can add a `Settings` scene to your app and present it when the corresponding menu item is selected:      import AppKit     import SwiftUI      @main     class Ap…

```swift
@MainActor class NSHostingSceneRepresentation<Content> where Content : Scene
```

### `SceneLaunchBehavior` ⭐
*struct · macOS 15.0*

The launch behavior for a scene.  Use the ``Scene/defaultLaunchBehavior(_:)`` modifier to apply a value of this type to a ``Scene`` you specify in your ``App``. The value you specify determines how the system will present the scene in the absense of any previously restored scenes on launch of your application.  For example, you may wish to present a welcome window on launch of your app when there …

```swift
struct SceneLaunchBehavior
```

### `TabBarMinimizeBehavior` ⭐
*struct · macOS 26.0, iOS 26.0*

```swift
struct TabBarMinimizeBehavior
```

### `TabSearchActivation` ⭐
*struct · macOS 26.0, iOS 26.0*

Configures the activation behavior of search in the search tab.  You can configure this for a particular ``TabView`` by using the ``View/tabViewSearchActivation(_:)`` modifier.

```swift
struct TabSearchActivation
```

### `TabViewBottomAccessoryPlacement` ⭐
*enum · macOS 26.0, iOS 26.0*

A placement of the bottom accessory in a tab view. You can use this to adjust the content of the accessory view based on the placement.  The following example shows playback controls when the view is inline, and an expanded slider player view when the view is expanded.      struct MusicPlaybackView: View {         @Environment(\.tabViewBottomAccessoryPlacement) var placement          var body: som…

```swift
enum TabViewBottomAccessoryPlacement
```

### `Window` ⭐
*struct · macOS 13.0*

A scene that presents its content in a single, unique window.  Use a `Window` scene to augment the main interface of your app with a window that gives people access to supplemental functionality. For example, you can create a secondary window in a mail reader app that enables people to view the status of their account connections:       @main      struct Mail: App {          var body: some Scene {…

```swift
struct Window<Content> where Content : View
```

### `Window.Body` ⭐
*typealias · macOS 13.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `AdaptableTabBarPlacement`
*struct · macOS 15.0, iOS 18.0*

A placement for tabs in a tab view using the adaptable sidebar style.

```swift
struct AdaptableTabBarPlacement
```

### `AlertScene`
*struct · macOS 15.0*

A scene that renders itself as a standalone alert dialog.  Alert scenes are not attached to any particular window, and present themselves in the center of the current display. The dialog must be dismissed before any further interaction with the app is permitted.      @main     struct MyApp: App {         @State var showLoginAlert = true         @State var loggedIn = false          var body: some S…

```swift
struct AlertScene<Actions, Message> where Actions : View, Message : View
```

### `AlertScene.Body`
*typealias · macOS 15.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `AnyTabContent`
*struct · macOS 15.0, iOS 18.0*

Type erased tab content.

```swift
struct AnyTabContent<SelectionValue> where SelectionValue : Hashable
```

### `AnyTabContent.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of content representing the body of this content type.

```swift
typealias Body = AnyTabContent<SelectionValue>
```

### `AnyTabContent.TabValue`
*typealias · macOS 15.0, iOS 18.0*

The type used to drive selection for the containing tab view.

```swift
typealias TabValue = SelectionValue
```

### `AutomaticNavigationSplitViewStyle`
*struct · macOS 13.0, iOS 16.0*

A navigation split style that resolves its appearance automatically based on the current context.  Use ``NavigationSplitViewStyle/automatic`` to construct this style.

```swift
@MainActor @preconcurrency struct AutomaticNavigationSplitViewStyle
```

### `AutomaticNavigationSplitViewStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the body of a navigation split view.

```swift
typealias Body = some View
```

### `AutomaticNavigationTransition`
*struct · macOS 15.0, iOS 18.0*

A style that automatically chooses the appropriate presentation transition for the current context.

```swift
struct AutomaticNavigationTransition
```

### `AutomaticTableStyle`
*struct · macOS 12.0, iOS 16.0*

The default table style in the current context.  You can also use ``TableStyle/automatic`` to construct this style.

```swift
struct AutomaticTableStyle
```

### `AutomaticTableStyle.Body`
*typealias · macOS 12.0, iOS 16.0*

A view that represents the body of a table.

```swift
typealias Body = some View
```

### `BalancedNavigationSplitViewStyle`
*struct · macOS 13.0, iOS 16.0*

A navigation split style that reduces the size of the detail content to make room when showing the leading column or columns.  Use ``NavigationSplitViewStyle/balanced`` to construct this style.

```swift
@MainActor @preconcurrency struct BalancedNavigationSplitViewStyle
```

### `BalancedNavigationSplitViewStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the body of a navigation split view.

```swift
typealias Body = some View
```

### `BorderedTableStyle`
*struct · macOS 12.0*

The table style that describes the behavior and appearance of a table with standard border.  You can also use ``TableStyle/bordered`` to construct this style.

```swift
struct BorderedTableStyle
```

### `BorderedTableStyle.Body`
*typealias · macOS 12.0*

A view that represents the body of a table.

```swift
typealias Body = some View
```

### `ColumnNavigationViewStyle`
*struct · macOS 12.0, iOS 15.0*

A navigation view style represented by a series of views in columns.  You can also use ``NavigationViewStyle/columns`` to construct this style.

```swift
struct ColumnNavigationViewStyle
```

### `ColumnsFormStyle`
*struct · macOS 13.0, iOS 16.0*

A non-scrolling form style with a trailing aligned column of labels next to a leading aligned column of values.  Use the ``FormStyle/columns`` static variable to create this style:      Form {        ...     }     .formStyle(.columns)

```swift
struct ColumnsFormStyle
```

### `ColumnsFormStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the appearance and interaction of a form.

```swift
typealias Body = some View
```

### `DefaultNavigationViewStyle`
*struct · macOS 10.15, iOS 13.0*

The default navigation view style.  You can also use ``NavigationViewStyle/automatic`` to construct this style.

```swift
struct DefaultNavigationViewStyle
```

### `DefaultTabLabel`
*struct · macOS 15.0, iOS 18.0*

The default label to use for a tab or tab section.  You don't use this type directly. Instead, the system creates it automatically when you construct a `Tab` or `TabSection`.

```swift
struct DefaultTabLabel
```

### `DefaultTabLabel.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultTabViewStyle`
*struct · macOS 11.0, iOS 14.0*

The default tab view style.  Use ``TabViewStyle/automatic`` to construct this style.

```swift
struct DefaultTabViewStyle
```

### `DefaultWindowStyle`
*struct · macOS 11.0*

The default window style.  You can also use ``WindowStyle/automatic`` to construct this style.

```swift
struct DefaultWindowStyle
```

### `DefaultWindowToolbarStyle`
*struct · macOS 11.0*

The default window toolbar style.  You can also use ``WindowToolbarStyle/automatic`` to construct this style.

```swift
struct DefaultWindowToolbarStyle
```

### `DefaultWindowVisibilityToggleLabel`
*struct · macOS 15.0*

The default label of a window visibility toggle.  This is created for you automatically when creating a `WindowVisibilityToggle`, and can not be independently constructed.

```swift
struct DefaultWindowVisibilityToggleLabel
```

### `DefaultWindowVisibilityToggleLabel.Body`
*typealias · macOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DisclosureTableRow`
*struct · macOS 14.0, iOS 17.0*

A kind of table row that shows or hides additional rows based on the state of a disclosure control.  A disclosure group row consists of a label row that is always visible, and some content rows that are conditionally visible depending on the state. Toggling the control will flip the state between "expanded" and "collapsed".  In the following example, a disclosure group has `allDevices` as the labe…

```swift
struct DisclosureTableRow<Label, Content> where Label : TableRowContent, Content : TableRowContent, Label.TableRowValue == Content.TableRowValue
```

### `DisclosureTableRow.TableRowBody`
*typealias · macOS 14.0, iOS 17.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = some TableRowContent
```

### `DisclosureTableRow.TableRowValue`
*typealias · macOS 14.0, iOS 17.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Label.TableRowValue
```

### `DismissWindowAction`
*struct · macOS 14.0, iOS 17.0*

An action that dismisses a window associated to a particular scene.  Use the ``EnvironmentValues/dismissWindow`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to dismiss a window. You call the instance directly because it defines a ``DismissWindowAction/callAsFunction(id:)`` method that Swift calls when you call the instance.  For examp…

```swift
@MainActor @preconcurrency struct DismissWindowAction
```

### `DoubleColumnNavigationViewStyle`
*struct · macOS 10.15, iOS 13.0*

A navigation view style represented by a primary view stack that navigates to a detail view.

```swift
struct DoubleColumnNavigationViewStyle
```

### `DynamicTableRowContent`
*protocol · macOS 12.0, iOS 16.0*

A type of table row content that generates table rows from an underlying collection of data.  This table row content type provides drag-and-drop support for tables. Use the ``DynamicTableRowContent/onInsert(of:perform:)`` modifier to add an action to call when the table inserts new contents into its underlying collection.

```swift
protocol DynamicTableRowContent : TableRowContent
```

### `EmptyTableRowContent`
*struct · macOS 13.0, iOS 16.0*

A table row content that doesn't produce any rows.  You will rarely, if ever, need to create an `EmptyTableRowContent` directly. Instead, `EmptyTableRowContent` represents the absence of a row.

```swift
struct EmptyTableRowContent<Value> where Value : Identifiable
```

### `EmptyTableRowContent.TableRowBody`
*typealias · macOS 13.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = Never
```

### `EmptyTableRowContent.TableRowValue`
*typealias · macOS 13.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Value
```

### `ExpandedWindowToolbarStyle`
*struct · macOS 11.0*

A window toolbar style which displays its title bar area above the toolbar.  You can also use ``WindowToolbarStyle/expanded`` to construct this style.

```swift
struct ExpandedWindowToolbarStyle
```

### `GroupedTabViewStyle`
*struct · macOS 15.0*

A tab view style that displays a tab bar that groups its tabs together.  Use ``TabViewStyle/grouped`` to construct this style.  To apply this style to a tab view, or to a view that contains tab views, use the ``View/tabViewStyle(_:)`` modifier.

```swift
struct GroupedTabViewStyle
```

### `HSplitView`
*struct · macOS 10.15*

A layout container that arranges its children in a horizontal line and allows the user to resize them using dividers placed between them.

```swift
struct HSplitView<Content> where Content : View
```

### `HSplitView.Body`
*typealias · macOS 10.15*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `HiddenTitleBarWindowStyle`
*struct · macOS 11.0*

A window style which hides both the window's title and the backing of the titlebar area, allowing more of the window's content to show.  You can also use ``WindowStyle/hiddenTitleBar`` to construct this style.

```swift
struct HiddenTitleBarWindowStyle
```

### `InsetTableStyle`
*struct · macOS 12.0, iOS 16.0*

The table style that describes the behavior and appearance of a table with its content and selection inset from the table edges.  You can also use ``TableStyle/inset`` to construct this style.

```swift
struct InsetTableStyle
```

### `InsetTableStyle.Body`
*typealias · macOS 12.0, iOS 16.0*

A view that represents the body of a table.

```swift
typealias Body = some View
```

### `ItemProviderTableRowModifier`
*struct · macOS 12.0, iOS 16.0*

A table row modifier that associates an item provider with some base row content.

```swift
@MainActor @preconcurrency struct ItemProviderTableRowModifier
```

### `ItemProviderTableRowModifier.Body`
*typealias · macOS 12.0, iOS 16.0*

```swift
typealias Body = some _TableRowContentModifier
```

### `NSHostingSceneBridgingOptions`
*struct · macOS 14.0*

Options for how hosting views and controllers manage aspects of the associated window.

```swift
struct NSHostingSceneBridgingOptions
```

### `NSHostingSceneBridgingOptions.ArrayLiteralElement`
*typealias · macOS 14.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = NSHostingSceneBridgingOptions
```

### `NSHostingSceneBridgingOptions.Element`
*typealias · macOS 14.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = NSHostingSceneBridgingOptions
```

### `NSHostingSceneBridgingOptions.RawValue`
*typealias · macOS 14.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `NavigationControlGroupStyle`
*struct · macOS 12.0, iOS 15.0*

The navigation control group style.  You can also use ``ControlGroupStyle/navigation`` to construct this style.

```swift
struct NavigationControlGroupStyle
```

### `NavigationControlGroupStyle.Body`
*typealias · macOS 12.0, iOS 15.0*

A view representing the body of a control group.

```swift
typealias Body = some View
```

### `NavigationLink`
*struct · macOS 10.15, iOS 13.0*

A view that controls a navigation presentation.  People click or tap a navigation link to present a view inside a ``NavigationStack`` or ``NavigationSplitView``. You control the visual appearance of the link by providing view content in the link's `label` closure. For example, you can use a ``Label`` to display a link:      NavigationLink {         FolderDetail(id: workFolder.id)     } label: {   …

```swift
struct NavigationLink<Label, Destination> where Label : View, Destination : View
```

### `NavigationLink.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `NavigationPath`
*struct · macOS 13.0, iOS 16.0*

A type-erased list of data representing the content of a navigation stack.  You can manage the state of a ``NavigationStack`` by initializing the stack with a binding to a collection of data. The stack stores data items in the collection for each view on the stack. You also can read and write the collection to observe and alter the stack's state.  When a stack displays views that rely on only one …

```swift
struct NavigationPath
```

### `NavigationPath.CodableRepresentation`
*struct · macOS 13.0, iOS 16.0*

A serializable representation of a navigation path.  When a navigation path contains elements the conform to the <doc://com.apple.documentation/documentation/Swift/Codable> protocol, you can use the path's `CodableRepresentation` to convert the path to an external representation and to convert an external representation back into a navigation path.

```swift
struct CodableRepresentation
```

### `NavigationSplitView`
*struct · macOS 13.0, iOS 16.0*

A view that presents views in two or three columns, where selections in leading columns control presentations in subsequent columns.  You create a navigation split view with two or three columns, and typically use it as the root view in a ``Scene``. People choose one or more items in a leading column to display details about those items in subsequent columns.  To create a two-column navigation spl…

```swift
struct NavigationSplitView<Sidebar, Content, Detail> where Sidebar : View, Content : View, Detail : View
```

### `NavigationSplitView.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `NavigationSplitViewColumn`
*struct · macOS 14.0, iOS 17.0*

A view that represents a column in a navigation split view.  A ``NavigationSplitView`` collapses into a single stack in some contexts, like on iPhone or Apple Watch. Use this type with the `preferredCompactColumn` parameter to control which column of the navigation split view appears on top of the collapsed stack.

```swift
struct NavigationSplitViewColumn
```

### `NavigationSplitViewStyle`
*protocol · macOS 13.0, iOS 16.0*

A type that specifies the appearance and interaction of navigation split views within a view hierarchy.  To configure the navigation split view style for a view hierarchy, use the ``View/navigationSplitViewStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      st…

```swift
@MainActor @preconcurrency protocol NavigationSplitViewStyle
```

### `NavigationSplitViewStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

The properties of a navigation split view instance.

```swift
typealias Configuration = NavigationSplitViewStyleConfiguration
```

### `NavigationSplitViewStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a navigation split view instance.

```swift
struct NavigationSplitViewStyleConfiguration
```

### `NavigationSplitViewVisibility`
*struct · macOS 13.0, iOS 16.0*

The visibility of the leading columns in a navigation split view.  Use a value of this type to control the visibility of the columns of a ``NavigationSplitView``. Create a ``State`` property with a value of this type, and pass a ``Binding`` to that state to the ``NavigationSplitView/init(columnVisibility:sidebar:detail:)`` or ``NavigationSplitView/init(columnVisibility:sidebar:content:detail:)`` i…

```swift
struct NavigationSplitViewVisibility
```

### `NavigationStack`
*struct · macOS 13.0, iOS 16.0*

A view that displays a root view and enables you to present additional views over the root view.  Use a navigation stack to present a stack of views over a root view. People can add views to the top of the stack by clicking or tapping a ``NavigationLink``, and remove views using built-in, platform-appropriate controls, like a Back button or a swipe gesture. The stack always displays the most recen…

```swift
@MainActor @preconcurrency struct NavigationStack<Data, Root> where Root : View
```

### `NavigationStack.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `NavigationTransition`
*protocol · macOS 15.0, iOS 18.0*

A type that defines the transition to use when navigating to a view.

```swift
protocol NavigationTransition
```

### `NavigationView`
*struct · macOS 10.15, iOS 13.0*

A view for presenting a stack of views that represents a visible path in a navigation hierarchy.  Use a `NavigationView` to create a navigation-based app in which the user can traverse a collection of views. Users navigate to a destination view by selecting a ``NavigationLink`` that you provide. On iPadOS and macOS, the destination content appears in the next column. Other platforms push a new vie…

```swift
struct NavigationView<Content> where Content : View
```

### `NavigationView.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `NavigationViewStyle`
*protocol · macOS 10.15, iOS 13.0*

A specification for the appearance and interaction of a `NavigationView`.

```swift
protocol NavigationViewStyle
```

### `OnInsertTableRowModifier`
*struct · macOS 12.0, iOS 16.0*

A table row modifier that adds the ability to insert data in some base row content.

```swift
@MainActor @preconcurrency struct OnInsertTableRowModifier
```

### `OnInsertTableRowModifier.Body`
*typealias · macOS 12.0, iOS 16.0*

```swift
typealias Body = some _TableRowContentModifier
```

### `OpenWindowAction`
*struct · macOS 13.0, iOS 16.0*

An action that presents a window.  Use the ``EnvironmentValues/openWindow`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to open a window. You call the instance directly because it defines a ``OpenWindowAction/callAsFunction(id:)`` method that Swift calls when you call the instance.  For example, you can define a button that opens a ne…

```swift
@MainActor @preconcurrency struct OpenWindowAction
```

### `OpenWindowAction.SharingBehavior`
*struct · macOS 15.0, iOS 16.0*

```swift
struct SharingBehavior
```

### `OutlineGroup.TableRowBody`
*typealias · macOS 14.0, iOS 17.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = some TableRowContent
```

### `OutlineGroup.TableRowValue`
*typealias · macOS 14.0, iOS 17.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Leaf.TableRowValue
```

### `PlainWindowStyle`
*struct · macOS 15.0*

The plain window style.  You can also use ``WindowStyle/plain`` to construct this style.

```swift
struct PlainWindowStyle
```

### `PresentedWindowContent`
*struct · macOS 13.0, iOS 16.0*

A view that represents the content of a presented window.  You don't create this type directly. ``WindowGroup`` creates values for you.

```swift
struct PresentedWindowContent<Data, Content> where Data : Decodable, Data : Encodable, Data : Hashable, Content : View
```

### `PresentedWindowContent.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `ProminentDetailNavigationSplitViewStyle`
*struct · macOS 13.0, iOS 16.0*

A navigation split style that attempts to maintain the size of the detail content when hiding or showing the leading columns.  Use ``NavigationSplitViewStyle/prominentDetail`` to construct this style.

```swift
@MainActor @preconcurrency struct ProminentDetailNavigationSplitViewStyle
```

### `ProminentDetailNavigationSplitViewStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the body of a navigation split view.

```swift
typealias Body = some View
```

### `Scene`
*protocol · macOS 11.0, iOS 14.0*

A part of an app's user interface with a life cycle managed by the system.  You create an ``SwiftUI/App`` by combining one or more instances that conform to the `Scene` protocol in the app's ``SwiftUI/App/body-swift.property``. You can use the built-in scenes that SwiftUI provides, like ``SwiftUI/WindowGroup``, along with custom scenes that you compose from other scenes. To create a custom scene, …

```swift
@MainActor @preconcurrency protocol Scene
```

### `SceneBuilder`
*struct · macOS 11.0, iOS 14.0*

A result builder for composing a collection of scenes into a single composite scene.

```swift
@resultBuilder struct SceneBuilder
```

### `ScenePadding`
*struct · macOS 13.0, iOS 16.0*

The padding used to space a view from its containing scene.  Add scene padding to a view using the ``View/scenePadding(_:edges:)`` modifier.

```swift
struct ScenePadding
```

### `ScenePhase`
*enum · macOS 11.0, iOS 14.0*

An indication of a scene's operational state.  The system moves your app's ``Scene`` instances through phases that reflect a scene's operational state. You can trigger actions when the phase changes. Read the current phase by observing the ``EnvironmentValues/scenePhase`` value in the ``Environment``:      @Environment(\.scenePhase) private var scenePhase  How you interpret the value depends on wh…

```swift
enum ScenePhase
```

### `SceneRestorationBehavior`
*struct · macOS 15.0, iOS 18.0*

The restoration behavior for a scene.  Use the ``Scene/restorationBehavior(_:)`` scene modifier to apply a value of this type to a ``Scene`` you define in your ``App`` declaration. The value you specify determines how the system will restore windows from a previous run of your application.  For example, you may have a scene that you do not wish to be restored on launch:      @main     struct MyApp…

```swift
struct SceneRestorationBehavior
```

### `SceneStorage`
*struct · macOS 11.0, iOS 14.0*

A property wrapper type that reads and writes to persisted, per-scene storage.  You use `SceneStorage` when you need automatic state restoration of the value.  `SceneStorage` works very similar to `State`, except its initial value is restored by the system if it was previously saved, and the value is shared with other `SceneStorage` variables in the same scene.  The system manages the saving and r…

```swift
@frozen @propertyWrapper struct SceneStorage<Value>
```

### `Section.TableRowBody`
*typealias · macOS 13.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = Never
```

### `Section.TableRowValue`
*typealias · macOS 13.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Content.TableRowValue
```

### `SidebarAdaptableTabViewStyle`
*struct · macOS 15.0, iOS 18.0*

A tab bar style that adapts to each platform.  Tab views using the sidebar adaptable style have an appearance that varies depending on the platform: * iPadOS displays a top tab bar that can adapt into a sidebar. * iOS displays a bottom tab bar. * macOS and tvOS always show a sidebar. * visionOS shows an ornament and also shows a sidebar for secondary tabs within a ``TabSection``.  Use ``TabViewSty…

```swift
struct SidebarAdaptableTabViewStyle
```

### `Tab`
*struct · macOS 15.0, iOS 18.0*

The content for a tab and the tab's associated tab item in a tab view.

```swift
struct Tab<Value, Content, Label>
```

### `Tab.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of content representing the body of this content type.

```swift
typealias Body = Tab<Value, Content, Label>
```

### `Tab.TabValue`
*typealias · macOS 15.0, iOS 18.0*

The type used to drive selection for the containing tab view.

```swift
typealias TabValue = Value
```

### `TabBarOnlyTabViewStyle`
*struct · macOS 15.0, iOS 18.0*

A tab view style that displays a tab bar when possible.  Use ``TabViewStyle/tabBarOnly`` to construct this style.  To apply this style to a tab view, or to a view that contains tab views, use the ``View/tabViewStyle(_:)`` modifier.

```swift
struct TabBarOnlyTabViewStyle
```

### `TabBarPlacement`
*struct · macOS 15.0, iOS 18.0*

A placement for tabs in a tab view.

```swift
struct TabBarPlacement
```

### `TabContent`
*protocol · macOS 15.0, iOS 18.0*

A type that provides content for programmatically selectable tabs in a tab view.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but…

```swift
@MainActor @preconcurrency protocol TabContent<TabValue>
```

### `TabContentBuilder`
*struct · macOS 15.0, iOS 18.0*

A result builder that constructs tabs for a tab view that supports programmatic selection. This builder requires that all tabs in the tab view have the same selection type.

```swift
@resultBuilder struct TabContentBuilder<TabValue> where TabValue : Hashable
```

### `TabContentBuilder.Content`
*struct · macOS 15.0, iOS 18.0*

A view representation of the content of a builder-based tab view with selection.

```swift
struct Content<C> where C : TabContent
```

### `TabContentBuilder.Content.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `TabCustomizationBehavior`
*struct · macOS 15.0, iOS 18.0*

The customization behavior of customizable tab view content.  Use this type in conjunction with the ``TabContent/customizationBehavior(_:for:)`` modifier.

```swift
struct TabCustomizationBehavior
```

### `TabPlacement`
*struct · macOS 15.0, iOS 18.0*

A place that a tab can appear.  Not all `TabView` styles support all placements.

```swift
struct TabPlacement
```

### `TabRole`
*struct · macOS 15.0, iOS 18.0*

A value that defines the purpose of the tab.

```swift
struct TabRole
```

### `TabSection`
*struct · macOS 15.0, iOS 18.0*

A container that you can use to add hierarchy within a tab view.  Use ``TabSection`` to organize tab content into separate sections. Each section has custom tab content that you provide on a per-instance basis. You can also provide a header for each section.

```swift
struct TabSection<Header, Content, Footer, SelectionValue>
```

### `TabSection.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of content representing the body of this content type.

```swift
typealias Body = TabSection<Header, Content, Footer, SelectionValue>
```

### `TabSection.TabValue`
*typealias · macOS 15.0, iOS 18.0*

The type used to drive selection for the containing tab view.

```swift
typealias TabValue = Content.TabValue
```

### `TabView`
*struct · macOS 10.15, iOS 13.0*

A view that switches between multiple child views using interactive user interface elements.  To create a user interface with tabs, place ``Tab``s  in a `TabView`. On iOS, you can also use one of the badge modifiers, like ``TabContent/badge(_:)``, to assign a badge to each of the tabs.  The following example creates a tab view with three tabs, each presenting a custom child view. The first tab has…

```swift
struct TabView<SelectionValue, Content> where SelectionValue : Hashable, Content : View
```

### `TabView.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `TabViewCustomization`
*struct · macOS 15.0, iOS 18.0*

The customizations a person makes to an adaptable sidebar tab view.  By default, if a person hasn't made customizations, tabs appear according to the default builder visibilities and sections appear in the order you declare in the tab view's tab builder.  You can change the default visibility by using the ``TabContent/defaultVisibility(_:for:)`` with a ``AdaptableTabBarPlacement/sidebar`` placemen…

```swift
struct TabViewCustomization
```

### `TabViewCustomization.SectionCustomization`
*struct · macOS 15.4, iOS 18.4*

The customizations a user has made to a ``TabSection``.

```swift
struct SectionCustomization
```

### `TabViewCustomization.TabCustomization`
*struct · macOS 15.4, iOS 18.4*

The customizations a user has made to a ``Tab``.

```swift
struct TabCustomization
```

### `TabViewStyle`
*protocol · macOS 11.0, iOS 14.0*

A specification for the appearance and interaction of a tab view.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but it's not requi…

```swift
@MainActor @preconcurrency protocol TabViewStyle
```

### `Table`
*struct · macOS 12.0, iOS 16.0*

A container that presents rows of data arranged in one or more columns, optionally providing the ability to select one or more members.  You commonly create tables from collections of data. The following example shows how to create a simple, three-column table from an array of `Person` instances that conform to the <doc://com.apple.documentation/documentation/Swift/Identifiable> protocol:      str…

```swift
struct Table<Value, Rows, Columns> where Value == Rows.TableRowValue, Rows : TableRowContent, Columns : TableColumnContent, Rows.TableRowValue == Columns.TableRowValue
```

### `Table.Body`
*typealias · macOS 12.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `TableColumn`
*struct · macOS 12.0, iOS 16.0*

A column that displays a view for each row in a table.  You create a column with a label, content view, and optional key path. The table calls the content view builder with the value for each row in the table. The column uses a key path to map to a property of each row value, which sortable tables use to reflect the current sort order.  The following example creates a sortable column for a table w…

```swift
struct TableColumn<RowValue, Sort, Content, Label> where RowValue : Identifiable, Sort : SortComparator, Content : View, Label : View
```

### `TableColumn.TableColumnBody`
*typealias · macOS 12.0, iOS 16.0*

The type of content representing the body of this table column content.

```swift
typealias TableColumnBody = Never
```

### `TableColumn.TableColumnSortComparator`
*typealias · macOS 12.0, iOS 16.0*

The type of sort comparator associated with this table column content.

```swift
typealias TableColumnSortComparator = Sort
```

### `TableColumn.TableRowValue`
*typealias · macOS 12.0, iOS 16.0*

The type of value of rows presented by this column content.

```swift
typealias TableRowValue = RowValue
```

### `TableColumnAlignment`
*struct · macOS 14.0, iOS 17.0*

Describes the alignment of the content of a table column.  The alignment of a column applies to both its header label as well as the default alignment of its content view for each row.

```swift
struct TableColumnAlignment
```

### `TableColumnBuilder`
*struct · macOS 12.0, iOS 16.0*

A result builder that creates table column content from closures.  The `buildBlock` methods in this type create ``TableColumnContent`` instances based on the number and types of sources provided as parameters.  Don't use this type directly; instead, SwiftUI annotates the `columns` parameter of the various ``Table`` initializers with the `@TableColumnBuilder` annotation, implicitly calling this bui…

```swift
@resultBuilder struct TableColumnBuilder<RowValue, Sort> where RowValue : Identifiable, Sort : SortComparator
```

### `TableColumnContent`
*protocol · macOS 12.0, iOS 16.0*

A type used to represent columns within a table.  This type provides the body content of the column, as well as the types of the column's row values and the comparator used to sort rows.  You can factor column content out into separate types or properties, or by creating a custom type conforming to `TableColumnContent`.      var body: some View {         Table(people, selection: $selectedPeople, s…

```swift
@MainActor @preconcurrency protocol TableColumnContent<TableRowValue, TableColumnSortComparator>
```

### `TableColumnCustomization`
*struct · macOS 14.0, iOS 17.0*

A representation of the state of the columns in a table.  `TableColumnCustomization` can be created and provided to a table to enable column reordering and column visibility. The state can be queried and updated programmatically, as well as bound to persistent app or scene storage.      struct BugReportTable: View {         @ObservedObject var dataModel: DataModel         @Binding var selectedBugR…

```swift
struct TableColumnCustomization<RowValue> where RowValue : Identifiable
```

### `TableColumnCustomizationBehavior`
*struct · macOS 14.0, iOS 17.0*

A set of customization behaviors of a column that a table can offer to a user.  This is used as a value provided to ``TableColumnContent/disabledCustomizationBehavior(_:)``.  Setting any of these values as the `disabledCustomizationBehavior(_:)` doesn't have any effect on iOS.

```swift
struct TableColumnCustomizationBehavior
```

### `TableColumnCustomizationBehavior.ArrayLiteralElement`
*typealias · macOS 14.0, iOS 17.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = TableColumnCustomizationBehavior.Element
```

### `TableColumnCustomizationBehavior.Element`
*typealias · macOS 14.0, iOS 17.0*

A type for which the conforming type provides a containment test.

```swift
typealias Element = TableColumnCustomizationBehavior
```

### `TableColumnForEach`
*struct · macOS 14.4, iOS 17.4*

A structure that computes columns on demand from an underlying collection of identified data.  Use `TableColumnForEach` to create columns based on a <doc://com.apple.documentation/documentation/Swift/RandomAccessCollection> of some data type. Either the collection's elements must conform to <doc://com.apple.documentation/documentation/Swift/Identifiable> or you need to provide an `id` parameter to…

```swift
struct TableColumnForEach<Data, ID, RowValue, Sort, Content> where Data : RandomAccessCollection, ID : Hashable, RowValue == Content.TableRowValue, Sort == Content.TableColumnSortComparator, Content : TableColumnContent
```

### `TableColumnForEach.TableColumnBody`
*typealias · macOS 14.4, iOS 17.4*

The type of content representing the body of this table column content.

```swift
typealias TableColumnBody = Never
```

### `TableColumnForEach.TableColumnSortComparator`
*typealias · macOS 14.4, iOS 17.4*

The type of sort comparator associated with this table column content.

```swift
typealias TableColumnSortComparator = Sort
```

### `TableColumnForEach.TableRowValue`
*typealias · macOS 14.4, iOS 17.4*

The type of value of rows presented by this column content.

```swift
typealias TableRowValue = RowValue
```

### `TableForEachContent`
*struct · macOS 12.0, iOS 16.0*

A type of table row content that creates table rows created by iterating over a collection.  You don't use this type directly. The various `Table.init(_:,...)` initializers create this type as the table's `Rows` generic type.  To explicitly create dynamic collection-based rows, use ``ForEach`` instead.

```swift
struct TableForEachContent<Data> where Data : RandomAccessCollection, Data.Element : Identifiable
```

### `TableForEachContent.TableRowBody`
*typealias · macOS 12.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = some TableRowContent
```

### `TableForEachContent.TableRowValue`
*typealias · macOS 12.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Data.Element
```

### `TableHeaderRowContent`
*struct · macOS 13.0, iOS 16.0*

A table row that displays a single view instead of columned content.  You do not create this type directly. The framework creates it on your behalf.

```swift
struct TableHeaderRowContent<Value, Content> where Value : Identifiable, Content : View
```

### `TableHeaderRowContent.TableRowBody`
*typealias · macOS 13.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = some TableRowContent
```

### `TableHeaderRowContent.TableRowValue`
*typealias · macOS 13.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Value
```

### `TableOutlineGroupContent`
*struct · macOS 14.0, iOS 17.0*

An opaque table row type created by a table's hierarchical initializers.  This row content is created by `Table.init(_:,children:,...)` initializers as the table's `Rows` generic type.  To explicitly create hierarchical rows, use ``OutlineGroup`` instead.

```swift
struct TableOutlineGroupContent<Data> where Data : RandomAccessCollection, Data.Element : Identifiable
```

### `TableOutlineGroupContent.TableRowBody`
*typealias · macOS 14.0, iOS 17.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = some TableRowContent
```

### `TableOutlineGroupContent.TableRowValue`
*typealias · macOS 14.0, iOS 17.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Data.Element
```

### `TableRow`
*struct · macOS 12.0, iOS 16.0*

A row that represents a data value in a table.  Create instances of ``TableRow`` in the closure you provide to the `rows` parameter in ``Table`` initializers that take columns and rows. The table provides the value of a row to each column of a table, which produces the cells for each row in the column.

```swift
struct TableRow<Value> where Value : Identifiable
```

### `TableRow.TableRowBody`
*typealias · macOS 12.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = Never
```

### `TableRow.TableRowValue`
*typealias · macOS 12.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Value
```

### `TableRowBuilder`
*struct · macOS 12.0, iOS 16.0*

A result builder that creates table row content from closures.  The `buildBlock` methods in this type create ``TableRowContent`` instances based on the number and types of sources provided as parameters.  Don't use this type directly; instead, SwiftUI annotates the `rows` parameter of the various ``Table`` initializers with the `@TableRowBuilder` annotation, implicitly calling this builder for you…

```swift
@resultBuilder struct TableRowBuilder<Value> where Value : Identifiable
```

### `TableRowContent`
*protocol · macOS 12.0, iOS 16.0*

A type used to represent table rows.  Like with the ``View`` protocol, you can create custom table row content by declaring a type that conforms to the `TableRowContent` protocol and implementing the required ``TableRowContent/tableRowBody-swift.property`` property.      struct GroupOfPeopleRows: TableRowContent {         @Binding var people: [Person]          var tableRowBody: some TableRowConten…

```swift
@MainActor @preconcurrency protocol TableRowContent<TableRowValue>
```

### `TableStyle`
*protocol · macOS 12.0, iOS 16.0*

A type that applies a custom appearance to all tables within a view.  To configure the current table style for a view hierarchy, use the ``View/tableStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurren…

```swift
@MainActor @preconcurrency protocol TableStyle
```

### `TableStyle.Configuration`
*typealias · macOS 12.0, iOS 16.0*

The properties of a table.

```swift
typealias Configuration = TableStyleConfiguration
```

### `TableStyleConfiguration`
*struct · macOS 12.0, iOS 16.0*

The properties of a table.

```swift
struct TableStyleConfiguration
```

### `TitleBarWindowStyle`
*struct · macOS 11.0*

A window style which displays the title bar section of the window.  You can also use ``WindowStyle/titleBar`` to construct this style.

```swift
struct TitleBarWindowStyle
```

### `TupleTableColumnContent`
*struct · macOS 12.0, iOS 16.0*

A type of table column content that creates table columns created from a Swift tuple of table columns.  Don't use this type directly; instead, SwiftUI uses this type as the return value from the various `buildBlock` methods in ``TableColumnBuilder``. The size of the tuple corresponds to how many columns you create in the `columns` closure you provide to the ``Table`` initializer.

```swift
@frozen struct TupleTableColumnContent<RowValue, Sort, T> where RowValue : Identifiable, Sort : SortComparator
```

### `TupleTableColumnContent.TableColumnBody`
*typealias · macOS 12.0, iOS 16.0*

The type of content representing the body of this table column content.

```swift
typealias TableColumnBody = Never
```

### `TupleTableColumnContent.TableColumnSortComparator`
*typealias · macOS 12.0, iOS 16.0*

The type of sort comparator associated with this table column content.

```swift
typealias TableColumnSortComparator = Sort
```

### `TupleTableColumnContent.TableRowValue`
*typealias · macOS 12.0, iOS 16.0*

The type of value of rows presented by this column content.

```swift
typealias TableRowValue = RowValue
```

### `TupleTableRowContent`
*struct · macOS 12.0, iOS 16.0*

A type of table column content that creates table rows created from a Swift tuple of table rows.  Don't use this type directly; instead, SwiftUI uses this type as the return value from the various `buildBlock` methods in ``TableRowBuilder``. The size of the tuple corresponds to how many columns you create in the `rows` closure you provide to the ``Table`` initializer.

```swift
@frozen struct TupleTableRowContent<Value, T> where Value : Identifiable
```

### `TupleTableRowContent.TableRowBody`
*typealias · macOS 12.0, iOS 16.0*

The type of content representing the body of this table row content.

```swift
typealias TableRowBody = Never
```

### `TupleTableRowContent.TableRowValue`
*typealias · macOS 12.0, iOS 16.0*

The type of value represented by this table row content.

```swift
typealias TableRowValue = Value
```

### `UnifiedCompactWindowToolbarStyle`
*struct · macOS 11.0*

A window toolbar style similar to ``WindowToolbarStyle/unified``, but with a more compact vertical sizing.  You can also use ``WindowToolbarStyle/unifiedCompact`` or ``WindowToolbarStyle/unifiedCompact(showsTitle:)`` to construct this style.

```swift
struct UnifiedCompactWindowToolbarStyle
```

### `UnifiedWindowToolbarStyle`
*struct · macOS 11.0*

A window toolbar style which displays its toolbar and title bar inline.  You can also use ``WindowToolbarStyle/unified`` or ``WindowToolbarStyle/unified(showsTitle:)`` to construct this style.

```swift
struct UnifiedWindowToolbarStyle
```

### `UtilityWindow`
*struct · macOS 15.0*

A specialized window scene that provides secondary utility to the content of the main scenes of an application.  Utility windows are typically used to display controls, settings, or information associated the main content of an application, sometimes referred to as tool palettes or inspector windows. Because of this role, they have specialized behavior compared to all other windows: - They receive…

```swift
struct UtilityWindow<Content> where Content : View
```

### `UtilityWindow.Body`
*typealias · macOS 15.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `VSplitView`
*struct · macOS 10.15*

A layout container that arranges its children in a vertical line and allows the user to resize them using dividers placed between them.

```swift
struct VSplitView<Content> where Content : View
```

### `VSplitView.Body`
*typealias · macOS 10.15*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `WindowBackgroundShapeStyle`
*struct · macOS 14.0, iOS 17.0*

A style appropriate for elements that should match the background of their containing window.

```swift
struct WindowBackgroundShapeStyle
```

### `WindowBackgroundShapeStyle.Resolved`
*typealias · macOS 14.0, iOS 17.0*

The type of shape style this will resolve to.  When you create a custom shape style, Swift infers this type from your implementation of the required `resolve` function.

```swift
typealias Resolved = Never
```

### `WindowDragGesture`
*struct · macOS 15.0*

A gesture that recognizes the motion of and handles dragging a window.  To recognize a window drag gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:isEnabled:)`` modifier. Consider also letting the gesture [handle events that activate the containing window](doc://com.apple.documentation/documentation/SwiftUI/View/allowsWindowActivationEven…

```swift
struct WindowDragGesture
```

### `WindowDragGesture.Body`
*typealias · macOS 15.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = some Gesture<WindowDragGesture.Value>
```

### `WindowDragGesture.Value`
*struct · macOS 15.0*

The properties of a window drag gesture.

```swift
struct Value
```

### `WindowGroup`
*struct · macOS 11.0, iOS 14.0*

A scene that presents a group of identically structured windows.  Use a `WindowGroup` as a container for a view hierarchy that your app presents. The hierarchy that you declare as the group's content serves as a template for each window that the app creates from that group:      @main     struct Mail: App {         var body: some Scene {             WindowGroup {                 MailViewer() // De…

```swift
struct WindowGroup<Content> where Content : View
```

### `WindowGroup.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `WindowIdealSize`
*struct · macOS 15.0*

A type which defines the size a window should use when zooming.  Use this type in conjunction with the `Scene.windowIdealSize(_:)` modifier to override the default behavior for how windows behave when performing a zoom.  For example, you can define a window group where the window has an ideal width of 800 points and an ideal height of 600 points:      struct MyApp: App {         var body: some Sce…

```swift
struct WindowIdealSize
```

### `WindowInteractionBehavior`
*struct · macOS 15.0*

Options for enabling and disabling window interaction behaviors.  Use values of this type in conjunction with the following view and scene modifiers to adjust the supported functionality for the window:  - ``View/windowDismissBehavior(_:)`` - ``View/windowMinimizeBehavior(_:)`` - ``View/windowFullScreenBehavior(_:)`` - ``View/windowResizeBehavior(_:)`` - ``Scene/windowBackgroundDragBehavior(_:)`` …

```swift
struct WindowInteractionBehavior
```

### `WindowLayoutRoot`
*struct · macOS 15.0*

A proxy which represents the root contents of a window.  This type acts like a proxy for the contents of the window defined by a SwiftUI ``Scene``. The ``Scene.defaultWindowPlacement(_:)`` modifier receives an instance of this type, representing the contents of the window being created.  Use this proxy to get information about the window's contents, like it's size.

```swift
struct WindowLayoutRoot
```

### `WindowLevel`
*struct · macOS 15.0*

The level of a window.  Use this in conjunction with the `.windowLevel(_:)` modifier to control window levels.

```swift
struct WindowLevel
```

### `WindowManagerRole`
*struct · macOS 15.0, iOS 18.0*

Options for defining how a scene's windows behave when used within a managed window context, such as full screen mode and Stage Manager.  Use values of this type in conjunction with the ``Scene/windowManagerRole(_:)`` modifier to override the default system behavior.  For example, you can specify that a secondary `Window` scene should use the principal role for full screen and Stage Manager:      …

```swift
struct WindowManagerRole
```

### `WindowMenuBarExtraStyle`
*struct · macOS 13.0*

A menu bar extra style that renders its contents in a popover-like window.  Use ``MenuBarExtraStyle/window`` to construct this style.

```swift
struct WindowMenuBarExtraStyle
```

### `WindowPlacement`
*struct · macOS 15.0*

A type which represents a preferred size and position for a window.  When using the ``Scene.defaultWindowPlacement(_:)`` modifier, you return an instance of a `WindowPlacement` in the closure you provide.  When constructing a window placement, many initial parameters are optional. Any value not specified will fall back to the scene's default behavior and configuration for sizing and positioning it…

```swift
struct WindowPlacement
```

### `WindowPlacementContext`
*struct · macOS 15.0*

A type which represents contextual information used for sizing and positioning windows.  The placement context provides information to be used when providing a new placement via the closure provided to the `defaultWindowPlacement(_:)` modifier.

```swift
struct WindowPlacementContext
```

### `WindowResizability`
*struct · macOS 13.0, iOS 17.0*

The resizability of a window.  Use the ``Scene/windowResizability(_:)`` scene modifier to apply a value of this type to a ``Scene`` that you define in your ``App`` declaration. The value that you specify indicates the strategy the system uses to place minimum and maximum size restrictions on windows that it creates from that scene.  For example, you can create a window group that people can resize…

```swift
struct WindowResizability
```

### `WindowStyle`
*protocol · macOS 11.0*

A specification for the appearance and interaction of a window.

```swift
protocol WindowStyle
```

### `WindowToolbarFullScreenVisibility`
*struct · macOS 15.0, iOS 18.0*

The visibility of the window toolbar with respect to full screen mode.  Use values of this type in conjunction with the ``View/windowToolbarFullScreenVisibility(_:)`` modifier to configure how the window toolbar displays itself when the window enters full screen mode.  For example, you can specify that the window toolbar should be hidden by default, and only show when the mouse moves into the area…

```swift
struct WindowToolbarFullScreenVisibility
```

### `WindowToolbarStyle`
*protocol · macOS 11.0*

A specification for the appearance and behavior of a window's toolbar.

```swift
protocol WindowToolbarStyle
```

### `WindowVisibilityToggle`
*struct · macOS 15.0*

A specialized button for toggling the visibility of a window.  This is most commonly used in the main menu, where it can toggle the visibility of `Window` and `UtilityWindow` windows. The default label uses the title of the window in the format of "Show <Title>" and "Hide <Title>" depending on the current visibility of the window.  A keyboard shortcut can be assigned to this button.  The below exa…

```swift
struct WindowVisibilityToggle<Label> where Label : View
```

### `WindowVisibilityToggle.Body`
*typealias · macOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

---

## Controls & Input

### `ControlWidget` ⭐
*protocol · macOS 26.0, iOS 18.0*

The configuration and content of a control widget to display in system spaces  such as Control Center, the Lock Screen, and the Action Button.  Controls allow users to quickly read the state of your app or its accessories, and take quick actions, without having to open your app. Users can add, configure, and arrange controls to suit their individual needs. You can provide multiple types of control…

```swift
@MainActor @preconcurrency protocol ControlWidget
```

### `ControlWidgetConfiguration` ⭐
*protocol · macOS 26.0, iOS 18.0*

A type that describes a control widget's content.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but it's not required. Declare the…

```swift
@MainActor @preconcurrency protocol ControlWidgetConfiguration
```

### `ControlWidgetConfigurationBuilder` ⭐
*struct · macOS 26.0, iOS 18.0*

A custom attribute that constructs a control widget's body.  The `@ControlWidgetConfigurationBuilder` attribute allows your control widget's body closure to produce a control widget configuration after zero or more other statements:      struct GarageDoorOpener: ControlWidget {         var body: some ControlWidgetConfiguration {             let kind = "com.yourcompany.GarageDoorOpener"            …

```swift
@resultBuilder struct ControlWidgetConfigurationBuilder
```

### `ControlWidgetTemplate` ⭐
*protocol · macOS 26.0, iOS 18.0*

A type that describes a control widget's content.  Controls are defined using templates in order to ensure that they control will work at all sizes and in all system spaces in which they might be displayed. These templates define images (specifically, symbol images) and text using simple SwiftUI views like ``Label``, ``Text``, and ``Image``; and tint colors using the ``ControlWidgetTemplate/tint(_…

```swift
@MainActor @preconcurrency protocol ControlWidgetTemplate
```

### `ControlWidgetTemplateBuilder` ⭐
*struct · macOS 26.0, iOS 18.0*

A custom attribute that constructs a control widget template's body.  The `@ControlWidgetTemplateBuilder` attribute allows your control template's body closure to produce a control template after zero or more other statements:      struct GarageDoorOpener: ControlWidget {         var body: some ControlWidgetConfiguration {             let kind = "com.yourcompany.GarageDoorOpener"              Stat…

```swift
@resultBuilder struct ControlWidgetTemplateBuilder
```

### `DefaultButtonLabel` ⭐
*struct · macOS 26.0, iOS 26.0*

The default label to use for a button.  You don't use this type directly. Instead, the system creates it automatically when you construct certain types of `Button`.

```swift
struct DefaultButtonLabel
```

### `DefaultButtonLabel.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultToolbarItem` ⭐
*struct · macOS 26.0, iOS 26.0*

A toolbar item that represents a system component.  Place this item in your toolbar to control where the system-provided item, like search, will be positioned.

```swift
struct DefaultToolbarItem
```

### `DefaultToolbarItem.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of content representing the body of this toolbar content.

```swift
typealias Body = some ToolbarContent
```

### `EmptyControlWidgetConfiguration` ⭐
*struct · macOS 26.0, iOS 18.0*

An empty control widget configuration.

```swift
@MainActor @frozen @preconcurrency struct EmptyControlWidgetConfiguration
```

### `EmptyControlWidgetConfiguration.Body` ⭐
*typealias · macOS 26.0, iOS 18.0*

The type of control widget configuration representing the body of this configuration.

```swift
typealias Body = Never
```

### `EmptyControlWidgetTemplate` ⭐
*struct · macOS 26.0, iOS 18.0*

An empty control widget template.

```swift
@MainActor @frozen @preconcurrency struct EmptyControlWidgetTemplate
```

### `EmptyControlWidgetTemplate.Body` ⭐
*typealias · macOS 26.0, iOS 18.0*

The type of control widget template representing the body of this template.  When you create a custom control widget, Swift infers this type from your implementation of the required ``ControlWidgetTemplate/body-swift.property`` property.

```swift
typealias Body = Never
```

### `SearchToolbarBehavior` ⭐
*struct · macOS 26.0, iOS 26.0*

The behavior of a search field in a toolbar.  Use this type in combination with the ``View/searchToolbarBehavior(_:)`` modifier.

```swift
struct SearchToolbarBehavior
```

### `SliderTick` ⭐
*struct · macOS 26.0, iOS 26.0*

A representation of a tick in a slider, with associated value and optional label.  The following example shows a slider bound to the value `percentage`. As the slider updates the `currentValueLabel`. The slider also renders marks at a `0.25` step interval.      @State private var percentage = 0.5      Slider(value: $percentage) {         Text("Percentage")     } currentValueLabel: {         Text("…

```swift
struct SliderTick<V> where V : BinaryFloatingPoint
```

### `SliderTick.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Body = Array<SliderTick<V>>
```

### `SliderTick.ID` ⭐
*struct · macOS 26.0, iOS 26.0*

The identity of a tick.

```swift
struct ID
```

### `SliderTick.Value` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Value = V
```

### `SliderTickBuilder` ⭐
*struct · macOS 26.0, iOS 26.0*

A result builder that constructs `SliderTick`s for use when creating a `Slider`.

```swift
@resultBuilder struct SliderTickBuilder<V> where V : BinaryFloatingPoint
```

### `SliderTickContent` ⭐
*protocol · macOS 26.0, iOS 26.0*

A type that provides content for a `SliderTickBuilder`.

```swift
protocol SliderTickContent<Value>
```

### `SliderTickContentForEach` ⭐
*struct · macOS 26.0, iOS 26.0*

A type of slider content that creates content by iterating over a collection.

```swift
struct SliderTickContentForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable, Content : SliderTickContent
```

### `SliderTickContentForEach.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Body = [SliderTick<SliderTickContentForEach<Data, ID, Content>.Value>]
```

### `SliderTickContentForEach.Value` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Value = Content.Value
```

### `TextInputFormattingControlPlacement` ⭐
*struct · macOS 26.0, iOS 26.0*

A structure defining the system text formatting controls available on each platform.

```swift
struct TextInputFormattingControlPlacement
```

### `TextInputFormattingControlPlacement.Set` ⭐
*struct · macOS 26.0, iOS 26.0*

A set of system text formatting controls.

```swift
struct Set
```

### `TextInputFormattingControlPlacement.Set.ArrayLiteralElement` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = TextInputFormattingControlPlacement.Set
```

### `TextInputFormattingControlPlacement.Set.Element` ⭐
*typealias · macOS 26.0, iOS 26.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = TextInputFormattingControlPlacement.Set
```

### `TextInputFormattingControlPlacement.Set.RawValue` ⭐
*typealias · macOS 26.0, iOS 26.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = UInt
```

### `TupleSliderTickContent` ⭐
*struct · macOS 26.0, iOS 26.0*

Slider content created from a Swift tuple of slider content.

```swift
@frozen struct TupleSliderTickContent<V, T> where V : BinaryFloatingPoint
```

### `TupleSliderTickContent.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Body = [SliderTick<V>]
```

### `TupleSliderTickContent.TicksCollection` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias TicksCollection = [SliderTick<V>]
```

### `TupleSliderTickContent.Value` ⭐
*typealias · macOS 26.0, iOS 26.0*

```swift
typealias Value = V
```

### `AccessoryBarActionButtonStyle`
*struct · macOS 14.0*

A button style that you use for extra actions in an accessory toolbar.  Use this style for buttons that perform extra actions relative to the accessory toolbar's main functions, like adding or editing filters. This style also affects other view types that you apply a button style to, like ``Toggle``, ``Picker``, and ``Menu`` instances.  Use ``PrimitiveButtonStyle/accessoryBarAction`` to construct …

```swift
struct AccessoryBarActionButtonStyle
```

### `AccessoryBarActionButtonStyle.Body`
*typealias · macOS 14.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `AccessoryBarButtonStyle`
*struct · macOS 14.0*

A button style that you use for actions in an accessory toolbar that narrow the focus of a search or other operation.  This is the default button style for views in accessory toolbars, which you create with ``ToolbarItemPlacement/init(id:)``, and for searchable scopes. This style also affects other view types that you apply a button style to, like ``Toggle``, ``Picker``, and ``Menu`` instances.  U…

```swift
struct AccessoryBarButtonStyle
```

### `AccessoryBarButtonStyle.Body`
*typealias · macOS 14.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `Alert.Button`
*struct · macOS 10.15, iOS 13.0*

A button representing an operation of an alert presentation.

```swift
struct Button
```

### `AutomaticMenuBarExtraStyle`
*struct · macOS 13.0*

The default menu bar extra style. You can also use ``MenuBarExtraStyle/automatic`` to construct this style.

```swift
struct AutomaticMenuBarExtraStyle
```

### `AutomaticTextEditorStyle`
*struct · macOS 14.0, iOS 17.0*

The default text editor style, based on the text editor's context.  You can also use ``TextEditorStyle/automatic`` to construct this style.

```swift
@MainActor @preconcurrency struct AutomaticTextEditorStyle
```

### `AutomaticTextEditorStyle.Body`
*struct · macOS 14.0, iOS 17.0*

A view that represents the body of a text editor.

```swift
@MainActor @preconcurrency struct Body
```

### `AutomaticTextEditorStyle.Body.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `BorderedButtonMenuStyle`
*struct · macOS 11.0*

A menu style that displays a bordered button that toggles the display of the menu's contents when pressed.  Use ``MenuStyle/borderedButton`` to construct this style.

```swift
struct BorderedButtonMenuStyle
```

### `BorderedButtonMenuStyle.Body`
*typealias · macOS 11.0*

A view that represents the body of a menu.

```swift
typealias Body = some View
```

### `BorderedButtonStyle`
*struct · macOS 10.15, iOS 15.0*

A button style that applies standard border artwork based on the button's context.  You can also use ``PrimitiveButtonStyle/bordered`` to construct this style.

```swift
struct BorderedButtonStyle
```

### `BorderedButtonStyle.Body`
*typealias · macOS 10.15, iOS 15.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `BorderedProminentButtonStyle`
*struct · macOS 12.0, iOS 15.0*

A button style that applies standard border prominent artwork based on the button's context.  Use ``PrimitiveButtonStyle/borderedProminent`` to construct this style.

```swift
struct BorderedProminentButtonStyle
```

### `BorderedProminentButtonStyle.Body`
*typealias · macOS 12.0, iOS 15.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `BorderlessButtonMenuButtonStyle`
*struct · macOS 10.15*

A menu button style which manifests as a borderless button with no visual embelishments.

```swift
struct BorderlessButtonMenuButtonStyle
```

### `BorderlessButtonMenuStyle`
*struct · macOS 11.0, iOS 14.0*

A menu style that displays a borderless button that toggles the display of the menu's contents when pressed.  Use ``MenuStyle/borderlessButton`` to construct this style.

```swift
struct BorderlessButtonMenuStyle
```

### `BorderlessButtonMenuStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a menu.

```swift
typealias Body = some View
```

### `BorderlessButtonStyle`
*struct · macOS 10.15, iOS 13.0*

A button style that doesn't apply a border.  You can also use ``PrimitiveButtonStyle/borderless`` to construct this style.

```swift
struct BorderlessButtonStyle
```

### `BorderlessButtonStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `BorderlessPullDownMenuButtonStyle`
*struct · macOS 10.15*

A menu button style which manifests as a borderless pull-down button.

```swift
struct BorderlessPullDownMenuButtonStyle
```

### `Button`
*struct · macOS 10.15, iOS 13.0*

A control that initiates an action.  You create a button by providing an action and a label. The action is either a method or closure property that does something when a user clicks or taps the button. The label is a view that describes the button's action --- for example, by showing text, an icon, or both.  The label of a button can be any kind of view, such as a ``Text`` view for text-only label…

```swift
struct Button<Label> where Label : View
```

### `Button.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ButtonBorderShape`
*struct · macOS 12.0, iOS 15.0*

A shape used to draw a button's border.  Use the ``View/buttonBorderShape(_:)`` view modifier to apply the shape to bordered buttons within a view hierarchy.

```swift
struct ButtonBorderShape
```

### `ButtonBorderShape.AnimatableData`
*typealias · macOS 14.0, iOS 17.0*

The type defining the data to animate.

```swift
typealias AnimatableData = EmptyAnimatableData
```

### `ButtonBorderShape.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body
```

### `ButtonBorderShape.InsetShape`
*typealias · macOS 14.0, iOS 17.0*

The type of the inset shape.

```swift
typealias InsetShape = some InsettableShape
```

### `ButtonMenuStyle`
*struct · macOS 13.0, iOS 16.0*

A menu style that displays a button that toggles the display of the menu's contents when pressed.  Use ``MenuStyle/button`` to construct this style.

```swift
struct ButtonMenuStyle
```

### `ButtonMenuStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the body of a menu.

```swift
typealias Body = some View
```

### `ButtonRepeatBehavior`
*struct · macOS 14.0, iOS 17.0*

The options for controlling the repeatability of button actions.  Use values of this type with the ``View/buttonRepeatBehavior(_:)`` modifier.

```swift
struct ButtonRepeatBehavior
```

### `ButtonRole`
*struct · macOS 12.0, iOS 15.0*

A value that describes the purpose of a button.  A button role provides a description of a button's purpose.  For example, the ``ButtonRole/destructive`` role indicates that a button performs a destructive action, like delete user data:  ``` Button("Delete", role: .destructive) { delete() } ```

```swift
struct ButtonRole
```

### `ButtonStyle`
*protocol · macOS 10.15, iOS 13.0*

A type that applies standard interaction behavior and a custom appearance to all buttons within a view hierarchy.  To configure the current button style for a view hierarchy, use the ``View/buttonStyle(_:)`` modifier. Specify a style that conforms to `ButtonStyle` when creating a button that uses the standard button interaction behavior defined for each platform. To create a button with custom int…

```swift
@MainActor @preconcurrency protocol ButtonStyle
```

### `ButtonStyle.Configuration`
*typealias · macOS 10.15, iOS 13.0*

The properties of a button.

```swift
typealias Configuration = ButtonStyleConfiguration
```

### `ButtonStyleConfiguration`
*struct · macOS 10.15, iOS 13.0*

The properties of a button.

```swift
struct ButtonStyleConfiguration
```

### `ButtonStyleConfiguration.Label`
*struct · macOS 10.15, iOS 13.0*

A type-erased label of a button.

```swift
@MainActor @preconcurrency struct Label
```

### `ButtonStyleConfiguration.Label.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `ButtonToggleStyle`
*struct · macOS 12.0, iOS 15.0*

A toggle style that displays as a button with its label as the title.  You can also use ``ToggleStyle/button`` to construct this style.      Toggle(isOn: $isFlagged) {         Label("Flag", systemImage: "flag.fill")     }     .toggleStyle(.button)

```swift
struct ButtonToggleStyle
```

### `ButtonToggleStyle.Body`
*typealias · macOS 12.0, iOS 15.0*

A view that represents the appearance and interaction of a toggle.  SwiftUI infers this type automatically based on the ``View`` instance that you return from your implementation of the ``makeBody(configuration:)`` method.

```swift
typealias Body = some View
```

### `CheckboxToggleStyle`
*struct · macOS 10.15*

A toggle style that displays a checkbox followed by its label.  Use the ``ToggleStyle/checkbox`` static variable to create this style:      Toggle("Close windows when quitting an app", isOn: $doesClose)         .toggleStyle(.checkbox)

```swift
struct CheckboxToggleStyle
```

### `CheckboxToggleStyle.Body`
*typealias · macOS 10.15*

A view that represents the appearance and interaction of a toggle.  SwiftUI infers this type automatically based on the ``View`` instance that you return from your implementation of the ``makeBody(configuration:)`` method.

```swift
typealias Body = some View
```

### `ColorPicker`
*struct · macOS 11.0, iOS 14.0*

A control used to select a color from the system color picker UI.  The color picker shows the currently selected color and displays the larger system color picker that allows people to select a new color.  By default color picker supports colors with opacity; to disable opacity support, set the `supportsOpacity` parameter to `false`. In this mode the color picker won't show controls for adjusting …

```swift
struct ColorPicker<Label> where Label : View
```

### `ColorPicker.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `CommandMenu`
*struct · macOS 11.0, iOS 14.0*

Command menus are stand-alone, top-level containers for controls that perform related, app-specific commands.  Command menus are realized as menu bar menus on macOS, inserted between the built-in View and Window menus in order of declaration. On iOS, iPadOS, and tvOS, SwiftUI creates key commands for each of a menu's commands that has a keyboard shortcut.

```swift
struct CommandMenu<Content> where Content : View
```

### `CommandMenu.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `CompactDatePickerStyle`
*struct · macOS 10.15, iOS 14.0*

A date picker style that displays the components in a compact, textual format.  You can also use ``DatePickerStyle/compact`` to construct this style.

```swift
struct CompactDatePickerStyle
```

### `CompactDatePickerStyle.Body`
*typealias · macOS 10.15, iOS 14.0*

A view representing the appearance and interaction of a `DatePicker`.

```swift
typealias Body = some View
```

### `ContentToolbarPlacement`
*struct · macOS 15.4, iOS 18.4*

```swift
struct ContentToolbarPlacement
```

### `ContextMenu`
*struct · macOS 10.15, iOS 13.0*

A container for views that you present as menu items in a context menu.  A context menu view allows you to present a situationally specific menu that enables taking actions relevant to the current task.  You can create a context menu by first defining a `ContextMenu` container with the controls that represent the actions that people can take, and then using the ``View/contextMenu(_:)`` view modifi…

```swift
struct ContextMenu<MenuItems> where MenuItems : View
```

### `CustomizableToolbarContent`
*protocol · macOS 11.0, iOS 14.0*

Conforming types represent items that can be placed in various locations in a customizable toolbar.

```swift
protocol CustomizableToolbarContent : ToolbarContent where Self.Body : CustomizableToolbarContent
```

### `DatePicker`
*struct · macOS 10.15, iOS 13.0*

A control for selecting an absolute date.  Use a `DatePicker` when you want to provide a view that allows the user to select a calendar date, and optionally a time. The view binds to a <doc://com.apple.documentation/documentation/Foundation/Date> instance.  The following example creates a basic `DatePicker`, which appears on iOS as text representing the date. This example limits the display to onl…

```swift
struct DatePicker<Label> where Label : View
```

### `DatePicker.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DatePicker.Components`
*typealias · macOS 10.15, iOS 13.0*

```swift
typealias Components = DatePickerComponents
```

### `DatePickerComponents`
*struct · macOS 10.15, iOS 13.0*

```swift
struct DatePickerComponents
```

### `DatePickerComponents.ArrayLiteralElement`
*typealias · macOS 10.15, iOS 13.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = DatePickerComponents
```

### `DatePickerComponents.Element`
*typealias · macOS 10.15, iOS 13.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = DatePickerComponents
```

### `DatePickerComponents.RawValue`
*typealias · macOS 10.15, iOS 13.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = UInt
```

### `DatePickerStyle`
*protocol · macOS 10.15, iOS 13.0*

A type that specifies the appearance and interaction of all date pickers within a view hierarchy.  To configure the current date picker style for a view hierarchy, use the ``View/datePickerStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType…

```swift
@MainActor @preconcurrency protocol DatePickerStyle
```

### `DatePickerStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

A type alias for the properties of a `DatePicker`.

```swift
typealias Configuration = DatePickerStyleConfiguration
```

### `DatePickerStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a `DatePicker`.

```swift
struct DatePickerStyleConfiguration
```

### `DatePickerStyleConfiguration.Label`
*struct · macOS 13.0, iOS 16.0*

A type-erased label of a `DatePicker`.

```swift
@MainActor @preconcurrency struct Label
```

### `DatePickerStyleConfiguration.Label.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `DefaultButtonStyle`
*struct · macOS 10.15, iOS 13.0*

The default button style, based on the button's context.  You can also use ``PrimitiveButtonStyle/automatic`` to construct this style.

```swift
struct DefaultButtonStyle
```

### `DefaultButtonStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `DefaultDatePickerStyle`
*struct · macOS 10.15, iOS 13.0*

The default style for date pickers.  You can also use ``DatePickerStyle/automatic`` to construct this style.

```swift
@MainActor @preconcurrency struct DefaultDatePickerStyle
```

### `DefaultDatePickerStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view representing the appearance and interaction of a `DatePicker`.

```swift
typealias Body = some View
```

### `DefaultMenuButtonStyle`
*struct · macOS 10.15*

The default menu button style.

```swift
struct DefaultMenuButtonStyle
```

### `DefaultMenuStyle`
*struct · macOS 11.0, iOS 14.0*

The default menu style, based on the menu's context.  You can also use ``MenuStyle/automatic`` to construct this style.

```swift
struct DefaultMenuStyle
```

### `DefaultMenuStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a menu.

```swift
typealias Body = some View
```

### `DefaultPickerStyle`
*struct · macOS 10.15, iOS 13.0*

The default picker style, based on the picker's context.  You can also use ``PickerStyle/automatic`` to construct this style.

```swift
struct DefaultPickerStyle
```

### `DefaultTextFieldStyle`
*struct · macOS 10.15, iOS 13.0*

The default text field style, based on the text field's context.  You can also use ``TextFieldStyle/automatic`` to construct this style.

```swift
struct DefaultTextFieldStyle
```

### `DefaultToggleStyle`
*struct · macOS 10.15, iOS 13.0*

The default toggle style.  Use the ``ToggleStyle/automatic`` static variable to create this style:      Toggle("Enhance Sound", isOn: $isEnhanced)         .toggleStyle(.automatic)

```swift
struct DefaultToggleStyle
```

### `DefaultToggleStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view that represents the appearance and interaction of a toggle.  SwiftUI infers this type automatically based on the ``View`` instance that you return from your implementation of the ``makeBody(configuration:)`` method.

```swift
typealias Body = some View
```

### `FieldDatePickerStyle`
*struct · macOS 10.15*

A date picker style that displays the components in an editable field.  You can also use ``DatePickerStyle/field`` to construct this style.

```swift
struct FieldDatePickerStyle
```

### `FieldDatePickerStyle.Body`
*typealias · macOS 10.15*

A view representing the appearance and interaction of a `DatePicker`.

```swift
typealias Body = some View
```

### `GraphicalDatePickerStyle`
*struct · macOS 10.15, iOS 14.0*

A date picker style that displays an interactive calendar or clock.  You can also use ``DatePickerStyle/graphical`` to construct this style.

```swift
struct GraphicalDatePickerStyle
```

### `GraphicalDatePickerStyle.Body`
*typealias · macOS 10.15, iOS 14.0*

A view representing the appearance and interaction of a `DatePicker`.

```swift
typealias Body = some View
```

### `InlinePickerStyle`
*struct · macOS 11.0, iOS 14.0*

A `PickerStyle` where each option is displayed inline with other views in the current container.  You can also use ``PickerStyle/inline`` to construct this style.

```swift
struct InlinePickerStyle
```

### `LinkButtonStyle`
*struct · macOS 10.15*

A button style for buttons that emulate links.  You can also use ``PrimitiveButtonStyle/link`` to construct this style.

```swift
struct LinkButtonStyle
```

### `LinkButtonStyle.Body`
*typealias · macOS 10.15*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `Menu`
*struct · macOS 11.0, iOS 14.0*

A control for presenting a menu of actions.  The following example presents a menu of three buttons and a submenu, which contains three buttons of its own.      Menu("Actions") {         Button("Duplicate", action: duplicate)         Button("Rename", action: rename)         Button("Delete…", action: delete)         Menu("Copy") {             Button("Copy", action: copy)             Button("Copy Fo…

```swift
struct Menu<Label, Content> where Label : View, Content : View
```

### `Menu.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `MenuActionDismissBehavior`
*struct · macOS 13.3, iOS 16.4*

The set of menu dismissal behavior options.  Configure the menu dismissal behavior for a view hierarchy using the ``View/menuActionDismissBehavior(_:)`` view modifier.

```swift
struct MenuActionDismissBehavior
```

### `MenuBarExtra`
*struct · macOS 13.0*

A scene that renders itself as a persistent control in the system menu bar.  Use a `MenuBarExtra` when you want to provide access to commonly used functionality, even when your app is not active.      @main     struct AppWithMenuBarExtra: App {         @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true          var body: some Scene {             WindowGroup {                 Conte…

```swift
struct MenuBarExtra<Label, Content> where Label : View, Content : View
```

### `MenuBarExtra.Body`
*typealias · macOS 13.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `MenuBarExtraStyle`
*protocol · macOS 13.0*

A specification for the appearance and behavior of a menu bar extra scene.

```swift
protocol MenuBarExtraStyle
```

### `MenuButton`
*struct · macOS 10.15*

A button that displays a menu containing a list of choices when pressed.

```swift
struct MenuButton<Label, Content> where Label : View, Content : View
```

### `MenuButton.Body`
*typealias · macOS 10.15*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `MenuButtonStyle`
*protocol · macOS 10.15*

A custom specification for the appearance and interaction of a `MenuButton`.

```swift
protocol MenuButtonStyle
```

### `MenuOrder`
*struct · macOS 13.0, iOS 16.0*

The order in which a menu presents its content.  You can configure the preferred menu order using the ``View/menuOrder(_:)`` view modifier.

```swift
struct MenuOrder
```

### `MenuPickerStyle`
*struct · macOS 11.0, iOS 14.0*

A picker style that presents the options as a menu when the user presses a button, or as a submenu when nested within a larger menu.  You can also use ``PickerStyle/menu`` to construct this style.

```swift
struct MenuPickerStyle
```

### `MenuStyle`
*protocol · macOS 11.0, iOS 14.0*

A type that applies standard interaction behavior and a custom appearance to all menus within a view hierarchy.  To configure the current menu style for a view hierarchy, use the ``View/menuStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomTyp…

```swift
@MainActor @preconcurrency protocol MenuStyle
```

### `MenuStyle.Configuration`
*typealias · macOS 11.0, iOS 14.0*

The properties of a menu.

```swift
typealias Configuration = MenuStyleConfiguration
```

### `MenuStyleConfiguration`
*struct · macOS 11.0, iOS 14.0*

A configuration of a menu.  Use the ``Menu/init(_:)`` initializer of ``Menu`` to create an instance using the current menu style, which you can modify to create a custom style.  For example, the following code creates a new, custom style that adds a red border to the current menu style:      struct RedBorderMenuStyle: MenuStyle {         func makeBody(configuration: Configuration) -> some View {  …

```swift
struct MenuStyleConfiguration
```

### `MenuStyleConfiguration.Content`
*struct · macOS 11.0, iOS 14.0*

A type-erased content of a menu.

```swift
@MainActor @preconcurrency struct Content
```

### `MenuStyleConfiguration.Content.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `MenuStyleConfiguration.Label`
*struct · macOS 11.0, iOS 14.0*

A type-erased label of a menu.

```swift
@MainActor @preconcurrency struct Label
```

### `MenuStyleConfiguration.Label.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `NSHostingController`
*class · macOS 10.15*

An AppKit view controller that hosts SwiftUI view hierarchy.  Create an `NSHostingController` object when you want to integrate SwiftUI views into an AppKit view hierarchy. At creation time, specify the SwiftUI view you want to use as the root view for this view controller; you can change that view later using the ``NSHostingController/rootView`` property. Use the hosting controller like you would…

```swift
@MainActor @preconcurrency class NSHostingController<Content> where Content : View
```

### `NSHostingMenu`
*class · macOS 14.4*

An AppKit menu with menu items that are defined by a SwiftUI View.  Because `NSHostingMenu` is an `NSMenu` subclass, you can integrate it into your existing AppKit view hierarchies that display menus. For example, you can set a hosting menu as an AppKit view’s context menu.  A hosting menu’s `items` property will be updated based on the content of the provided `rootView`, so direct mutations to th…

```swift
class NSHostingMenu<Content> where Content : View
```

### `NSViewControllerRepresentable`
*protocol · macOS 10.15*

A wrapper that you use to integrate an AppKit view controller into your SwiftUI interface.  Use an ``NSViewControllerRepresentable`` instance to create and manage an <doc://com.apple.documentation/documentation/AppKit/NSViewController> object in your SwiftUI interface. Adopt this protocol in one of your app's custom instances, and use its methods to create, update, and tear down your view controll…

```swift
@MainActor @preconcurrency protocol NSViewControllerRepresentable : View where Self.Body == Never
```

### `NSViewControllerRepresentable.Context`
*typealias · macOS 10.15*

```swift
typealias Context = NSViewControllerRepresentableContext<Self>
```

### `NSViewControllerRepresentableContext`
*struct · macOS 10.15*

Contextual information about the state of the system that you use to create and update your AppKit view controller.  An ``NSViewControllerRepresentableContext`` structure contains details about the current state of the system. When creating and updating your view controller, the system creates one of these structures and passes it to the appropriate method of your custom ``NSViewControllerRepresen…

```swift
@MainActor @preconcurrency struct NSViewControllerRepresentableContext<ViewController> where ViewController : NSViewControllerRepresentable
```

### `NewDocumentButton`
*struct · macOS 15.0, iOS 18.0*

A button that creates and opens new documents.  Use a new document button to give people the option to create documents in your app. In the following example, there are two new document buttons, both support ``Text`` labels. When the user taps or clicks the first button, the system creates a new document in the directory currently open in the document browser. The second button creates a new docum…

```swift
struct NewDocumentButton<Label> where Label : View
```

### `NewDocumentButton.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `PalettePickerStyle`
*struct · macOS 14.0, iOS 17.0*

A picker style that presents the options as a row of compact elements.  You can also use ``PickerStyle/palette`` to construct this style.

```swift
struct PalettePickerStyle
```

### `PasteButton`
*struct · macOS 10.15, iOS 16.0*

A system button that reads items from the pasteboard and delivers it to a closure.  Use a paste button when you want to provide a button for pasting items from the system pasteboard into your app. The system provides a button appearance and label appropriate to the current environment. However, you can use view modifiers like ``View/buttonBorderShape(_:)``, ``View/labelStyle(_:)``, and ``View/tint…

```swift
@MainActor @preconcurrency struct PasteButton
```

### `PasteButton.Body`
*typealias · macOS 10.15, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `Picker`
*struct · macOS 10.15, iOS 13.0*

A control for selecting from a set of mutually exclusive values.  You create a picker by providing a selection binding, a label, and the content for the picker to display. Set the `selection` parameter to a bound property that provides the value to display as the current selection. Set the label to a view that visually describes the purpose of selecting content in the picker, and then provide the …

```swift
struct Picker<Label, SelectionValue, Content> where Label : View, SelectionValue : Hashable, Content : View
```

### `Picker.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `PickerStyle`
*protocol · macOS 10.15, iOS 13.0*

A type that specifies the appearance and interaction of all pickers within a view hierarchy.

```swift
protocol PickerStyle
```

### `PlainButtonStyle`
*struct · macOS 10.15, iOS 13.0*

A button style that doesn't style or decorate its content while idle, but may apply a visual effect to indicate the pressed, focused, or enabled state of the button.  You can also use ``PrimitiveButtonStyle/plain`` to construct this style.

```swift
struct PlainButtonStyle
```

### `PlainButtonStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view that represents the body of a button.

```swift
typealias Body = some View
```

### `PlainTextEditorStyle`
*struct · macOS 14.0, iOS 17.0*

A text editor style with no decoration.  You can also use ``TextEditorStyle/plain`` to create this style.

```swift
struct PlainTextEditorStyle
```

### `PlainTextEditorStyle.Body`
*typealias · macOS 14.0, iOS 17.0*

A view that represents the body of a text editor.

```swift
typealias Body = some View
```

### `PlainTextFieldStyle`
*struct · macOS 10.15, iOS 13.0*

A text field style with no decoration.  You can also use ``TextFieldStyle/plain`` to construct this style.

```swift
struct PlainTextFieldStyle
```

### `PopUpButtonPickerStyle`
*struct · macOS 10.15*

A picker style that presents the options as a menu when the user presses a button.  Use this style when there are more than five options. Consider using the ``PickerStyle/radioGroup`` style when there are fewer than five options.  The button itself indicates the selected option. You can include additional controls in the set of options, such as a button to customize the list of options.  To apply …

```swift
struct PopUpButtonPickerStyle
```

### `PrimitiveButtonStyle`
*protocol · macOS 10.15, iOS 13.0*

A type that applies custom interaction behavior and a custom appearance to all buttons within a view hierarchy.  To configure the current button style for a view hierarchy, use the ``View/buttonStyle(_:)`` modifier. Specify a style that conforms to `PrimitiveButtonStyle` to create a button with custom interaction behavior. To create a button with the standard button interaction behavior defined fo…

```swift
@MainActor @preconcurrency protocol PrimitiveButtonStyle
```

### `PrimitiveButtonStyle.Configuration`
*typealias · macOS 10.15, iOS 13.0*

The properties of a button.

```swift
typealias Configuration = PrimitiveButtonStyleConfiguration
```

### `PrimitiveButtonStyleConfiguration`
*struct · macOS 10.15, iOS 13.0*

The properties of a button.

```swift
struct PrimitiveButtonStyleConfiguration
```

### `PrimitiveButtonStyleConfiguration.Label`
*struct · macOS 10.15, iOS 13.0*

A type-erased label of a button.

```swift
@MainActor @preconcurrency struct Label
```

### `PrimitiveButtonStyleConfiguration.Label.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `PullDownButton`
*typealias · macOS 10.15*

```swift
typealias PullDownButton
```

### `PullDownMenuBarExtraStyle`
*struct · macOS 13.0*

A menu bar extra style that renders its contents as a menu that pulls down from the icon in the menu bar.  Use ``MenuBarExtraStyle/menu`` to construct this style.

```swift
struct PullDownMenuBarExtraStyle
```

### `PullDownMenuButtonStyle`
*struct · macOS 10.15*

A menu button style which manifests as a pull-down button.

```swift
struct PullDownMenuButtonStyle
```

### `RenameButton`
*struct · macOS 13.0, iOS 16.0*

A button that triggers a standard rename action.  A rename button receives its action from the environment. Use the ``View/renameAction(_:)`` modifier to set the action. The system disables the button if you don't define an action.      struct RowView: View {         @State private var text = ""         @FocusState private var isFocused: Bool          var body: some View {             TextField(te…

```swift
struct RenameButton<Label> where Label : View
```

### `RenameButton.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `RoundedBorderTextFieldStyle`
*struct · macOS 10.15, iOS 13.0*

A text field style with a system-defined rounded border.  You can also use ``TextFieldStyle/roundedBorder`` to construct this style.

```swift
struct RoundedBorderTextFieldStyle
```

### `SearchFieldPlacement`
*struct · macOS 12.0, iOS 15.0*

The placement of a search field in a view hierarchy.  You can give a preferred placement to any of the searchable modifiers, like ``View/searchable(text:placement:prompt:)``:      var body: some View {         NavigationView {             PrimaryView()             SecondaryView()             Text("Select a primary and secondary item")         }         .searchable(text: $text, placement: .sidebar)…

```swift
struct SearchFieldPlacement
```

### `SearchPresentationToolbarBehavior`
*struct · macOS 14.1, iOS 17.1*

A type that defines how the toolbar behaves when presenting search.  Use this type in combination with the ``View/searchPresentationToolbarBehavior(_:)``

```swift
struct SearchPresentationToolbarBehavior
```

### `SecureField`
*struct · macOS 10.15, iOS 13.0*

A control into which people securely enter private text.  Use a secure field when you want the behavior of a ``TextField``, but you want to hide the field's text. Typically, you use this for entering passwords and other sensitive information, as the second field in the following screenshot demonstrates:  @TabNavigator {     @Tab("macOS") {         @Image(source: "SecureField-1-macOS", alt: "Two ve…

```swift
struct SecureField<Label> where Label : View
```

### `SecureField.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SegmentedPickerStyle`
*struct · macOS 10.15, iOS 13.0*

A picker style that presents the options in a segmented control.  You can also use ``PickerStyle/segmented`` to construct this style.

```swift
struct SegmentedPickerStyle
```

### `Slider`
*struct · macOS 10.15, iOS 13.0*

A control for selecting a value from a bounded linear range of values.  A slider consists of a "thumb" image that the user moves between two extremes of a linear "track". The ends of the track represent the minimum and maximum possible values. As the user moves the thumb, the slider updates its bound value.  The following example shows a slider bound to the value `speed`. As the slider updates thi…

```swift
struct Slider<Label, ValueLabel> where Label : View, ValueLabel : View
```

### `Slider.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SquareBorderTextFieldStyle`
*struct · macOS 10.15*

A text field style with a system-defined square border.  You can also use ``TextFieldStyle/squareBorder`` to construct this style.

```swift
struct SquareBorderTextFieldStyle
```

### `StepperFieldDatePickerStyle`
*struct · macOS 10.15*

A system style that displays the components in an editable field, with adjoining stepper that can increment/decrement the selected component.  You can also use ``DatePickerStyle/stepperField`` to construct this style.

```swift
struct StepperFieldDatePickerStyle
```

### `StepperFieldDatePickerStyle.Body`
*typealias · macOS 10.15*

A view representing the appearance and interaction of a `DatePicker`.

```swift
typealias Body = some View
```

### `SwitchToggleStyle`
*struct · macOS 10.15, iOS 13.0*

A toggle style that displays a leading label and a trailing switch.  Use the ``ToggleStyle/switch`` static variable to create this style:      Toggle("Enhance Sound", isOn: $isEnhanced)         .toggleStyle(.switch)

```swift
struct SwitchToggleStyle
```

### `SwitchToggleStyle.Body`
*typealias · macOS 10.15, iOS 13.0*

A view that represents the appearance and interaction of a toggle.  SwiftUI infers this type automatically based on the ``View`` instance that you return from your implementation of the ``makeBody(configuration:)`` method.

```swift
typealias Body = some View
```

### `TextEditor`
*struct · macOS 11.0, iOS 14.0*

A view that can display and edit long-form text.  A text editor view allows you to display and edit multiline, scrollable text in your app's user interface. By default, the text editor view styles the text using characteristics inherited from the environment, like ``View/font(_:)``, ``View/foregroundColor(_:)``, and ``View/multilineTextAlignment(_:)``.  You create a text editor by adding a `TextEd…

```swift
struct TextEditor
```

### `TextEditor.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `TextEditorStyle`
*protocol · macOS 14.0, iOS 17.0*

A specification for the appearance and interaction of a text editor.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the default, but it's not re…

```swift
@MainActor @preconcurrency protocol TextEditorStyle
```

### `TextEditorStyle.Configuration`
*typealias · macOS 14.0, iOS 17.0*

The properties of a text editor.

```swift
typealias Configuration = TextEditorStyleConfiguration
```

### `TextEditorStyleConfiguration`
*struct · macOS 14.0, iOS 17.0*

The properties of a text editor.

```swift
struct TextEditorStyleConfiguration
```

### `TextField`
*struct · macOS 10.15, iOS 13.0*

A control that displays an editable text interface.  You create a text field with a label and a binding to a value. If the value is a string, the text field updates this value continuously as the user types or otherwise edits the text in the field. For non-string types, it updates the value when the user commits their edits, such as by pressing the Return key.  The following example shows a text f…

```swift
struct TextField<Label> where Label : View
```

### `TextField.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `TextFieldStyle`
*protocol · macOS 10.15, iOS 13.0*

A specification for the appearance and interaction of a text field.

```swift
protocol TextFieldStyle
```

### `Toggle`
*struct · macOS 10.15, iOS 13.0*

A control that toggles between on and off states.  You create a toggle by providing an `isOn` binding and a label. Bind `isOn` to a Boolean property that determines whether the toggle is on or off. Set the label to a view that visually describes the purpose of switching between toggle states. For example:      @State private var vibrateOnRing = false      var body: some View {         Toggle(isOn:…

```swift
struct Toggle<Label> where Label : View
```

### `Toggle.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ToggleStyle`
*protocol · macOS 10.15, iOS 13.0*

The appearance and behavior of a toggle.  To configure the style for a single ``Toggle`` or for all toggle instances in a view hierarchy, use the ``View/toggleStyle(_:)`` modifier. You can specify one of the built-in toggle styles, like ``ToggleStyle/switch`` or ``ToggleStyle/button``:      Toggle(isOn: $isFlagged) {         Label("Flag", systemImage: "flag.fill")     }     .toggleStyle(.button)  …

```swift
@MainActor @preconcurrency protocol ToggleStyle
```

### `ToggleStyle.Configuration`
*typealias · macOS 10.15, iOS 13.0*

The properties of a toggle instance.  You receive a `configuration` parameter of this type --- which is an alias for the ``ToggleStyleConfiguration`` type --- when you implement the required ``makeBody(configuration:)`` method in a custom toggle style implementation.

```swift
typealias Configuration = ToggleStyleConfiguration
```

### `ToggleStyleConfiguration`
*struct · macOS 10.15, iOS 13.0*

The properties of a toggle instance.  When you define a custom toggle style by creating a type that conforms to the ``ToggleStyle`` protocol, you implement the ``ToggleStyle/makeBody(configuration:)`` method. That method takes a `ToggleStyleConfiguration` input that has the information you need to define the behavior and appearance of a ``Toggle``.  The configuration structure's ``label-swift.prop…

```swift
struct ToggleStyleConfiguration
```

### `ToggleStyleConfiguration.Label`
*struct · macOS 10.15, iOS 13.0*

A type-erased label of a toggle.  SwiftUI provides a value of this type --- which is a ``View`` type --- as the ``label-swift.property`` to your custom toggle style implementation. Use the label to help define the appearance of the toggle.

```swift
@MainActor @preconcurrency struct Label
```

### `ToggleStyleConfiguration.Label.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `ToolbarCommands`
*struct · macOS 11.0, iOS 14.0*

A built-in set of commands for manipulating window toolbars.  These commands are optional and can be explicitly requested by passing a value of this type to the ``Scene/commands(content:)`` modifier.

```swift
struct ToolbarCommands
```

### `ToolbarCommands.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `ToolbarContent`
*protocol · macOS 11.0, iOS 14.0*

Conforming types represent items that can be placed in various locations in a toolbar.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isolation to the main actor is the defaul…

```swift
@MainActor @preconcurrency protocol ToolbarContent
```

### `ToolbarContentBuilder`
*struct · macOS 11.0, iOS 14.0*

Constructs a toolbar item set from multi-expression closures.

```swift
@resultBuilder struct ToolbarContentBuilder
```

### `ToolbarCustomizationBehavior`
*struct · macOS 13.0, iOS 16.0*

The customization behavior of customizable toolbar content.  Customizable toolbar content support different types of customization behaviors. For example, some customizable content may not be removed by the user. Some content may be placed in a toolbar that supports customization overall, but not for that particular content.  Use this type in conjunction with the ``CustomizableToolbarContent/custo…

```swift
struct ToolbarCustomizationBehavior
```

### `ToolbarCustomizationOptions`
*struct · macOS 13.0, iOS 16.0*

Options that influence the default customization behavior of customizable toolbar content.  Use this type in conjunction with the ``CustomizableToolbarContent/defaultCustomization(_:options:)`` modifier.

```swift
struct ToolbarCustomizationOptions
```

### `ToolbarCustomizationOptions.ArrayLiteralElement`
*typealias · macOS 13.0, iOS 16.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = ToolbarCustomizationOptions
```

### `ToolbarCustomizationOptions.Element`
*typealias · macOS 13.0, iOS 16.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = ToolbarCustomizationOptions
```

### `ToolbarCustomizationOptions.RawValue`
*typealias · macOS 13.0, iOS 16.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `ToolbarDefaultItemKind`
*struct · macOS 14.0, iOS 17.0*

A kind of toolbar item a `View` adds by default.  `View`s can add toolbar items clients may wish to remove or customize. A default item kind can be passed to the ``View/toolbar(removing:)`` modifier to remove the item. Documentation on the `View` placing the default item should reference the `ToolbarDefaultItemKind` used to remove the item.

```swift
struct ToolbarDefaultItemKind
```

### `ToolbarItem`
*struct · macOS 11.0, iOS 14.0*

A model that represents an item which can be placed in the toolbar or navigation bar.

```swift
struct ToolbarItem<ID, Content> where Content : View
```

### `ToolbarItem.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of content representing the body of this toolbar content.

```swift
typealias Body = Never
```

### `ToolbarItemPlacement`
*struct · macOS 11.0, iOS 14.0*

A structure that defines the placement of a toolbar item.  There are two types of placements: - Semantic placements, such as ``ToolbarItemPlacement/principal`` and   ``ToolbarItemPlacement/navigation``, denote the intent of the   item being added. SwiftUI determines the appropriate placement for   the item based on this intent and its surrounding context, like the   current platform. - Positional …

```swift
struct ToolbarItemPlacement
```

### `ToolbarLabelStyle`
*struct · macOS 15.0, iOS 18.0*

The label style of a toolbar.  Use this type in conjunction with modifiers like ``Scene/windowToolbarLabelStyle(fixed:)`` and ``Scene/windowToolbarLabelStyle(_:)`` to customize the appearance of window toolbars managed by SwiftUI.

```swift
struct ToolbarLabelStyle
```

### `ToolbarPlacement`
*struct · macOS 13.0, iOS 16.0*

The placement of a toolbar.  Use this type in conjunction with modifiers like ``View/toolbarBackground(_:for:)`` and ``View/toolbar(_:for:)`` to customize the appearance of different bars managed by SwiftUI. Not all bars support all types of customizations.  See ``ToolbarItemPlacement`` to learn about the different regions of these toolbars that you can place your own controls into.

```swift
struct ToolbarPlacement
```

### `ToolbarRole`
*struct · macOS 13.0, iOS 16.0*

The purpose of content that populates the toolbar.  A toolbar role provides a description of the purpose of content that populates the toolbar. The purpose of the content influences how a toolbar renders its content. For example, a ``ToolbarRole/browser`` will automatically leading align the title of a toolbar in iPadOS.  Provide this type to the ``View/toolbarRole(_:)`` modifier:      ContentView…

```swift
struct ToolbarRole
```

### `ToolbarTitleDisplayMode`
*struct · macOS 14.0, iOS 17.0*

A type that defines the behavior of title of a toolbar.  Use the ``View/toolbarTitleDisplayMode(_:)`` modifier to configure the title display behavior of your toolbar:      NavigationStack {         ContentView()             .toolbarTitleDisplayMode(.inlineLarge)     }

```swift
struct ToolbarTitleDisplayMode
```

### `ToolbarTitleMenu`
*struct · macOS 13.0, iOS 16.0*

The title menu of a toolbar.  A title menu represents common functionality that can be done on the content represented by your app's toolbar or navigation title. This menu may be populated from your app's commands like ``CommandGroupPlacement/saveItem`` or ``CommandGroupPlacement/printItem``.      ContentView()         .toolbar {             ToolbarTitleMenu()         }  You can provide your own s…

```swift
struct ToolbarTitleMenu<Content> where Content : View
```

### `ToolbarTitleMenu.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of content representing the body of this toolbar content.

```swift
typealias Body = Never
```

---

## Text, Images & Color

### `AttributedTextSelection` ⭐
*struct · macOS 26.0, iOS 26.0*

Represents a selection of attributed text.  A selection is either an insertion point (e.g. a cursor in the text), or spans over a range of characters. While that range is always visually contiguous, it may not be logically contiguous in the text storage. Specifically, a single selection value cannot represent multiple cursors.  This is frequently used to represent selection of text in a `TextEdito…

```swift
struct AttributedTextSelection
```

### `AttributedTextSelection.Attributes` ⭐
*struct · macOS 26.0, iOS 26.0*

A sequence of all attribute values a selection has in a certain text.  The values of a selection are the attribute values of each run that is fully or partially selected, or the typing attributes in the case the selection is an insertion point.  By default, the sequence contains the attribute container for every run or the typing attributes. Use the ``Attributes``' subscript to obtain only the val…

```swift
struct Attributes<Text>
```

### `AttributedTextSelection.Attributes.Element` ⭐
*typealias · macOS 26.0, iOS 26.0*

A type representing the sequence's elements.

```swift
typealias Element = AttributeContainer
```

### `AttributedTextSelection.Attributes.Iterator` ⭐
*typealias · macOS 26.0, iOS 26.0*

A type that provides the sequence's iteration interface and encapsulates its iteration state.

```swift
typealias Iterator = some IteratorProtocol<AttributeContainer>
```

### `AttributedTextSelection.Indices` ⭐
*enum · macOS 26.0, iOS 26.0*

The indices of the current selection.

```swift
@frozen enum Indices
```

### `AccessibilityLabeledPairRole`
*enum · macOS 11.0, iOS 14.0*

The role of an accessibility element in a label / content pair.

```swift
@frozen enum AccessibilityLabeledPairRole
```

### `AsyncImage`
*struct · macOS 12.0, iOS 15.0*

A view that asynchronously loads and displays an image.  This view uses the shared <doc://com.apple.documentation/documentation/Foundation/URLSession> instance to load an image from the specified URL, and then display it. For example, you can display an icon that's stored on a server:      AsyncImage(url: URL(string: "https://example.com/icon.png"))         .frame(width: 200, height: 200)  Until t…

```swift
struct AsyncImage<Content> where Content : View
```

### `AsyncImage.Body`
*typealias · macOS 12.0, iOS 15.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `AsyncImagePhase`
*enum · macOS 12.0, iOS 15.0*

The current phase of the asynchronous image loading operation.  When you create an ``AsyncImage`` instance with the ``AsyncImage/init(url:scale:transaction:content:)`` initializer, you define the appearance of the view using a `content` closure. SwiftUI calls the closure with a phase value at different points during the load operation to indicate the current state. Use the phase to decide what to …

```swift
enum AsyncImagePhase
```

### `AutomaticLabeledContentStyle`
*struct · macOS 13.0, iOS 16.0*

The default labeled content style.  Use ``LabeledContentStyle/automatic`` to construct this style.

```swift
struct AutomaticLabeledContentStyle
```

### `AutomaticLabeledContentStyle.Body`
*typealias · macOS 13.0, iOS 16.0*

A view that represents the appearance and behavior of labeled content.

```swift
typealias Body = some View
```

### `DefaultDateProgressLabel`
*struct · macOS 13.0, iOS 16.0*

The default type of the current value label when used by a date-relative progress view.

```swift
struct DefaultDateProgressLabel
```

### `DefaultDateProgressLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultLabelStyle`
*struct · macOS 11.0, iOS 14.0*

The default label style in the current context.  You can also use ``LabelStyle/automatic`` to construct this style.

```swift
struct DefaultLabelStyle
```

### `DefaultLabelStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a label.

```swift
typealias Body = some View
```

### `DefaultSettingsLinkLabel`
*struct · macOS 14.0*

The default label to use for a settings link.  You don't use this type directly. Instead, the system creates it automatically when you construct a ``SettingsLink`` with the default label.

```swift
struct DefaultSettingsLinkLabel
```

### `DefaultSettingsLinkLabel.Body`
*typealias · macOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `DefaultShareLinkLabel`
*struct · macOS 13.0, iOS 16.0*

The default label used for a share link.  You don't use this type directly. Instead, ``ShareLink`` uses it automatically depending on how you create a share link.

```swift
struct DefaultShareLinkLabel
```

### `DefaultShareLinkLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `GaugeStyleConfiguration.CurrentValueLabel`
*struct · macOS 13.0, iOS 16.0*

A type-erased value label of a gauge that contains the current value.

```swift
@MainActor @preconcurrency struct CurrentValueLabel
```

### `GaugeStyleConfiguration.CurrentValueLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GaugeStyleConfiguration.Label`
*struct · macOS 13.0, iOS 16.0*

A type-erased label of a gauge, describing its purpose.

```swift
@MainActor @preconcurrency struct Label
```

### `GaugeStyleConfiguration.Label.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GaugeStyleConfiguration.MarkedValueLabel`
*struct · macOS 13.0, iOS 16.0*

A type-erased label describing a specific value of a gauge.

```swift
@MainActor @preconcurrency struct MarkedValueLabel
```

### `GaugeStyleConfiguration.MarkedValueLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GaugeStyleConfiguration.MaximumValueLabel`
*struct · macOS 13.0, iOS 16.0*

A type-erased value label of a gauge describing the maximum value.

```swift
@MainActor @preconcurrency struct MaximumValueLabel
```

### `GaugeStyleConfiguration.MaximumValueLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `GaugeStyleConfiguration.MinimumValueLabel`
*struct · macOS 13.0, iOS 16.0*

A type-erased value label of a gauge describing the minimum value.

```swift
@MainActor @preconcurrency struct MinimumValueLabel
```

### `GaugeStyleConfiguration.MinimumValueLabel.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `IconOnlyLabelStyle`
*struct · macOS 11.0, iOS 14.0*

A label style that only displays the icon of the label.  You can also use ``LabelStyle/iconOnly`` to construct this style.

```swift
struct IconOnlyLabelStyle
```

### `IconOnlyLabelStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a label.

```swift
typealias Body = some View
```

### `Label`
*struct · macOS 11.0, iOS 14.0*

A standard label for user interface items, consisting of an icon with a title.  One of the most common and recognizable user interface components is the combination of an icon and a label. This idiom appears across many kinds of apps and shows up in collections, lists, menus of action items, and disclosable lists, just to name a few.  You create a label, in its simplest form, by providing a title …

```swift
struct Label<Title, Icon> where Title : View, Icon : View
```

### `Label.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `LabelStyle`
*protocol · macOS 11.0, iOS 14.0*

A type that applies a custom appearance to all labels within a view.  To configure the current label style for a view hierarchy, use the ``View/labelStyle(_:)`` modifier.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurren…

```swift
@MainActor @preconcurrency protocol LabelStyle
```

### `LabelStyle.Configuration`
*typealias · macOS 11.0, iOS 14.0*

The properties of a label.

```swift
typealias Configuration = LabelStyleConfiguration
```

### `LabelStyleConfiguration`
*struct · macOS 11.0, iOS 14.0*

The properties of a label.

```swift
struct LabelStyleConfiguration
```

### `LabelStyleConfiguration.Icon`
*struct · macOS 11.0, iOS 14.0*

A type-erased icon view of a label.

```swift
@MainActor @preconcurrency struct Icon
```

### `LabelStyleConfiguration.Icon.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `LabelStyleConfiguration.Title`
*struct · macOS 11.0, iOS 14.0*

A type-erased title view of a label.

```swift
@MainActor @preconcurrency struct Title
```

### `LabelStyleConfiguration.Title.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `LabeledContent`
*struct · macOS 13.0, iOS 16.0*

A container for attaching a label to a value-bearing view.  The instance's content represents a read-only or read-write value, and its label identifies or describes the purpose of that value. The resulting element has a layout that's consistent with other framework controls and automatically adapts to its container, like a form or toolbar. Some styles of labeled content also apply styling or behav…

```swift
struct LabeledContent<Label, Content>
```

### `LabeledContent.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `LabeledContentStyle`
*protocol · macOS 13.0, iOS 16.0*

The appearance and behavior of a labeled content instance..  Use ``View/labeledContentStyle(_:)`` to set a style on a view.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by default     }  Isol…

```swift
@MainActor @preconcurrency protocol LabeledContentStyle
```

### `LabeledContentStyle.Configuration`
*typealias · macOS 13.0, iOS 16.0*

The properties of a labeled content instance.

```swift
typealias Configuration = LabeledContentStyleConfiguration
```

### `LabeledContentStyleConfiguration`
*struct · macOS 13.0, iOS 16.0*

The properties of a labeled content instance.

```swift
struct LabeledContentStyleConfiguration
```

### `LabeledContentStyleConfiguration.Content`
*struct · macOS 13.0, iOS 16.0*

A type-erased content of a labeled content instance.

```swift
@MainActor @preconcurrency struct Content
```

### `LabeledContentStyleConfiguration.Content.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `LabeledContentStyleConfiguration.Label`
*struct · macOS 13.0, iOS 16.0*

A type-erased label of a labeled content instance.

```swift
@MainActor @preconcurrency struct Label
```

### `LabeledContentStyleConfiguration.Label.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `PlaceholderTextShapeStyle`
*struct · macOS 14.0, iOS 17.0*

A style appropriate for placeholder text.

```swift
@frozen struct PlaceholderTextShapeStyle
```

### `PlaceholderTextShapeStyle.Resolved`
*typealias · macOS 14.0, iOS 17.0*

The type of shape style this will resolve to.  When you create a custom shape style, Swift infers this type from your implementation of the required `resolve` function.

```swift
typealias Resolved = Never
```

### `ProgressViewStyleConfiguration.CurrentValueLabel`
*struct · macOS 11.0, iOS 14.0*

A type-erased label that describes the current value of a progress view.

```swift
@MainActor @preconcurrency struct CurrentValueLabel
```

### `ProgressViewStyleConfiguration.CurrentValueLabel.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `ProgressViewStyleConfiguration.Label`
*struct · macOS 11.0, iOS 14.0*

A type-erased label describing the task represented by the progress view.

```swift
@MainActor @preconcurrency struct Label
```

### `ProgressViewStyleConfiguration.Label.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `SearchUnavailableContent.Label`
*struct · macOS 14.0, iOS 17.0*

A view that represents the label of a static placeholder search view.  You don't create this type directly. SwiftUI creates it when you build a search``ContentUnavailableView``.

```swift
@MainActor @preconcurrency struct Label
```

### `SearchUnavailableContent.Label.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SubmitLabel`
*struct · macOS 12.0, iOS 15.0*

A semantic label describing the label of submission within a view hierarchy.  A submit label is a description of a submission action provided to a view hierarchy using the ``View/onSubmit(of:_:)`` modifier.

```swift
struct SubmitLabel
```

### `SymbolEffectTransition`
*struct · macOS 14.0, iOS 17.0*

Creates a transition that applies the Appear, Disappear, DrawOn or DrawOff symbol animation to symbol images within the inserted or removed view hierarchy.  Other views are unaffected by this transition.

```swift
@MainActor @frozen @preconcurrency struct SymbolEffectTransition
```

### `SymbolEffectTransition.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of view representing the body.

```swift
typealias Body = some View
```

### `TextEditingCommands`
*struct · macOS 11.0, iOS 14.0*

A built-in group of commands for searching, editing, and transforming selections of text.  These commands are optional and can be explicitly requested by passing a value of this type to the `Scene.commands(_:)` modifier.

```swift
struct TextEditingCommands
```

### `TextEditingCommands.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `TextFormattingCommands`
*struct · macOS 11.0, iOS 14.0*

A built-in set of commands for transforming the styles applied to selections of text.  These commands are optional and can be explicitly requested by passing a value of this type to the `Scene.commands(_:)` modifier.

```swift
struct TextFormattingCommands
```

### `TextFormattingCommands.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `TextSelection`
*struct · macOS 15.0, iOS 18.0*

Represents a selection of text.  A selection is either an insertion point (e.g. a cursor in the text), a selection over a range of text or on macOS, multiple selections.  This is frequently used to represent selection of text in a `TextField` or `TextEditor`. The following example shows a text editor that leverages text selection to offer live suggestions based on the current selection.      struc…

```swift
struct TextSelection
```

### `TextSelection.Indices`
*enum · macOS 15.0, iOS 18.0*

The indices of the current selection.

```swift
enum Indices
```

### `TextSelectionAffinity`
*enum · macOS 15.0, iOS 18.0*

A representation of the direction or association of a selection or cursor relative to a text character. This concept becomes much more prominent when dealing with bidirectional text (text that contains both LTR and RTL scripts, like English and Arabic combined).  This type also determines whether, for example, the insertion point appears after the last character on a line or before the first chara…

```swift
enum TextSelectionAffinity
```

### `TitleAndIconLabelStyle`
*struct · macOS 11.3, iOS 14.5*

A label style that shows both the title and icon of the label using a system-standard layout.  You can also use ``LabelStyle/titleAndIcon`` to construct this style.

```swift
struct TitleAndIconLabelStyle
```

### `TitleAndIconLabelStyle.Body`
*typealias · macOS 11.3, iOS 14.5*

A view that represents the body of a label.

```swift
typealias Body = some View
```

### `TitleOnlyLabelStyle`
*struct · macOS 11.0, iOS 14.0*

A label style that only displays the title of the label.  You can also use ``LabelStyle/titleOnly`` to construct this style.

```swift
struct TitleOnlyLabelStyle
```

### `TitleOnlyLabelStyle.Body`
*typealias · macOS 11.0, iOS 14.0*

A view that represents the body of a label.

```swift
typealias Body = some View
```

---

## Lists & Collections

### `ScrollEdgeEffectStyle` ⭐
*struct · macOS 26.0, iOS 26.0*

A structure that defines the style of pocket a scroll view will have.

```swift
struct ScrollEdgeEffectStyle
```

### `AnyScrollTargetBehavior`
*struct · macOS 15.0, iOS 18.0*

A type-erased scroll target behavior.  Provide this to the ``View/scrollTargetBehavior(_:)`` modifier. When the underlying behavior changes, the scroll view to which this behavior applies will be updated.  Use this to dynamically control the scroll target behavior at runtime. For example, you could provide a paging behavior in compact size classes and a view aligned behavior otherwise.      @Envir…

```swift
@frozen struct AnyScrollTargetBehavior
```

### `BorderedListStyle`
*struct · macOS 12.0*

The list style that describes the behavior and appearance of a list with standard border.  You can also use ``ListStyle/bordered`` to construct this style.

```swift
struct BorderedListStyle
```

### `DefaultListStyle`
*struct · macOS 10.15, iOS 13.0*

The list style that describes a platform's default behavior and appearance for a list.  You can also use ``ListStyle/automatic`` to construct this style.

```swift
struct DefaultListStyle
```

### `InsetListStyle`
*struct · macOS 11.0, iOS 14.0*

The list style that describes the behavior and appearance of an inset list.  You can also use ``ListStyle/inset`` to construct this style.

```swift
struct InsetListStyle
```

### `List`
*struct · macOS 10.15, iOS 13.0*

A container that presents rows of data arranged in a single column, optionally providing the ability to select one or more members.  In its simplest form, a `List` creates its contents statically, as shown in the following example:      var body: some View {         List {             Text("A List Item")             Text("A Second List Item")             Text("A Third List Item")         }     }  …

```swift
@MainActor @preconcurrency struct List<SelectionValue, Content> where SelectionValue : Hashable, Content : View
```

### `List.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ListItemTint`
*struct · macOS 11.0, iOS 14.0*

A tint effect configuration that you can apply to content in a list.  Use one of these tint values with the ``View/listItemTint(_:)`` view modifier. The containing list applies the tint in a platform-specific way.

```swift
struct ListItemTint
```

### `ListStyle`
*protocol · macOS 10.15, iOS 13.0*

A protocol that describes the behavior and appearance of a list.

```swift
protocol ListStyle
```

### `OutlineSubgroupChildren`
*struct · macOS 11.0, iOS 14.0*

A type-erased view representing the children in an outline subgroup.  ``OutlineGroup`` uses this type as a generic constraint for the `Content` of the ``DisclosureGroup`` instances it creates.

```swift
struct OutlineSubgroupChildren
```

### `OutlineSubgroupChildren.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `PagingScrollTargetBehavior`
*struct · macOS 14.0, iOS 17.0*

The scroll behavior that aligns scroll targets to container-based geometry.  In the following example, every view in the lazy stack is flexible in both directions and the scroll view settles to container-aligned boundaries.      ScrollView {         LazyVStack(spacing: 0.0) {             ForEach(items) { item in                 FullScreenItem(item)             }         }     }     .scrollTargetBe…

```swift
struct PagingScrollTargetBehavior
```

### `PlainListStyle`
*struct · macOS 10.15, iOS 13.0*

The list style that describes the behavior and appearance of a plain list.  You can also use ``ListStyle/plain`` to construct this style.

```swift
struct PlainListStyle
```

### `ScrollAnchorRole`
*struct · macOS 15.0, iOS 18.0*

A type defining the role of a scroll anchor.  You can associate a ``UnitPoint`` to a ``ScrollView`` using the ``View/defaultScrollAnchor(_:)`` modifier. By default, the system uses this point for different kinds of behaviors including:   - Where the scroll view should initially be scrolled   - How the scroll view should handle content size or     container size changes   - How the scroll view shou…

```swift
struct ScrollAnchorRole
```

### `ScrollBounceBehavior`
*struct · macOS 13.3, iOS 16.4*

The ways that a scrollable view can bounce when it reaches the end of its content.  Use the ``View/scrollBounceBehavior(_:axes:)`` view modifier to set a value of this type for a scrollable view, like a ``ScrollView`` or a ``List``. The value configures the bounce behavior when people scroll to the end of the view's content.  You can configure each scrollable axis to use a different bounce mode.

```swift
struct ScrollBounceBehavior
```

### `ScrollDismissesKeyboardMode`
*struct · macOS 13.0, iOS 16.0*

The ways that scrollable content can interact with the software keyboard.  Use this type in a call to the ``View/scrollDismissesKeyboard(_:)`` modifier to specify the dismissal behavior of scrollable views.

```swift
struct ScrollDismissesKeyboardMode
```

### `ScrollIndicatorVisibility`
*struct · macOS 13.0, iOS 16.0*

The visibility of scroll indicators of a UI element.  Pass a value of this type to the ``View/scrollIndicators(_:axes:)`` method to specify the preferred scroll indicator visibility of a view hierarchy.

```swift
struct ScrollIndicatorVisibility
```

### `ScrollInputBehavior`
*struct · macOS 15.0, iOS 18.0*

A type that defines whether input should scroll a view.

```swift
struct ScrollInputBehavior
```

### `ScrollInputKind`
*struct · macOS 15.0, iOS 18.0*

Inputs used to scroll views.

```swift
struct ScrollInputKind
```

### `ScrollPhaseChangeContext`
*struct · macOS 15.0, iOS 18.0*

A type that provides you with more content when the phase of a scroll view changes.  You don't create this type directly. Instead, SwiftUI provides an instance of this type in the ``View/onScrollPhaseChange(_:)`` modifier.

```swift
struct ScrollPhaseChangeContext
```

### `ScrollTargetBehavior`
*protocol · macOS 14.0, iOS 17.0*

A type that defines the scroll behavior of a scrollable view.  A scrollable view calculates where scroll gestures should end using its deceleration rate and the state of its scroll gesture by default. A scroll behavior allows for customizing this logic.  You define a scroll behavior using the ``ScrollTargetBehavior/updateTarget(_:context:)`` method.  Using this method, you can control where someon…

```swift
protocol ScrollTargetBehavior
```

### `ScrollTargetBehavior.Properties`
*typealias · macOS 15.4, iOS 18.4*

The properties of a scroll behavior

```swift
typealias Properties = ScrollTargetBehaviorProperties
```

### `ScrollTargetBehavior.PropertiesContext`
*typealias · macOS 15.4, iOS 18.4*

The properties context of a scroll behavior.

```swift
typealias PropertiesContext = ScrollTargetBehaviorPropertiesContext
```

### `ScrollTargetBehavior.TargetContext`
*typealias · macOS 14.0, iOS 17.0*

The context in which a scroll behavior updates the scroll target.

```swift
typealias TargetContext = ScrollTargetBehaviorContext
```

### `ScrollTargetBehaviorContext`
*struct · macOS 14.0, iOS 17.0*

The context in which a scroll target behavior updates its scroll target.

```swift
@dynamicMemberLookup struct ScrollTargetBehaviorContext
```

### `ScrollTargetBehaviorProperties`
*struct · macOS 15.4, iOS 18.4*

Properties influencing the scroll view a scroll target behavior applies to.

```swift
struct ScrollTargetBehaviorProperties
```

### `ScrollTargetBehaviorPropertiesContext`
*struct · macOS 15.4, iOS 18.4*

The context in which a scroll target behavior can decide its properties.

```swift
struct ScrollTargetBehaviorPropertiesContext
```

### `ScrollTransitionConfiguration`
*struct · macOS 14.0, iOS 17.0*

The configuration of a scroll transition that controls how a transition is applied as a view is scrolled through the visible region of a containing scroll view or other container.

```swift
struct ScrollTransitionConfiguration
```

### `ScrollTransitionConfiguration.Threshold`
*struct · macOS 14.0, iOS 17.0*

Describes a specific point in the progression of a target view within a container from hidden (fully outside the container) to visible.

```swift
struct Threshold
```

### `ScrollTransitionPhase`
*enum · macOS 14.0, iOS 17.0*

The phases that a view transitions between when it scrolls among other views.  When a view with a scroll transition modifier applied is approaching the visible region of the containing scroll view or other container, the effect  will first be applied with the `topLeading` or `bottomTrailing` phase (depending on which edge the view is approaching), then will be moved to the `identity` phase as the …

```swift
@frozen enum ScrollTransitionPhase
```

### `ScrollView`
*struct · macOS 10.15, iOS 13.0*

A scrollable view.  The scroll view displays its content within the scrollable content region. As the user performs platform-appropriate scroll gestures, the scroll view adjusts what portion of the underlying content is visible. `ScrollView` can scroll horizontally, vertically, or both, but does not provide zooming functionality.  In the following example, a `ScrollView` allows the user to scroll …

```swift
struct ScrollView<Content> where Content : View
```

### `ScrollView.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ScrollViewProxy`
*struct · macOS 11.0, iOS 14.0*

A proxy value that supports programmatic scrolling of the scrollable views within a view hierarchy.  You don't create instances of `ScrollViewProxy` directly. Instead, your ``ScrollViewReader`` receives an instance of `ScrollViewProxy` in its `content` view builder. You use actions within this view builder, such as button and gesture handlers or the ``View/onChange(of:perform:)`` method, to call t…

```swift
struct ScrollViewProxy
```

### `ScrollViewReader`
*struct · macOS 11.0, iOS 14.0*

A view that provides programmatic scrolling, by working with a proxy to scroll to known child views.  The scroll view reader's content view builder receives a ``ScrollViewProxy`` instance; you use the proxy's ``ScrollViewProxy/scrollTo(_:anchor:)`` to perform scrolling.  The following example creates a ``ScrollView`` containing 100 views that together display a color gradient. It also contains two…

```swift
@frozen struct ScrollViewReader<Content> where Content : View
```

### `ScrollViewReader.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `Section`
*struct · macOS 10.15, iOS 13.0*

A container view that you can use to add hierarchy within certain views.  Use `Section` instances in views like ``List``, ``Picker``, and ``Form`` to organize content into separate sections. Each section has custom content that you provide on a per-instance basis. You can also provide headers and footers for each section.  ### Collapsible sections  Create sections that expand and collapse by using…

```swift
struct Section<Parent, Content, Footer>
```

### `Section.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = Never
```

### `SectionedFetchRequest`
*struct · macOS 12.0, iOS 15.0*

A property wrapper type that retrieves entities, grouped into sections, from a Core Data persistent store.  Use a `SectionedFetchRequest` property wrapper to declare a ``SectionedFetchResults`` property that provides a grouped collection of Core Data managed objects to a SwiftUI view. If you don't need sectioning, use ``FetchRequest`` instead.  Configure a sectioned fetch request with an optional …

```swift
@MainActor @propertyWrapper @preconcurrency struct SectionedFetchRequest<SectionIdentifier, Result> where SectionIdentifier : Hashable, Result : NSFetchRequestResult
```

### `SectionedFetchRequest.Configuration`
*struct · macOS 12.0, iOS 15.0*

The request's configurable properties.  You initialize a ``SectionedFetchRequest`` with a section identifier, an optional predicate, and sort descriptors, either explicitly or with a configured <doc://com.apple.documentation/documentation/CoreData/NSFetchRequest>. Later, you can dynamically update the identifier, predicate, and sort parameters using the request's configuration structure.  You acce…

```swift
struct Configuration
```

### `SectionedFetchResults`
*struct · macOS 12.0, iOS 15.0*

A collection of results retrieved from a Core Data persistent store, grouped into sections.  Use a `SectionedFetchResults` instance to show or edit Core Data managed objects, grouped into sections, in your app's user interface. If you don't need sectioning, use ``FetchedResults`` instead.  You request a particular set of results by annotating the fetched results property declaration with a ``Secti…

```swift
@MainActor @preconcurrency struct SectionedFetchResults<SectionIdentifier, Result> where SectionIdentifier : Hashable, Result : NSFetchRequestResult
```

### `SectionedFetchResults.Element`
*typealias · macOS 12.0, iOS 15.0*

A type representing the sequence's elements.

```swift
typealias Element = SectionedFetchResults<SectionIdentifier, Result>.Section
```

### `SectionedFetchResults.Index`
*typealias · macOS 12.0, iOS 15.0*

A type that represents a position in the collection.  Valid indices consist of the position of every element and a "past the end" position that's not valid for use as a subscript argument.

```swift
typealias Index = Int
```

### `SectionedFetchResults.Indices`
*typealias · macOS 12.0, iOS 15.0*

A type that represents the indices that are valid for subscripting the collection, in ascending order.

```swift
typealias Indices = Range<Int>
```

### `SectionedFetchResults.Iterator`
*typealias · macOS 12.0, iOS 15.0*

A type that provides the collection's iteration interface and encapsulates its iteration state.  By default, a collection conforms to the `Sequence` protocol by supplying `IndexingIterator` as its associated `Iterator` type.

```swift
typealias Iterator = IndexingIterator<SectionedFetchResults<SectionIdentifier, Result>>
```

### `SectionedFetchResults.Section`
*struct · macOS 12.0, iOS 15.0*

A collection of fetched results that share a specified identifier.  Examine a `Section` instance to find the entities that satisfy a ``SectionedFetchRequest`` predicate, and that have a particular property with the value stored in the section's ``id-swift.property-1h7qm`` parameter. You specify which property by setting the fetch request's `sectionIdentifier` parameter during initialization, or by…

```swift
@MainActor @preconcurrency struct Section
```

### `SectionedFetchResults.Section.Element`
*typealias · macOS 12.0, iOS 15.0*

A type representing the sequence's elements.

```swift
typealias Element = Result
```

### `SectionedFetchResults.Section.ID`
*typealias · macOS 12.0, iOS 15.0*

A type representing the stable identity of the entity associated with an instance.

```swift
typealias ID = SectionIdentifier
```

### `SectionedFetchResults.Section.Index`
*typealias · macOS 12.0, iOS 15.0*

A type that represents a position in the collection.  Valid indices consist of the position of every element and a "past the end" position that's not valid for use as a subscript argument.

```swift
typealias Index = Int
```

### `SectionedFetchResults.Section.Indices`
*typealias · macOS 12.0, iOS 15.0*

A type that represents the indices that are valid for subscripting the collection, in ascending order.

```swift
typealias Indices = Range<Int>
```

### `SectionedFetchResults.Section.Iterator`
*typealias · macOS 12.0, iOS 15.0*

A type that provides the collection's iteration interface and encapsulates its iteration state.  By default, a collection conforms to the `Sequence` protocol by supplying `IndexingIterator` as its associated `Iterator` type.

```swift
typealias Iterator = IndexingIterator<SectionedFetchResults<SectionIdentifier, Result>.Section>
```

### `SectionedFetchResults.Section.SubSequence`
*typealias · macOS 12.0, iOS 15.0*

A collection representing a contiguous subrange of this collection's elements. The subsequence shares indices with the original collection.  The default subsequence type for collections that don't define their own is `Slice`.

```swift
typealias SubSequence = Slice<SectionedFetchResults<SectionIdentifier, Result>.Section>
```

### `SectionedFetchResults.SubSequence`
*typealias · macOS 12.0, iOS 15.0*

A collection representing a contiguous subrange of this collection's elements. The subsequence shares indices with the original collection.  The default subsequence type for collections that don't define their own is `Slice`.

```swift
typealias SubSequence = Slice<SectionedFetchResults<SectionIdentifier, Result>>
```

### `SidebarListStyle`
*struct · macOS 10.15, iOS 14.0*

The list style that describes the behavior and appearance of a sidebar list.  You can also use ``ListStyle/sidebar`` to construct this style.

```swift
struct SidebarListStyle
```

### `ViewAlignedScrollTargetBehavior`
*struct · macOS 14.0, iOS 17.0*

The scroll behavior that aligns scroll targets to view-based geometry.  You use this behavior when a scroll view should always align its scroll targets to a rectangle that's aligned to the geometry of a view. In the following example, the scroll view always picks an item view to settle on.      ScrollView(.horizontal) {         LazyHStack(spacing: 10.0) {             ForEach(items) { item in      …

```swift
struct ViewAlignedScrollTargetBehavior
```

### `ViewAlignedScrollTargetBehavior.LimitBehavior`
*struct · macOS 14.0, iOS 17.0*

A type that defines the amount of views that can be scrolled at a time.

```swift
struct LimitBehavior
```

---

## Animation & Transitions

### `DragSession.Phase` ⭐
*enum · macOS 26.0, iOS 26.0*

The phase of the current drag session

```swift
enum Phase
```

### `DropSession.Phase` ⭐
*enum · macOS 26.0, iOS 26.0*

The phase of the current drop session.

```swift
enum Phase
```

### `PencilSqueezeGesturePhase` ⭐
*enum · macOS 14.5, iOS 17.5*

Describes the phase and value of an Apple Pencil squeeze gesture.  When you use the ``View/onPencilSqueeze(perform:)`` view modifier, you can handle the Apple Pencil squeeze gesture’s phase in the `action` closure.

```swift
@frozen enum PencilSqueezeGesturePhase
```

### `AnimationTimelineSchedule`
*struct · macOS 12.0, iOS 15.0*

A pausable schedule of dates updating at a frequency no more quickly than the provided interval.  You can also use ``TimelineSchedule/animation(minimumInterval:paused:)`` to construct this schedule.

```swift
struct AnimationTimelineSchedule
```

### `AnimationTimelineSchedule.Entries`
*struct · macOS 12.0, iOS 15.0*

The sequence of dates within a schedule.  The ``TimelineSchedule/entries(from:mode:)`` method returns a value of this type, which is a <doc://com.apple.documentation/documentation/Swift/Sequence> of dates in ascending order. A ``TimelineView`` that you create with a schedule updates its content at the moments in time corresponding to the dates included in the sequence.

```swift
struct Entries
```

### `AnimationTimelineSchedule.Entries.Element`
*typealias · macOS 12.0, iOS 15.0*

A type representing the sequence's elements.

```swift
typealias Element = Date
```

### `AnimationTimelineSchedule.Entries.Iterator`
*typealias · macOS 12.0, iOS 15.0*

A type that provides the sequence's iteration interface and encapsulates its iteration state.

```swift
typealias Iterator = AnimationTimelineSchedule.Entries
```

### `EmptyMatchedTransitionSourceConfiguration`
*struct · macOS 15.0, iOS 18.0*

An unstyled matched transition source configuration.

```swift
struct EmptyMatchedTransitionSourceConfiguration
```

### `HoverPhase`
*enum · macOS 13.0, iOS 16.0*

The current hovering state and value of the pointer.  When you use the ``View/onContinuousHover(coordinateSpace:perform:)`` modifier, you can handle the hovering state using the `action` closure. SwiftUI calls the closure with a phase value to indicate the current hovering state. The following example updates `hoverLocation` and `isHovering` based on the phase provided to the closure:      @State …

```swift
@frozen enum HoverPhase
```

### `KeyPress.Phases`
*struct · macOS 14.0, iOS 17.0*

Options for matching different phases of a key-press event.

```swift
struct Phases
```

### `KeyPress.Phases.ArrayLiteralElement`
*typealias · macOS 14.0, iOS 17.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = KeyPress.Phases
```

### `KeyPress.Phases.Element`
*typealias · macOS 14.0, iOS 17.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = KeyPress.Phases
```

### `KeyPress.Phases.RawValue`
*typealias · macOS 14.0, iOS 17.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `MatchedTransitionSourceConfiguration`
*protocol · macOS 15.0, iOS 18.0*

A configuration that defines the appearance of a matched transition source.

```swift
protocol MatchedTransitionSourceConfiguration : Sendable
```

### `SpatialEventCollection.Event.Phase`
*enum · macOS 15.0, iOS 18.0*

The states that an event can have.

```swift
enum Phase
```

### `SpringLoadingBehavior`
*struct · macOS 14.0, iOS 17.0*

The options for controlling the spring loading behavior of views.  Use values of this type with the ``View/springLoadingBehavior(_:)`` modifier.

```swift
struct SpringLoadingBehavior
```

---

## Presentation

### `Alert`
*struct · macOS 10.15, iOS 13.0*

A representation of an alert presentation.  Use an alert when you want the user to act in response to the state of the app or the system. If you want the user to make a choice in response to their own action, use an ``ActionSheet`` instead.  You show an alert by using the ``View/alert(isPresented:content:)`` view modifier to create an alert, which then appears whenever the bound `isPresented` valu…

```swift
struct Alert
```

### `AutomaticPresentationSizing`
*struct · macOS 15.0, iOS 18.0*

The default presentation sizing, appropriate for the platform.  - Seealso: ``PresentationSizing/automatic``

```swift
struct AutomaticPresentationSizing
```

### `CustomPresentationDetent`
*protocol · macOS 13.0, iOS 16.0*

The definition of a custom detent with a calculated height.  You can create and use a custom detent with built-in detents.      extension PresentationDetent {         static let bar = Self.custom(BarDetent.self)         static let small = Self.height(100)         static let extraLarge = Self.fraction(0.75)     }      private struct BarDetent: CustomPresentationDetent {         static func height(i…

```swift
protocol CustomPresentationDetent
```

### `CustomPresentationDetent.Context`
*typealias · macOS 13.0, iOS 16.0*

Information that you can use to calculate the height of a custom detent.

```swift
typealias Context = PresentationDetent.Context
```

### `DialogSeverity`
*struct · macOS 13.0, iOS 17.0*

The severity of an alert or confirmation dialog.  You can use dialog severity to indicate that people need to take extra care when interacting with the dialog, like when an action taken from the dialog permanently deletes data.

```swift
struct DialogSeverity
```

### `FileDialogBrowserOptions`
*struct · macOS 14.0, iOS 17.0*

The way that file dialogs present the file system.  Apply the options using the ``View/fileDialogBrowserOptions(_:)`` modifier.

```swift
struct FileDialogBrowserOptions
```

### `FileDialogBrowserOptions.ArrayLiteralElement`
*typealias · macOS 14.0, iOS 17.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = FileDialogBrowserOptions
```

### `FileDialogBrowserOptions.Element`
*typealias · macOS 14.0, iOS 17.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = FileDialogBrowserOptions
```

### `FileDialogBrowserOptions.RawValue`
*typealias · macOS 14.0, iOS 17.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `FittedPresentationSizing`
*struct · macOS 15.0, iOS 18.0*

The size of the presentation is dictated by the ideal size of the content.  The presentation is sized by proposing `nil` in the horizontal and vertical dimensions.  - Seealso: ``PresentationSizing/fitted``

```swift
struct FittedPresentationSizing
```

### `FormPresentationSizing`
*struct · macOS 15.0, iOS 18.0*

The size is appropriate for forms and slightly less wide than`.page`  On iOS, `.form` sizing enforces a platform-defined floor for the vertical and horizontal dimensions. On macOS, no floor is enforced, however a maximum proposed height is derived from the presenter height. To achieve presentations outside of these bounds, see ``PresentationSizing.fitted`` or implement your own custom ``Presentati…

```swift
struct FormPresentationSizing
```

### `PagePresentationSizing`
*struct · macOS 15.0, iOS 18.0*

The size is roughly the size of a page of paper, appropriate for informational or compositional content.  On iOS, `.page` sizing enforces a platform-defined floor for the vertical and horizontal dimensions. On macOS, no floor is enforced, however a maximum proposed height is derived from the presenter height. To achieve presentations outside of these bounds, see ``PresentationSizing.fitted`` or im…

```swift
struct PagePresentationSizing
```

### `PopoverAttachmentAnchor`
*enum · macOS 10.15, iOS 13.0*

An attachment anchor for a popover.

```swift
enum PopoverAttachmentAnchor
```

### `PresentationAdaptation`
*struct · macOS 13.3, iOS 16.4*

Strategies for adapting a presentation to a different size class.  Use values of this type with the ``View/presentationCompactAdaptation(_:)`` and ``View/presentationCompactAdaptation(horizontal:vertical:)`` modifiers.

```swift
struct PresentationAdaptation
```

### `PresentationBackgroundInteraction`
*struct · macOS 13.3, iOS 16.4*

The kinds of interaction available to views behind a presentation.  Use values of this type with the ``View/presentationBackgroundInteraction(_:)`` modifier.

```swift
struct PresentationBackgroundInteraction
```

### `PresentationContentInteraction`
*struct · macOS 13.3, iOS 16.4*

A behavior that you can use to influence how a presentation responds to swipe gestures.  Use values of this type with the ``View/presentationContentInteraction(_:)`` modifier.

```swift
struct PresentationContentInteraction
```

### `PresentationDetent`
*struct · macOS 13.0, iOS 16.0*

A type that represents a height where a sheet naturally rests.

```swift
struct PresentationDetent
```

### `PresentationDetent.Context`
*struct · macOS 13.0, iOS 16.0*

Information that you use to calculate the presentation's height.

```swift
@dynamicMemberLookup struct Context
```

### `PresentationMode`
*struct · macOS 10.15, iOS 13.0*

An indication whether a view is currently presented by another view.

```swift
struct PresentationMode
```

### `PresentationSizing`
*protocol · macOS 15.0, iOS 18.0*

A type that defines the size of the presentation content and how the presentation size adjusts to its content's size changing.  You don't need to define your own version of this protocol. The system implementations of ``PresentationSizing/form``, ``PresentationSizing/page``, and ``PresentationSizing/fitted`` are conveniences that automatically adapt to different device and screen sizes. If you do …

```swift
protocol PresentationSizing
```

### `PresentationSizingContext`
*struct · macOS 15.0, iOS 18.0*

Contextual information about a presentation.  The properties of a `PresentationSizingContext` can influence what size is proposed to a presentation.  - Note: Currently has no public members.

```swift
struct PresentationSizingContext
```

### `PresentationSizingRoot`
*struct · macOS 15.0, iOS 18.0*

A proxy to a view provided to the presentation with a defined presentation size.

```swift
struct PresentationSizingRoot
```

---

## Shapes & Drawing

### `FillShapeStyle`
*struct · macOS 14.0, iOS 17.0*

A shape style that displays one of the overlay fills.

```swift
@frozen struct FillShapeStyle
```

### `FillShapeStyle.Resolved`
*typealias · macOS 14.0, iOS 17.0*

The type of shape style this will resolve to.  When you create a custom shape style, Swift infers this type from your implementation of the required `resolve` function.

```swift
typealias Resolved = Never
```

### `LinkShapeStyle`
*struct · macOS 14.0, iOS 17.0*

A style appropriate for links.

```swift
@frozen struct LinkShapeStyle
```

### `LinkShapeStyle.Resolved`
*typealias · macOS 14.0, iOS 17.0*

The type of shape style this will resolve to.  When you create a custom shape style, Swift infers this type from your implementation of the required `resolve` function.

```swift
typealias Resolved = Never
```

### `SelectionShapeStyle`
*struct · macOS 10.15, iOS 15.0*

A style used to visually indicate selection following platform conventional colors and behaviors.  You can also use ``ShapeStyle/selection`` to construct this style.

```swift
struct SelectionShapeStyle
```

### `SelectionShapeStyle.Resolved`
*typealias · macOS 14.0, iOS 17.0*

The type of shape style this will resolve to.  When you create a custom shape style, Swift infers this type from your implementation of the required `resolve` function.

```swift
typealias Resolved = Never
```

---

## Gestures & Interaction

### `DragConfiguration` ⭐
*struct · macOS 26.0, iOS 26.0*

The behavior of the drag, proposed by the dragging source.

```swift
struct DragConfiguration
```

### `DragConfiguration.OperationsOutsideApp` ⭐
*struct · macOS 26.0, iOS 26.0*

Describes the suggested drag operations to other applications.  To create a default configuration, initialize it without parameters.  On iOS, the default behavior is to disallow drag outside the application. On macOS—support drag-to-copy to destinations both within the application and to other apps.  In addition to `copy`, add `move` operation support by specifying that in the initializer:        …

```swift
struct OperationsOutsideApp
```

### `DragConfiguration.OperationsWithinApp` ⭐
*struct · macOS 26.0, iOS 26.0*

Describes the drag operations suggested to destinations within the app.  To create a default configuration, initialize it without parameters.  On iOS, the default behavior is to allow drag-to-copy within the application. On macOS, the default configuration is to support drag-to-copy to destinations both within the application and to other apps.  In addition to `copy`, add `move` operation support …

```swift
struct OperationsWithinApp
```

### `DragDropPreviewsFormation` ⭐
*struct · macOS 26.0*

On macOS, describes the way the dragged previews are visually composed. Both drag sources and drop destination can specify their desired preview formation.

```swift
struct DragDropPreviewsFormation
```

### `DragSession` ⭐
*struct · macOS 26.0, iOS 26.0*

Describes the ongoing dragging session.

```swift
struct DragSession
```

### `DragSession.ID` ⭐
*struct · macOS 26.0, iOS 26.0*

The identifier of a drag session.

```swift
struct ID
```

### `DropConfiguration` ⭐
*struct · macOS 26.0, iOS 26.0*

Describes the behavior of the drop.

```swift
struct DropConfiguration
```

### `DropOperation.Set` ⭐
*struct · macOS 26.0, iOS 26.0*

A set of drop operations, corresponding to matching cases in `DropOperation`.

```swift
struct Set
```

### `DropOperation.Set.ArrayLiteralElement` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = DropOperation.Set
```

### `DropOperation.Set.Element` ⭐
*typealias · macOS 26.0, iOS 26.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = DropOperation.Set
```

### `DropOperation.Set.RawValue` ⭐
*typealias · macOS 26.0, iOS 26.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `DropSession` ⭐
*struct · macOS 26.0, iOS 26.0*

```swift
struct DropSession
```

### `DropSession.ID` ⭐
*struct · macOS 26.0, iOS 26.0*

The identifier of a drag session.

```swift
struct ID
```

### `DropSession.LocalSession` ⭐
*struct · macOS 26.0, iOS 26.0*

Describes the session originated within the app.

```swift
struct LocalSession
```

### `NSGestureRecognizerRepresentable` ⭐
*protocol · macOS 26.0*

A wrapper for an `NSGestureRecognizer` that you use to integrate that gesture recognizer into your SwiftUI hierarchy.  Use an ``NSGestureRecognizerRepresentable`` instance to create and manage an <doc://com.apple.documentation/documentation/AppKit/NSGestureRecognizer> object in your SwiftUI interface.  To add your gesture recognizer to a SwiftUI view, create an instance of ``NSGestureRecognizerRep…

```swift
@MainActor @preconcurrency protocol NSGestureRecognizerRepresentable
```

### `NSGestureRecognizerRepresentable.Context` ⭐
*typealias · macOS 26.0*

Contextual information about the state of the system that you use to create and update your gesture recognizer.

```swift
typealias Context = NSGestureRecognizerRepresentableContext<Self>
```

### `NSGestureRecognizerRepresentable.CoordinateSpaceConverter` ⭐
*typealias · macOS 26.0*

A type used to convert coordinates to/from coordinate spaces in the hierarchy of the associated SwiftUI view.

```swift
typealias CoordinateSpaceConverter = NSGestureRecognizerRepresentableCoordinateSpaceConverter
```

### `NSGestureRecognizerRepresentableContext` ⭐
*struct · macOS 26.0*

Contextual information about the state of the system that you use to create and update a represented gesture recognizer.

```swift
struct NSGestureRecognizerRepresentableContext<Representable> where Representable : NSGestureRecognizerRepresentable
```

### `NSGestureRecognizerRepresentableCoordinateSpaceConverter` ⭐
*struct · macOS 26.0*

A structure used to convert locations to and from coordinate spaces in the hierarchy of the SwiftUI view associated with an ``NSGestureRecognizerRepresentable``.

```swift
struct NSGestureRecognizerRepresentableCoordinateSpaceConverter
```

### `PencilDoubleTapGestureValue` ⭐
*struct · macOS 14.5, iOS 17.5*

Describes the value of an Apple Pencil double-tap gesture.

```swift
struct PencilDoubleTapGestureValue
```

### `PencilHoverPose` ⭐
*struct · macOS 14.5, iOS 17.5*

A value describing the location and distance of an Apple Pencil hovering in the area above a view’s bounds.

```swift
struct PencilHoverPose
```

### `PencilSqueezeGestureValue` ⭐
*struct · macOS 14.5, iOS 17.5*

Describes the value of an Apple Pencil squeeze gesture.

```swift
struct PencilSqueezeGestureValue
```

### `AccessibilityZoomGestureAction`
*struct · macOS 13.0, iOS 16.0*

Position and direction information of a zoom gesture that someone performs with an assistive technology like VoiceOver.

```swift
struct AccessibilityZoomGestureAction
```

### `AccessibilityZoomGestureAction.Direction`
*enum · macOS 13.0, iOS 16.0*

A direction that matches the movement of a zoom gesture performed by an assistive technology, such as a swipe up and down in Voiceover's zoom rotor.

```swift
@frozen enum Direction
```

### `DragGesture`
*struct · macOS 10.15, iOS 13.0*

A dragging motion that invokes an action as the drag-event sequence changes.  To recognize a drag gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a drag gesture to a ``Circle`` and change its color while the user performs the drag gesture:      struct DragGestureView: View {         @State private var isDraggi…

```swift
struct DragGesture
```

### `DragGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `DragGesture.Value`
*struct · macOS 10.15, iOS 13.0*

The attributes of a drag gesture.

```swift
struct Value
```

### `DropDelegate`
*protocol · macOS 10.15, iOS 13.4*

An interface that you implement to interact with a drop operation in a view modified to accept drops.  The ``DropDelegate`` protocol provides a comprehensive and flexible way to interact with a drop operation. Specify a drop delegate when you modify a view to accept drops with the ``View/onDrop(of:delegate:)`` method.  Alternatively, for simple drop cases that don't require the full functionality …

```swift
@MainActor @preconcurrency protocol DropDelegate
```

### `DropInfo`
*struct · macOS 10.15, iOS 13.4*

The current state of a drop.

```swift
struct DropInfo
```

### `DropOperation`
*enum · macOS 10.15, iOS 13.4*

Operation types that determine how a drag and drop session resolves when the user drops a drag item.

```swift
enum DropOperation
```

### `DropProposal`
*struct · macOS 10.15, iOS 13.4*

The behavior of a drop.

```swift
struct DropProposal
```

### `HandGestureShortcut`
*struct · macOS 15.0, iOS 18.0*

Hand gesture shortcuts describe finger and wrist movements that the user can perform in order to activate a button or toggle.

```swift
struct HandGestureShortcut
```

### `LongPressGesture`
*struct · macOS 10.15, iOS 13.0*

A gesture that succeeds when the user performs a long press.  To recognize a long-press gesture on a view, create and configure the gesture, then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a long-press gesture to a ``Circle`` to animate its color from blue to red, and then change it to green when the gesture ends:      struct LongPressGestureView: View {         @Ge…

```swift
struct LongPressGesture
```

### `LongPressGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `LongPressGesture.Value`
*typealias · macOS 10.15, iOS 13.0*

The type representing the gesture's value.

```swift
typealias Value = Bool
```

### `MagnificationGesture`
*struct · macOS 10.15, iOS 13.0*

A gesture that recognizes a magnification motion and tracks the amount of magnification.  A magnification gesture tracks how a magnification event sequence changes. To recognize a magnification gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a magnification gesture to a ``Circle`` that changes its size while t…

```swift
struct MagnificationGesture
```

### `MagnificationGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `MagnificationGesture.Value`
*typealias · macOS 10.15, iOS 13.0*

The type representing the gesture's value.

```swift
typealias Value = CGFloat
```

### `MagnifyGesture`
*struct · macOS 14.0, iOS 17.0*

A gesture that recognizes a magnification motion and tracks the amount of magnification.  A magnify gesture tracks how a magnification event sequence changes. To recognize a magnify gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a magnify gesture to a ``Circle`` that changes its size while the user performs t…

```swift
struct MagnifyGesture
```

### `MagnifyGesture.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `MagnifyGesture.Value`
*struct · macOS 14.0, iOS 17.0*

The type representing the gesture's value.

```swift
struct Value
```

### `RotateGesture`
*struct · macOS 14.0, iOS 17.0*

A gesture that recognizes a rotation motion and tracks the angle of the rotation.  A rotate gesture tracks how a rotation event sequence changes. To recognize a rotate gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a rotate gesture to a ``Rectangle`` and apply a rotation effect:      struct RotateGestureView:…

```swift
struct RotateGesture
```

### `RotateGesture.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `RotateGesture.Value`
*struct · macOS 14.0, iOS 17.0*

The type representing the gesture's value.

```swift
struct Value
```

### `RotationGesture`
*struct · macOS 10.15, iOS 13.0*

A gesture that recognizes a rotation motion and tracks the angle of the rotation.  A rotation gesture tracks how a rotation event sequence changes. To recognize a rotation gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier.  Add a rotation gesture to a ``Rectangle`` and apply a rotation effect:      struct RotationGest…

```swift
struct RotationGesture
```

### `RotationGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `RotationGesture.Value`
*typealias · macOS 10.15, iOS 13.0*

The type representing the gesture's value.

```swift
typealias Value = Angle
```

### `SequenceGesture`
*struct · macOS 10.15, iOS 13.0*

A gesture that's a sequence of two gestures.  Read <doc:Composing-SwiftUI-Gestures> to learn how you can create a sequence of two gestures.

```swift
@frozen struct SequenceGesture<First, Second> where First : Gesture, Second : Gesture
```

### `SequenceGesture.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `SequenceGesture.Value`
*enum · macOS 10.15, iOS 13.0*

The value of a sequence gesture that helps to detect whether the first gesture succeeded, so the second gesture can start.

```swift
@frozen enum Value
```

### `SpatialEventGesture`
*struct · macOS 15.0, iOS 18.0*

A gesture that provides information about ongoing spatial events like clicks and touches.  Use a gesture of this type to track multiple simultaneous spatial events and gain access to detailed information about each. For example, you can place a particle emitter at every location in a ``Canvas`` that has an ongoing spatial event:  ``` struct ParticlePlayground: View {     @State var model = Particl…

```swift
struct SpatialEventGesture
```

### `SpatialEventGesture.Body`
*typealias · macOS 15.0, iOS 18.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `SpatialEventGesture.Value`
*typealias · macOS 15.0, iOS 18.0*

The type representing the gesture's value.

```swift
typealias Value = SpatialEventCollection
```

### `SpatialTapGesture`
*struct · macOS 13.0, iOS 16.0*

A gesture that recognizes one or more taps and reports their location.  To recognize a tap gesture on a view, create and configure the gesture, and then add it to the view using the ``View/gesture(_:including:)`` modifier. The following code adds a tap gesture to a ``Circle`` that toggles the color of the circle based on the tap location:      struct TapGestureView: View {         @State private v…

```swift
struct SpatialTapGesture
```

### `SpatialTapGesture.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of gesture representing the body of `Self`.

```swift
typealias Body = Never
```

### `SpatialTapGesture.Value`
*struct · macOS 13.0, iOS 16.0*

The attributes of a tap gesture.

```swift
struct Value
```

---

## Accessibility

### `AccessibilityActionCategory`
*struct · macOS 15.0, iOS 18.0*

Designates an accessibility action category that is provided and named by the system.

```swift
struct AccessibilityActionCategory
```

### `AccessibilityActionKind`
*struct · macOS 10.15, iOS 13.0*

The structure that defines the kinds of available accessibility actions.

```swift
struct AccessibilityActionKind
```

### `AccessibilityAdjustmentDirection`
*enum · macOS 10.15, iOS 13.0*

A directional indicator you use when making an accessibility adjustment.

```swift
enum AccessibilityAdjustmentDirection
```

### `AccessibilityAttachmentModifier`
*struct · macOS 10.15, iOS 13.0*

A view modifier that adds accessibility properties to the view

```swift
struct AccessibilityAttachmentModifier
```

### `AccessibilityAttachmentModifier.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body.

```swift
typealias Body = Never
```

### `AccessibilityChildBehavior`
*struct · macOS 10.15, iOS 13.0*

Defines the behavior for the child elements of the new parent element.

```swift
struct AccessibilityChildBehavior
```

### `AccessibilityDirectTouchOptions`
*struct · macOS 14.0, iOS 17.0*

An option set that defines the functionality of a view's direct touch area.

```swift
struct AccessibilityDirectTouchOptions
```

### `AccessibilityDirectTouchOptions.ArrayLiteralElement`
*typealias · macOS 14.0, iOS 17.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = AccessibilityDirectTouchOptions
```

### `AccessibilityDirectTouchOptions.Element`
*typealias · macOS 14.0, iOS 17.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = AccessibilityDirectTouchOptions
```

### `AccessibilityDirectTouchOptions.RawValue`
*typealias · macOS 14.0, iOS 17.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = UInt
```

### `AccessibilityRotorContent`
*protocol · macOS 12.0, iOS 15.0*

Content within an accessibility rotor.  Generally generated from control flow constructs like `ForEach` and `if`, and `AccessibilityRotorEntry`.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation b…

```swift
@MainActor @preconcurrency protocol AccessibilityRotorContent
```

### `AccessibilityRotorContentBuilder`
*struct · macOS 12.0, iOS 15.0*

Result builder you use to generate rotor entry content.

```swift
@resultBuilder struct AccessibilityRotorContentBuilder
```

### `AccessibilityRotorEntry`
*struct · macOS 12.0, iOS 15.0*

A struct representing an entry in an Accessibility Rotor.  An Accessibility Rotor is a shortcut for Accessibility users to quickly navigate to specific elements of the user interface, and optionally specific ranges of text within those elements.  An entry in a Rotor may contain a label to identify the entry to the user, and identifier used to determine which Accessibility element the Rotor entry s…

```swift
struct AccessibilityRotorEntry<ID> where ID : Hashable
```

### `AccessibilityRotorEntry.Body`
*typealias · macOS 12.0, iOS 15.0*

The type for the internal content of this `AccessibilityRotorContent`.

```swift
typealias Body = Never
```

### `AccessibilitySystemRotor`
*struct · macOS 12.0, iOS 15.0*

Designates a Rotor that replaces one of the automatic, system-provided Rotors with a developer-provided Rotor.

```swift
struct AccessibilitySystemRotor
```

### `AccessibilityTechnologies`
*struct · macOS 12.0, iOS 15.0*

Accessibility technologies available to the system.

```swift
struct AccessibilityTechnologies
```

### `AccessibilityTechnologies.ArrayLiteralElement`
*typealias · macOS 12.0, iOS 15.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = AccessibilityTechnologies
```

### `AccessibilityTechnologies.Element`
*typealias · macOS 12.0, iOS 15.0*

A type for which the conforming type provides a containment test.

```swift
typealias Element = AccessibilityTechnologies
```

---

## Other

### `AssistiveAccess` ⭐
*struct · macOS 26.0, iOS 26.0*

A scene that presents an interface appropriate for Assistive Access on iOS and iPadOS. On other platforms, this scene is unused.

```swift
struct AssistiveAccess<Content> where Content : View
```

### `AssistiveAccess.Body` ⭐
*typealias · macOS 26.0, iOS 26.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `DismissImmersiveSpaceAction` ⭐
*struct · macOS 26.0*

An action that dismisses an immersive space.  Use the ``EnvironmentValues/dismissImmersiveSpace`` environment value to get an instance of this type for a given ``Environment``. Then call the instance to dismiss a space. You call the instance directly because it defines a ``DismissImmersiveSpaceAction/callAsFunction()`` method that Swift calls when you call the instance.  On macOS, this may be used…

```swift
@MainActor struct DismissImmersiveSpaceAction
```

### `OpenImmersiveSpaceAction` ⭐
*struct · macOS 26.0*

An action that presents an immersive space.  Use the ``EnvironmentValues/openImmersiveSpace`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to present a space. You call the instance directly because it defines `callAsFunction()` methods that Swift calls when you call the instance.  On macOS, this may be used to open a remote immersive s…

```swift
@MainActor struct OpenImmersiveSpaceAction
```

### `OpenImmersiveSpaceAction.Result` ⭐
*enum · macOS 26.0*

The outcome of an attempt to open an immersive space.

```swift
enum Result
```

### `PencilPreferredAction` ⭐
*struct · macOS 14.5, iOS 17.5*

An action that the user prefers to perform after double-tapping their Apple Pencil.

```swift
struct PencilPreferredAction
```

### `ProgressiveImmersionAspectRatio` ⭐
*struct · macOS 26.0*

```swift
struct ProgressiveImmersionAspectRatio
```

### `RemoteDeviceIdentifier` ⭐
*struct · macOS 26.0*

An opaque type that identifies a remote device displaying scene content in a ``RemoteImmersiveSpace``.  Access this from the ``EnvironmentValues/remoteDeviceIdentifier`` environment property in a remote scene to get the identifier for that scene's device.  When accessed in a context that is being presented on the local device, this value will be `nil`.  This identifier can also be used to initiali…

```swift
struct RemoteDeviceIdentifier
```

### `RemoteImmersiveSpace` ⭐
*struct · macOS 26.0*

A scene that presents its content in an unbounded space on a remote device.  Use a remote immersive space as a container for compositor content that your macOS app presents on a user's chosen visionOS device. The compositor content that you declare as the remote immersive space's content serves as a template for it:      @main     struct SolarSystemApp: App {         var body: some Scene {        …

```swift
struct RemoteImmersiveSpace<Content, Data> where Content : ImmersiveSpaceContent, Data : Decodable, Data : Encodable, Data : Hashable
```

### `RemoteImmersiveSpace.Body` ⭐
*typealias · macOS 26.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `SensoryFeedback` ⭐
*struct · macOS 14.0, iOS 17.0*

Represents a type of haptic and/or audio feedback that can be played.  This feedback can be passed to `View.sensoryFeedback` to play it.

```swift
struct SensoryFeedback
```

### `SensoryFeedback.Flexibility` ⭐
*struct · macOS 14.0, iOS 17.0*

The flexibility to be represented by a type of feedback.  `Flexibility` values can be passed to `SensoryFeedback.impact(flexibility:intensity:)`.

```swift
struct Flexibility
```

### `SensoryFeedback.PressFeedback` ⭐
*struct · macOS 26.0, iOS 26.0*

Feedback that can be played in response to a press (touch down) on a control.

```swift
struct PressFeedback
```

### `SensoryFeedback.ReleaseFeedback` ⭐
*struct · macOS 26.0, iOS 26.0*

Feedback that can be played in response to a release (touch up) of a control.

```swift
struct ReleaseFeedback
```

### `SensoryFeedback.SelectionFeedback` ⭐
*struct · macOS 26.0, iOS 26.0*

Feedback that can be played in response to a specific UI element's values changing.

```swift
struct SelectionFeedback
```

### `SensoryFeedback.Weight` ⭐
*struct · macOS 14.0, iOS 17.0*

The weight to be represented by a type of feedback.  `Weight` values can be passed to `SensoryFeedback.impact(weight:intensity:)`.

```swift
struct Weight
```

### `SurroundingsEffect` ⭐
*struct · macOS 26.0*

Effects that the system can apply to passthrough video.  Use one of these values with the ``View/preferredSurroundingsEffect(_:)`` view modifier to indicate what effect to apply to passthrough video when the modified view is displayed.

```swift
struct SurroundingsEffect
```

### `WorldTrackingLimitation` ⭐
*struct · macOS 26.0*

A structure to represent limitations of tracking the user's surroundings.  You receive a set of world tracking limitations when you read the ``EnvironmentValues/worldTrackingLimitations`` environment value. The value tells you which limitations the device currently is facing. If any of the limitations occur due to changing circumstances, e.g., the lighting, the set is updated accordingly. For exam…

```swift
struct WorldTrackingLimitation
```

### `AlternatingRowBackgroundBehavior`
*struct · macOS 14.0*

The styling of views with respect to alternating row backgrounds.  Use values of this type with the ``View/alternatingRowBackgrounds(_:)`` modifier.

```swift
struct AlternatingRowBackgroundBehavior
```

### `BackgroundTask`
*struct · macOS 13.0, iOS 16.0*

The kinds of background tasks that your app or extension can handle.  Use a value of this type with the ``Scene/backgroundTask(_:action:)`` scene modifier to create a handler for background tasks that the system sends to your app or extension. For example, you can use ``urlSession`` to define an asynchronous closure that the system calls when it launches your app or extension to handle a response …

```swift
struct BackgroundTask<Request, Response>
```

### `BadgeProminence`
*struct · macOS 14.0, iOS 17.0*

The visual prominence of a badge.  Badges can be used for different kinds of information, from the passive number of items in a container to the number of required actions. The prominence of badges in Lists can be adjusted to reflect this and be made to draw more or less attention to themselves.  Badges will default to `standard` prominence unless specified.  The following example shows a ``List``…

```swift
struct BadgeProminence
```

### `Commands`
*protocol · macOS 11.0, iOS 14.0*

Conforming types represent a group of related commands that can be exposed to the user via the main menu on macOS and key commands on iOS.  A type conforming to this protocol inherits `@preconcurrency @MainActor` isolation from the protocol if the conformance is included in the type's base declaration:      struct MyCustomType: Transition {         // `@preconcurrency @MainActor` isolation by defa…

```swift
@MainActor @preconcurrency protocol Commands
```

### `CommandsBuilder`
*struct · macOS 11.0, iOS 14.0*

Constructs command sets from multi-expression closures. Like `ViewBuilder`, it supports up to ten expressions in the closure body.

```swift
@resultBuilder struct CommandsBuilder
```

### `ContainerBackgroundPlacement`
*struct · macOS 14.0, iOS 17.0*

The placement of a container background.  This method controls where to place a background that you specify with the ``View/containerBackground(_:for:)`` or ``View/containerBackground(for:alignment:content:)`` modifier.

```swift
struct ContainerBackgroundPlacement
```

### `DismissAction`
*struct · macOS 12.0, iOS 15.0*

An action that dismisses a presentation.  Use the ``EnvironmentValues/dismiss`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to perform the dismissal. You call the instance directly because it defines a ``DismissAction/callAsFunction()`` method that Swift calls when you call the instance.  You can use this action to:  * Dismiss a modal…

```swift
@MainActor @preconcurrency struct DismissAction
```

### `DismissBehavior`
*struct · macOS 14.0, iOS 17.0*

Programmatic window dismissal behaviors.  Use values of this type to control window dismissal during the current transaction.  For example, to dismiss windows showing a modal presentation that would otherwise prohibit dismissal, use the ``destructive`` behavior:      struct DismissWindowButton: View {         @Environment(\.dismissWindow) private var dismissWindow          var body: some View {   …

```swift
struct DismissBehavior
```

### `DismissSearchAction`
*struct · macOS 12.0, iOS 15.0*

An action that can end a search interaction.  Use the ``EnvironmentValues/dismissSearch`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to dismiss the current search interaction. You call the instance directly because it defines a ``DismissSearchAction/callAsFunction()`` method that Swift calls when you call the instance.  When you dism…

```swift
@MainActor @preconcurrency struct DismissSearchAction
```

### `DocumentBaseBox`
*protocol · macOS 14.0, iOS 17.0*

A Box that allows setting its Document base not requiring the caller to know the exact types of the box and its base.

```swift
protocol DocumentBaseBox<Document> : AnyObject
```

### `EditActions`
*struct · macOS 13.0, iOS 16.0*

A set of edit actions on a collection of data that a view can offer to a user.

```swift
struct EditActions<Data>
```

### `EditActions.ArrayLiteralElement`
*typealias · macOS 13.0, iOS 16.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = EditActions<Data>
```

### `EditActions.Element`
*typealias · macOS 13.0, iOS 16.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = EditActions<Data>
```

### `EditActions.RawValue`
*typealias · macOS 13.0, iOS 16.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `EmptyCommands`
*struct · macOS 11.0, iOS 14.0*

An empty group of commands.

```swift
struct EmptyCommands
```

### `EmptyCommands.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = Never
```

### `FetchRequest`
*struct · macOS 10.15, iOS 13.0*

A property wrapper type that retrieves entities from a Core Data persistent store.  Use a `FetchRequest` property wrapper to declare a ``FetchedResults`` property that provides a collection of Core Data managed objects to a SwiftUI view. The request infers the entity type from the `Result` placeholder type that you specify. Condition the request with an optional predicate and sort descriptors. For…

```swift
@MainActor @propertyWrapper @preconcurrency struct FetchRequest<Result> where Result : NSFetchRequestResult
```

### `FetchedResults`
*struct · macOS 10.15, iOS 13.0*

A collection of results retrieved from a Core Data store.  Use a `FetchedResults` instance to show or edit Core Data managed objects in your app's user interface. You request a particular set of results by specifying a `Result` type as the entity type, and annotating the fetched results property declaration with a ``FetchRequest`` property wrapper. For example, you can create a request to list all…

```swift
@MainActor @preconcurrency struct FetchedResults<Result> where Result : NSFetchRequestResult
```

### `FetchedResults.Element`
*typealias · macOS 10.15, iOS 13.0*

A type representing the sequence's elements.

```swift
typealias Element = Result
```

### `FetchedResults.Index`
*typealias · macOS 10.15, iOS 13.0*

A type that represents a position in the collection.  Valid indices consist of the position of every element and a "past the end" position that's not valid for use as a subscript argument.

```swift
typealias Index = Int
```

### `FetchedResults.Indices`
*typealias · macOS 10.15, iOS 13.0*

A type that represents the indices that are valid for subscripting the collection, in ascending order.

```swift
typealias Indices = Range<Int>
```

### `FetchedResults.Iterator`
*typealias · macOS 10.15, iOS 13.0*

A type that provides the collection's iteration interface and encapsulates its iteration state.  By default, a collection conforms to the `Sequence` protocol by supplying `IndexingIterator` as its associated `Iterator` type.

```swift
typealias Iterator = IndexingIterator<FetchedResults<Result>>
```

### `FetchedResults.SubSequence`
*typealias · macOS 10.15, iOS 13.0*

A collection representing a contiguous subrange of this collection's elements. The subsequence shares indices with the original collection.  The default subsequence type for collections that don't define their own is `Slice`.

```swift
typealias SubSequence = Slice<FetchedResults<Result>>
```

### `FileDocument`
*protocol · macOS 11.0, iOS 14.0*

A type that you use to serialize documents to and from file.  To store a document as a value type --- like a structure --- create a type that conforms to the `FileDocument` protocol and implement the required methods and properties. Your implementation:  * Provides a list of the content types that the document can read from and   write to by defining ``readableContentTypes``. If the list of conten…

```swift
@preconcurrency protocol FileDocument : Sendable
```

### `Form`
*struct · macOS 10.15, iOS 13.0*

A container for grouping controls used for data entry, such as in settings or inspectors.  SwiftUI applies platform-appropriate styling to views contained inside a form, to group them together. Form-specific styling applies to things like buttons, toggles, labels, lists, and more. Keep in mind that these stylings may be platform-specific. For example, forms appear as grouped lists on iOS, and as a…

```swift
struct Form<Content> where Content : View
```

### `Form.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `FrameResizeDirection`
*enum · macOS 15.0*

The direction in which a rectangular frame can be resized.

```swift
@frozen enum FrameResizeDirection
```

### `FrameResizeDirection.AllCases`
*typealias · macOS 15.0*

A type that can represent a collection of all values of this type.

```swift
typealias AllCases = [FrameResizeDirection]
```

### `FrameResizeDirection.RawValue`
*typealias · macOS 15.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int8
```

### `FrameResizeDirection.Set`
*struct · macOS 15.0*

An efficient set of frame resize directions.

```swift
@frozen struct Set
```

### `FrameResizeDirection.Set.ArrayLiteralElement`
*typealias · macOS 15.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = FrameResizeDirection.Set.Element
```

### `FrameResizeDirection.Set.Element`
*typealias · macOS 15.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = FrameResizeDirection.Set
```

### `FrameResizeDirection.Set.RawValue`
*typealias · macOS 15.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int8
```

### `FrameResizePosition`
*enum · macOS 15.0*

The position along the perimeter of a rectangular frame (its edges and corners) from which it’s resized.

```swift
@frozen enum FrameResizePosition
```

### `FrameResizePosition.AllCases`
*typealias · macOS 15.0*

A type that can represent a collection of all values of this type.

```swift
typealias AllCases = [FrameResizePosition]
```

### `FrameResizePosition.RawValue`
*typealias · macOS 15.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int8
```

### `Gauge`
*struct · macOS 13.0, iOS 16.0*

A view that shows a value within a range.  A gauge is a view that shows a current level of a value in relation to a specified finite capacity, very much like a fuel gauge in an automobile. Gauge displays are configurable; they can show any combination of the gauge's current value, the range the gauge can display, and a label describing the purpose of the gauge itself.  In its most basic form, a ga…

```swift
struct Gauge<Label, CurrentValueLabel, BoundsLabel, MarkedValueLabels> where Label : View, CurrentValueLabel : View, BoundsLabel : View, MarkedValueLabels : View
```

### `Gauge.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `HelpLink`
*struct · macOS 14.0*

A button with a standard appearance that opens app-specific help documentation.  A help link opens documentation relevant to the context where they are used. Typically this is by opening to an anchor in an Apple Help book, but can also perform an arbitrary action such as opening a URL or opening a window.      HelpLink(anchor: "accountSetupHelp")      HelpLink {         openURL(onlineHelpURL)     …

```swift
struct HelpLink
```

### `HelpLink.Body`
*typealias · macOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ImportFromDevicesCommands`
*struct · macOS 12.0*

A built-in set of commands that enables importing content from nearby devices.  This set of commands adds items based on nearby devices and capabilities, like taking photos or scanning documents. Views can receive imported content from these menu items by using the ``View/importsItemProviders(_:onImport:)`` modifier.  These commands are optional and you can explicitly request them by passing a val…

```swift
struct ImportFromDevicesCommands
```

### `ImportFromDevicesCommands.Body`
*typealias · macOS 12.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `IndexedIdentifierCollection`
*struct · macOS 13.0, iOS 16.0*

A collection wrapper that iterates over the indices and identifiers of a collection together.  You don't use this type directly. Instead SwiftUI creates this type on your behalf.

```swift
struct IndexedIdentifierCollection<Base, ID> where Base : Collection, ID : Hashable
```

### `IndexedIdentifierCollection.Element`
*struct · macOS 13.0, iOS 16.0*

A type representing the sequence's elements.

```swift
struct Element
```

### `IndexedIdentifierCollection.Index`
*typealias · macOS 13.0, iOS 16.0*

A type that represents a position in the collection.  Valid indices consist of the position of every element and a "past the end" position that's not valid for use as a subscript argument.

```swift
typealias Index = Base.Index
```

### `IndexedIdentifierCollection.Indices`
*typealias · macOS 13.0, iOS 16.0*

A type that represents the indices that are valid for subscripting the collection, in ascending order.

```swift
typealias Indices = DefaultIndices<IndexedIdentifierCollection<Base, ID>>
```

### `IndexedIdentifierCollection.Iterator`
*typealias · macOS 13.0, iOS 16.0*

A type that provides the collection's iteration interface and encapsulates its iteration state.  By default, a collection conforms to the `Sequence` protocol by supplying `IndexingIterator` as its associated `Iterator` type.

```swift
typealias Iterator = IndexingIterator<IndexedIdentifierCollection<Base, ID>>
```

### `IndexedIdentifierCollection.SubSequence`
*typealias · macOS 13.0, iOS 16.0*

A collection representing a contiguous subrange of this collection's elements. The subsequence shares indices with the original collection.  The default subsequence type for collections that don't define their own is `Slice`.

```swift
typealias SubSequence = Slice<IndexedIdentifierCollection<Base, ID>>
```

### `InspectorCommands`
*struct · macOS 14.0, iOS 17.0*

A built-in set of commands for manipulating inspectors.  `InspectorCommands` include a command for toggling the presented state of the inspector with a keyboard shortcut of Control-Command-I.  These commands are optional and can be explicitly requested by passing a value of this type to the ``Scene/commands(content:)`` modifier:      @State var presented = true     WindowGroup {         MainView()…

```swift
struct InspectorCommands
```

### `InspectorCommands.Body`
*typealias · macOS 14.0, iOS 17.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `InterfaceOrientation`
*struct · macOS 12.0, iOS 15.0*

The orientation of the interface from the user's perspective.  By default, device previews appear right side up, using orientation ``InterfaceOrientation/portrait``. You can change the orientation with a call to the ``View/previewInterfaceOrientation(_:)`` modifier:      struct CircleImage_Previews: PreviewProvider {         static var previews: some View {             CircleImage()               …

```swift
struct InterfaceOrientation
```

### `InterfaceOrientation.AllCases`
*typealias · macOS 12.0, iOS 15.0*

A type that can represent a collection of all values of this type.

```swift
typealias AllCases = [InterfaceOrientation]
```

### `InterfaceOrientation.ID`
*typealias · macOS 12.0, iOS 15.0*

A type representing the stable identity of the entity associated with an instance.

```swift
typealias ID = String
```

### `KeyEquivalent`
*struct · macOS 11.0, iOS 14.0*

Key equivalents consist of a letter, punctuation, or function key that can be combined with an optional set of modifier keys to specify a keyboard shortcut.  Key equivalents are used to establish keyboard shortcuts to app functionality. Any key can be used as a key equivalent as long as pressing it produces a single character value. Key equivalents are typically initialized using a single-characte…

```swift
struct KeyEquivalent
```

### `KeyEquivalent.ExtendedGraphemeClusterLiteralType`
*typealias · macOS 11.0, iOS 14.0*

A type that represents an extended grapheme cluster literal.  Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`, `String`, and `StaticString`.

```swift
typealias ExtendedGraphemeClusterLiteralType = Character
```

### `KeyEquivalent.UnicodeScalarLiteralType`
*typealias · macOS 11.0, iOS 14.0*

A type that represents a Unicode scalar literal.  Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`, `Character`, `String`, and `StaticString`.

```swift
typealias UnicodeScalarLiteralType = Character
```

### `KeyPress`
*struct · macOS 14.0, iOS 17.0*

```swift
struct KeyPress
```

### `KeyPress.Result`
*enum · macOS 14.0, iOS 17.0*

A result value returned from a key-press action that indicates whether the action consumed the event.

```swift
enum Result
```

### `KeyboardShortcut`
*struct · macOS 11.0, iOS 14.0*

Keyboard shortcuts describe combinations of keys on a keyboard that the user can press in order to activate a button or toggle.

```swift
struct KeyboardShortcut
```

### `KeyboardShortcut.Localization`
*struct · macOS 12.0, iOS 15.0*

Options for how a keyboard shortcut participates in automatic localization.  A shortcut's `key` that is defined on an US-English keyboard layout might not be reachable on international layouts. For example the shortcut `⌘[` works well for the US layout but is hard to reach for German users. On the German keyboard layout, pressing `⌥5` will produce `[`, which causes the shortcut to become `⌥⌘5`. If…

```swift
struct Localization
```

### `Link`
*struct · macOS 11.0, iOS 14.0*

A control for navigating to a URL.  Create a link by providing a destination URL and a title. The title tells the user the purpose of the link, and can be a string, a title key that produces a localized string, or a view that acts as a label. The example below creates a link to `example.com` and displays the title string as a link-styled view:      Link("View Our Terms of Service",           desti…

```swift
@MainActor @preconcurrency struct Link<Label> where Label : View
```

### `Link.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `MoveCommandDirection`
*enum · macOS 10.15*

Specifies the direction of an arrow key movement.

```swift
enum MoveCommandDirection
```

### `NSHostingSizingOptions`
*struct · macOS 13.0*

Options for how hosting views and controllers reflect their content's size into Auto Layout constraints.

```swift
struct NSHostingSizingOptions
```

### `NSHostingSizingOptions.ArrayLiteralElement`
*typealias · macOS 13.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = NSHostingSizingOptions
```

### `NSHostingSizingOptions.Element`
*typealias · macOS 13.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = NSHostingSizingOptions
```

### `NSHostingSizingOptions.RawValue`
*typealias · macOS 13.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `NewDocumentAction`
*struct · macOS 13.0*

An action that presents a new document.  Use the ``EnvironmentValues/newDocument`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to present a new document. You call the instance directly because it defines a ``NewDocumentAction/callAsFunction(_:)`` method that Swift calls when you call the instance.  For example, you can define a button…

```swift
@MainActor @preconcurrency struct NewDocumentAction
```

### `OpenDocumentAction`
*struct · macOS 13.0*

An action that presents an existing document.  Use the ``EnvironmentValues/openDocument`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to present an existing document. You call the instance directly because it defines a ``OpenDocumentAction/callAsFunction(at:)`` method that Swift calls when you call the instance.  For example, you can …

```swift
@MainActor struct OpenDocumentAction
```

### `OpenSettingsAction`
*struct · macOS 14.0*

An action that presents the settings scene for an app.  Use the ``EnvironmentValues/openSettings`` environment value to get the instance of this structure for a given ``Environment``. Then call the instance to open a window. You call the instance directly because it defines a ``OpenSettingsAction/callAsFunction()`` method that Swift calls when you call the instance.  For example, you can define a …

```swift
@MainActor @preconcurrency struct OpenSettingsAction
```

### `PaletteSelectionEffect`
*struct · macOS 14.0, iOS 17.0*

The selection effect to apply to a palette item.  You can configure the selection effect of a palette item by using the ``View/paletteSelectionEffect(_:)`` view modifier.

```swift
struct PaletteSelectionEffect
```

### `PreviewDevice`
*struct · macOS 10.15, iOS 13.0*

A simulator device that runs a preview.  Create a preview device by name, like "iPhone X", or by model number, like "iPad8,1". Use the device in a call to the ``View/previewDevice(_:)`` modifier to set a preview device that doesn't change when you change the run destination in Xcode:      struct CircleImage_Previews: PreviewProvider {         static var previews: some View {             CircleImag…

```swift
struct PreviewDevice
```

### `PreviewDevice.ExtendedGraphemeClusterLiteralType`
*typealias · macOS 10.15, iOS 13.0*

A type that represents an extended grapheme cluster literal.  Valid types for `ExtendedGraphemeClusterLiteralType` are `Character`, `String`, and `StaticString`.

```swift
typealias ExtendedGraphemeClusterLiteralType = String
```

### `PreviewDevice.RawValue`
*typealias · macOS 10.15, iOS 13.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = String
```

### `PreviewDevice.StringLiteralType`
*typealias · macOS 10.15, iOS 13.0*

A type that represents a string literal.  Valid types for `StringLiteralType` are `String` and `StaticString`.

```swift
typealias StringLiteralType = String
```

### `PreviewDevice.UnicodeScalarLiteralType`
*typealias · macOS 10.15, iOS 13.0*

A type that represents a Unicode scalar literal.  Valid types for `UnicodeScalarLiteralType` are `Unicode.Scalar`, `Character`, `String`, and `StaticString`.

```swift
typealias UnicodeScalarLiteralType = String
```

### `PreviewPlatform`
*enum · macOS 10.15, iOS 13.0*

Platforms that can run the preview.  Xcode infers the platform for a preview based on the currently selected target. If you have a multiplatform target and want to suggest a particular target for a preview, implement the ``PreviewProvider/platform-75xu4`` computed property as a hint, and specify one of the preview platforms:      struct CircleImage_Previews: PreviewProvider {         static var pr…

```swift
enum PreviewPlatform
```

### `ReferenceFileDocument`
*protocol · macOS 11.0, iOS 14.0*

A type that you use to serialize reference type documents to and from file.  To store a document as a reference type --- like a class --- create a type that conforms to the `ReferenceFileDocument` protocol and implement the required methods and properties. Your implementation:  * Provides a list of the content types that the document can read from and   write to by defining ``readableContentTypes`…

```swift
@preconcurrency protocol ReferenceFileDocument : ObservableObject, Sendable
```

### `RefreshAction`
*struct · macOS 12.0, iOS 15.0*

An action that initiates a refresh operation.  When the ``EnvironmentValues/refresh`` environment value contains an instance of this structure, certain built-in views in the corresponding ``Environment`` begin offering a refresh capability. They apply the instance's handler to any refresh operation that the user initiates. By default, the environment value is `nil`, but you can use the ``View/refr…

```swift
struct RefreshAction
```

### `RenameAction`
*struct · macOS 13.0, iOS 16.0*

An action that activates a standard rename interaction.  Use the ``View/renameAction(_:)`` modifier to configure the rename action in the environment.

```swift
struct RenameAction
```

### `SearchScopeActivation`
*struct · macOS 13.3, iOS 16.4*

The ways that searchable modifiers can show or hide search scopes.

```swift
struct SearchScopeActivation
```

### `SearchSuggestionsPlacement`
*struct · macOS 13.0, iOS 16.0*

The ways that SwiftUI displays search suggestions.  You can influence which modes SwiftUI displays search suggestions for by using the ``View/searchSuggestions(_:for:)`` modifier:      enum FruitSuggestion: String, Identifiable {         case apple, banana, orange         var id: Self { self }     }      @State private var text = ""     @State private var suggestions: [FruitSuggestion] = []      v…

```swift
struct SearchSuggestionsPlacement
```

### `SearchSuggestionsPlacement.Set`
*struct · macOS 13.0, iOS 16.0*

An efficient set of search suggestion display modes.

```swift
struct Set
```

### `SearchSuggestionsPlacement.Set.ArrayLiteralElement`
*typealias · macOS 13.0, iOS 16.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = SearchSuggestionsPlacement.Set.Element
```

### `SearchSuggestionsPlacement.Set.Element`
*typealias · macOS 13.0, iOS 16.0*

A type for the elements of the set.

```swift
typealias Element = SearchSuggestionsPlacement.Set
```

### `SearchSuggestionsPlacement.Set.RawValue`
*typealias · macOS 13.0, iOS 16.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `Settings`
*struct · macOS 11.0*

A scene that presents an interface for viewing and modifying an app's settings.  Use a settings scene to have SwiftUI manage views with controls for your app's settings when you declare your app using the ``App`` protocol. When you use an ``App`` declaration for multiple platforms, compile the settings scene only in macOS:      @main     struct MyApp: App {         var body: some Scene {          …

```swift
struct Settings<Content> where Content : View
```

### `Settings.Body`
*typealias · macOS 11.0*

The type of scene that represents the body of this scene.  When you create a custom scene, Swift infers this type from your implementation of the required ``SwiftUI/Scene/body-swift.property`` property.

```swift
typealias Body = some Scene
```

### `SettingsLink`
*struct · macOS 14.0*

A view that opens the Settings scene defined by an app.  On macOS, clicking on the link opens the window for the scene or orders it to the front if it is already open.

```swift
struct SettingsLink<Label> where Label : View
```

### `SettingsLink.Body`
*typealias · macOS 14.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `ShareLink`
*struct · macOS 13.0, iOS 16.0*

A view that controls a sharing presentation.  People tap or click on a share link to present a share interface. The link typically uses a system-standard appearance; you only need to supply the content to share:      ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!)  You can control the appearance of the link by providing view content. For example, you can use a ``Label``…

```swift
struct ShareLink<Data, PreviewImage, PreviewIcon, Label> where Data : RandomAccessCollection, PreviewImage : Transferable, PreviewIcon : Transferable, Label : View, Data.Element : Transferable
```

### `ShareLink.Body`
*typealias · macOS 13.0, iOS 16.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SharePreview`
*struct · macOS 13.0, iOS 16.0*

A representation of a type to display in a share preview.  Use this type when sharing content that the system can't preview automatically:      struct Photo: Transferable {         static var transferRepresentation: some TransferRepresentation {             ProxyRepresentation(\.image)         }          public var image: Image         public var caption: String     }      struct PhotoView: View {…

```swift
struct SharePreview<Image, Icon> where Image : Transferable, Icon : Transferable
```

### `SidebarCommands`
*struct · macOS 11.0, iOS 14.0*

A built-in set of commands for manipulating window sidebars.  These commands are optional and can be explicitly requested by passing a value of this type to the ``Scene/commands(content:)`` modifier.

```swift
struct SidebarCommands
```

### `SidebarCommands.Body`
*typealias · macOS 11.0, iOS 14.0*

The type of commands that represents the body of this command hierarchy.  When you create custom commands, Swift infers this type from your implementation of the required ``SwiftUI/Commands/body-swift.property`` property.

```swift
typealias Body = some Commands
```

### `SidebarRowSize`
*enum · macOS 13.0, iOS 16.0*

The standard sizes of sidebar rows.  On macOS, sidebar rows have three different sizes: small, medium, and large. The size is primarily controlled by the current users' "Sidebar Icon Size" in Appearance settings, and applies to all applications.  On all other platforms, the only supported sidebar size is `.medium`.  This size can be read or written in the environment using `EnvironmentValues.sideb…

```swift
enum SidebarRowSize
```

### `SpatialEventCollection`
*struct · macOS 15.0, iOS 18.0*

A collection of spatial input events that target a specific view.  You receive a structure of this type as an input to the ``Gesture/onChanged(_:)`` or ``Gesture/onEnded(_:)`` method of a ``SpatialEventGesture``. The structure contains a collection of ``SpatialEventCollection/Event`` values that correspond to ongoing input events. You can look up a specific event in the collection by its ``Spatial…

```swift
struct SpatialEventCollection
```

### `SpatialEventCollection.Element`
*typealias · macOS 15.0, iOS 18.0*

A type representing the sequence's elements.

```swift
typealias Element = SpatialEventCollection.Event
```

### `SpatialEventCollection.Event`
*struct · macOS 15.0, iOS 18.0*

A spatial event generated from an input like a touch or click that can drive gestures in the system.  You receive a collection of these events in the form of a ``SpatialEventCollection`` that's the input to the ``Gesture/onChanged(_:)`` or ``Gesture/onEnded(_:)`` method of a ``SpatialEventGesture``. Inspect individual events to track interactions that enable you to create complex, multi-touch expe…

```swift
struct Event
```

### `SpatialEventCollection.Event.ID`
*struct · macOS 15.0, iOS 18.0*

A value that uniquely identifies an event over the course of its lifetime.

```swift
struct ID
```

### `SpatialEventCollection.Event.InputDevicePose`
*struct · macOS 15.0, iOS 18.0*

A pose describing the input device like a hand controlling the event.

```swift
struct InputDevicePose
```

### `SpatialEventCollection.Event.Kind`
*enum · macOS 15.0, iOS 18.0*

The possible input sources or modes of an event.

```swift
enum Kind
```

### `SpatialEventCollection.Index`
*struct · macOS 15.0, iOS 18.0*

A type that represents a position in the collection.  Valid indices consist of the position of every element and a "past the end" position that's not valid for use as a subscript argument.

```swift
struct Index
```

### `SpatialEventCollection.Indices`
*typealias · macOS 15.0, iOS 18.0*

A type that represents the indices that are valid for subscripting the collection, in ascending order.

```swift
typealias Indices = DefaultIndices<SpatialEventCollection>
```

### `SpatialEventCollection.Iterator`
*struct · macOS 15.0, iOS 18.0*

An iterator over all events in the collection.

```swift
struct Iterator
```

### `SpatialEventCollection.Iterator.Element`
*typealias · macOS 15.0, iOS 18.0*

The type of element traversed by the iterator.

```swift
typealias Element = SpatialEventCollection.Event
```

### `SpatialEventCollection.SubSequence`
*typealias · macOS 15.0, iOS 18.0*

A collection representing a contiguous subrange of this collection's elements. The subsequence shares indices with the original collection.  The default subsequence type for collections that don't define their own is `Slice`.

```swift
typealias SubSequence = Slice<SpatialEventCollection>
```

### `Stepper`
*struct · macOS 10.15, iOS 13.0*

A control that performs increment and decrement actions.  Use a stepper control when you want the user to have granular control while incrementing or decrementing a value. For example, you can use a stepper to:   * Change a value up or down by `1`.  * Operate strictly over a prescribed range.  * Step by specific amounts over a stepper's range of possible values.  The example below uses an array th…

```swift
struct Stepper<Label> where Label : View
```

### `Stepper.Body`
*typealias · macOS 10.15, iOS 13.0*

The type of view representing the body of this view.  When you create a custom view, Swift infers this type from your implementation of the required ``View/body-swift.property`` property.

```swift
typealias Body = some View
```

### `SubmitTriggers`
*struct · macOS 12.0, iOS 15.0*

A type that defines various triggers that result in the firing of a submission action.  These triggers may be provided to the ``View/onSubmit(of:_:)`` modifier to alter which types of user behaviors trigger a provided submission action.

```swift
struct SubmitTriggers
```

### `SubmitTriggers.ArrayLiteralElement`
*typealias · macOS 12.0, iOS 15.0*

The type of the elements of an array literal.

```swift
typealias ArrayLiteralElement = SubmitTriggers
```

### `SubmitTriggers.Element`
*typealias · macOS 12.0, iOS 15.0*

The element type of the option set.  To inherit all the default implementations from the `OptionSet` protocol, the `Element` type must be `Self`, the default.

```swift
typealias Element = SubmitTriggers
```

### `SubmitTriggers.RawValue`
*typealias · macOS 12.0, iOS 15.0*

The raw type that can be used to represent all values of the conforming type.  Every distinct value of the conforming type has a corresponding unique value of the `RawValue` type, but there may be values of the `RawValue` type that don't have a corresponding value of the conforming type.

```swift
typealias RawValue = Int
```

### `TouchBar`
*struct · macOS 10.15*

A container for a view that you can show in the Touch Bar.

```swift
struct TouchBar<Content> where Content : View
```

### `TouchBarItemPresence`
*enum · macOS 10.15*

Options that affect user customization of the Touch Bar.

```swift
enum TouchBarItemPresence
```

### `Widget`
*protocol · macOS 11.0, iOS 14.0*

The configuration and content of a widget to display on the Home screen or in Notification Center.  Widgets show glanceable and relevant content from your app right on the iOS Home screen or in Notification Center on macOS. Users can add, configure, and arrange widgets to suit their individual needs. You can provide multiple types of widgets, each presenting a specific kind of information. When us…

```swift
@MainActor @preconcurrency protocol Widget
```

### `WidgetBundle`
*protocol · macOS 11.0, iOS 14.0*

A container used to expose multiple widgets from a single widget extension.  To support multiple types of widgets, add the `@main` attribute to a structure that conforms to `WidgetBundle`. For example, a game might have one widget to display summary information about the game and a second widget to display detailed information about individual characters.      @main     struct GameWidgets: WidgetB…

```swift
@MainActor @preconcurrency protocol WidgetBundle
```

### `WidgetBundleBuilder`
*struct · macOS 11.0, iOS 14.0*

A custom attribute that constructs a widget bundle's body.  Use the `@WidgetBundleBuilder` attribute to group multiple widgets listed in the ``WidgetBundle/body-swift.property`` property of a widget bundle. For example, the following code defines a widget bundle that consists of two widgets.      @main     struct GameWidgets: WidgetBundle {        @WidgetBundleBuilder        var body: some Widget …

```swift
@resultBuilder struct WidgetBundleBuilder
```

### `WritingToolsBehavior`
*struct · macOS 15.0, iOS 18.0*

The Writing Tools editing experience for text and text input.

```swift
struct WritingToolsBehavior
```
