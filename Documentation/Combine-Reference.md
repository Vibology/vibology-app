# Combine Reference

> Extracted from Xcode 26.2 SDK (macOS 26.2) — 11,568 symbols, 304 types
> **⭐ New** = introduced in macOS/iOS 26

**304 types · 0 new in macOS 26**

---

## All Types

### Protocols

#### `Cancellable`
*macOS 10.15, iOS 13.0*

A protocol indicating that an activity or action supports cancellation.  Calling ``Cancellable/cancel()`` frees up any allocated resources. It also stops side effects such as timers, network access, or disk I/O.

```swift
protocol Cancellable
```

#### `ConnectablePublisher`
*macOS 10.15, iOS 13.0*

A publisher that provides an explicit means of connecting and canceling publication.  Use a ``ConnectablePublisher`` when you need to perform additional configuration or setup prior to producing any elements.  This publisher doesn’t produce any elements until you call its ``ConnectablePublisher/conn

```swift
protocol ConnectablePublisher<Output, Failure> : Publisher
```

#### `CustomCombineIdentifierConvertible`
*macOS 10.15, iOS 13.0*

A protocol for uniquely identifying publisher streams.  If you create a custom ``Subscription`` or ``Subscriber`` type, implement this protocol so that development tools can uniquely identify publisher chains in your app. If your type is a class, Combine provides an implementation of ``CustomCombine

```swift
protocol CustomCombineIdentifierConvertible
```

#### `ObservableObject`
*macOS 10.15, iOS 13.0*

A type of object with a publisher that emits before the object has changed.  By default an ``ObservableObject`` synthesizes an ``ObservableObject/objectWillChange-2oa5v`` publisher that emits the changed value before any of its `@Published` properties changes.      class Contact: ObservableObject { 

```swift
protocol ObservableObject : AnyObject
```

#### `Publisher`
*macOS 10.15, iOS 13.0*

Declares that a type can transmit a sequence of values over time.  A publisher delivers elements to one or more ``Subscriber`` instances. The subscriber’s ``Subscriber/Input`` and ``Subscriber/Failure`` associated types must match the ``Publisher/Output`` and ``Publisher/Failure`` types declared by 

```swift
protocol Publisher<Output, Failure>
```

#### `Scheduler`
*macOS 10.15, iOS 13.0*

A protocol that defines when and how to execute a closure.  You can use a scheduler to execute code as soon as possible, or after a future date. Individual scheduler implementations use whatever time-keeping system makes sense for them. Schedulers express this as their `SchedulerTimeType`. Since thi

```swift
protocol Scheduler<SchedulerTimeType>
```

#### `SchedulerTimeIntervalConvertible`
*macOS 10.15, iOS 13.0*

A protocol that provides a scheduler with an expression for relative time.

```swift
protocol SchedulerTimeIntervalConvertible
```

#### `Subject`
*macOS 10.15, iOS 13.0*

A publisher that exposes a method for outside callers to publish elements.  A subject is a publisher that you can use to ”inject” values into a stream, by calling its ``Subject/send(_:)`` method. This can be useful for adapting existing imperative code to the Combine model.

```swift
protocol Subject<Output, Failure> : AnyObject, Publisher
```

#### `Subscriber`
*macOS 10.15, iOS 13.0*

A protocol that declares a type that can receive input from a publisher.  A ``Subscriber`` instance receives a stream of elements from a ``Publisher``, along with life cycle events describing changes to their relationship. A given subscriber’s ``Subscriber/Input`` and ``Subscriber/Failure`` associat

```swift
protocol Subscriber<Input, Failure> : CustomCombineIdentifierConvertible
```

#### `Subscription`
*macOS 10.15, iOS 13.0*

A protocol representing the connection of a subscriber to a publisher.  Subscriptions are class constrained because a ``Subscription`` has identity, defined by the moment in time a particular subscriber attached to a publisher. Canceling a ``Subscription`` must be thread-safe.  You can only cancel a

```swift
protocol Subscription : Cancellable, CustomCombineIdentifierConvertible
```

#### `TopLevelDecoder`
*macOS 10.15, iOS 13.0*

A type that defines methods for decoding.

```swift
protocol TopLevelDecoder
```

#### `TopLevelEncoder`
*macOS 10.15, iOS 13.0*

A type that defines methods for encoding.

```swift
protocol TopLevelEncoder
```

### Structs

#### `AnyPublisher`
*macOS 10.15, iOS 13.0*

A publisher that performs type erasure by wrapping another publisher.  ``AnyPublisher`` is a concrete implementation of ``Publisher`` that has no significant properties of its own, and passes through elements and completion values from its upstream publisher.  Use ``AnyPublisher`` to wrap a publishe

```swift
@frozen struct AnyPublisher<Output, Failure> where Failure : Error
```

#### `AnySubscriber`
*macOS 10.15, iOS 13.0*

A type-erasing subscriber.  Use an ``AnySubscriber`` to wrap an existing subscriber whose details you don’t want to expose. You can also use ``AnySubscriber`` to create a custom subscriber by providing closures for the methods defined in ``Subscriber``, rather than implementing ``Subscriber`` direct

```swift
@frozen struct AnySubscriber<Input, Failure> where Failure : Error
```

#### `AsyncPublisher`
*macOS 12.0, iOS 15.0*

A publisher that exposes its elements as an asynchronous sequence.  `AsyncPublisher` conforms to <doc://com.apple.documentation/documentation/Swift/AsyncSequence>, which allows callers to receive values with the `for`-`await`-`in` syntax, rather than attaching a ``Subscriber``.  Use the ``Combine/Pu

```swift
struct AsyncPublisher<P> where P : Publisher, P.Failure == Never
```

#### `AsyncPublisher.Iterator`
*macOS 12.0, iOS 15.0*

The iterator that produces elements of the asynchronous publisher sequence.

```swift
struct Iterator
```

#### `AsyncThrowingPublisher`
*macOS 12.0, iOS 15.0*

A publisher that exposes its elements as a throwing asynchronous sequence.  `AsyncThrowingPublisher` conforms to <doc://com.apple.documentation/documentation/Swift/AsyncSequence>, which allows callers to receive values with the `for`-`await`-`in` syntax, rather than attaching a ``Subscriber``. If th

```swift
struct AsyncThrowingPublisher<P> where P : Publisher
```

#### `AsyncThrowingPublisher.Iterator`
*macOS 12.0, iOS 15.0*

The iterator that produces elements of the asynchronous publisher sequence.

```swift
struct Iterator
```

#### `CombineIdentifier`
*macOS 10.15, iOS 13.0*

A unique identifier for identifying publisher streams.  To conform to ``CustomCombineIdentifierConvertible`` in a ``Subscription`` or ``Subject`` that you implement as a structure, create an instance of ``CombineIdentifier`` as follows:      let combineIdentifier = CombineIdentifier()

```swift
struct CombineIdentifier
```

#### `Deferred`
*macOS 10.15, iOS 13.0*

A publisher that awaits subscription before running the supplied closure to create a publisher for the new subscriber.

```swift
struct Deferred<DeferredPublisher> where DeferredPublisher : Publisher
```

#### `Empty`
*macOS 10.15, iOS 13.0*

A publisher that never publishes any values, and optionally finishes immediately.  You can create a ”Never” publisher — one which never sends values and never finishes or fails — with the initializer `Empty(completeImmediately: false)`.

```swift
struct Empty<Output, Failure> where Failure : Error
```

#### `Fail`
*macOS 10.15, iOS 13.0*

A publisher that immediately terminates with the specified error.

```swift
struct Fail<Output, Failure> where Failure : Error
```

#### `ImmediateScheduler`
*macOS 10.15, iOS 13.0*

A scheduler for performing synchronous actions.  You can only use this scheduler for immediate actions. If you attempt to schedule actions after a specific date, this scheduler ignores the date and performs them immediately.

```swift
struct ImmediateScheduler
```

#### `ImmediateScheduler.SchedulerTimeType`
*macOS 10.15, iOS 13.0*

The time type used by the immediate scheduler.

```swift
struct SchedulerTimeType
```

#### `ImmediateScheduler.SchedulerTimeType.Stride`
*macOS 10.15, iOS 13.0*

The increment by which the immediate scheduler counts time.

```swift
struct Stride
```

#### `Just`
*macOS 10.15, iOS 13.0*

A publisher that emits an output to each subscriber just once, and then finishes.  You can use a ``Just`` publisher to start a chain of publishers. A ``Just`` publisher is also useful when replacing a value with ``Publishers/Catch``.  In contrast with <doc://com.apple.documentation/documentation/Swi

```swift
struct Just<Output>
```

#### `Published`
*macOS 10.15, iOS 13.0*

A type that publishes a property marked with an attribute.  Publishing a property with the `@Published` attribute creates a publisher of this type. You access the publisher with the `$` operator, as shown here:      class Weather {         @Published var temperature: Double         init(temperature:

```swift
@propertyWrapper struct Published<Value>
```

#### `Published.Publisher`
*macOS 10.15, iOS 13.0*

A publisher for properties marked with the `@Published` attribute.

```swift
struct Publisher
```

#### `Publishers.AllSatisfy`
*macOS 10.15, iOS 13.0*

A publisher that publishes a single Boolean value that indicates whether all received elements pass a given predicate.

```swift
struct AllSatisfy<Upstream> where Upstream : Publisher
```

#### `Publishers.AssertNoFailure`
*macOS 10.15, iOS 13.0*

A publisher that raises a fatal error upon receiving any failure, and otherwise republishes all received input.  Use this function for internal integrity checks that are active during testing but don't affect performance of shipping code.

```swift
struct AssertNoFailure<Upstream> where Upstream : Publisher
```

#### `Publishers.Breakpoint`
*macOS 10.15, iOS 13.0*

A publisher that raises a debugger signal when a provided closure needs to stop the process in the debugger.  When any of the provided closures returns `true`, this publisher raises the `SIGTRAP` signal to stop the process in the debugger. Otherwise, this publisher passes through values and completi

```swift
struct Breakpoint<Upstream> where Upstream : Publisher
```

#### `Publishers.Buffer`
*macOS 10.15, iOS 13.0*

A publisher that buffers elements from an upstream publisher.

```swift
struct Buffer<Upstream> where Upstream : Publisher
```

#### `Publishers.Catch`
*macOS 10.15, iOS 13.0*

A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.

```swift
struct Catch<Upstream, NewPublisher> where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output
```

#### `Publishers.Collect`
*macOS 10.15, iOS 13.0*

A publisher that buffers items.

```swift
struct Collect<Upstream> where Upstream : Publisher
```

#### `Publishers.CollectByCount`
*macOS 10.15, iOS 13.0*

A publisher that buffers a maximum number of items.

```swift
struct CollectByCount<Upstream> where Upstream : Publisher
```

#### `Publishers.CollectByTime`
*macOS 10.15, iOS 13.0*

A publisher that buffers and periodically publishes its items.

```swift
struct CollectByTime<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.CombineLatest`
*macOS 10.15, iOS 13.0*

A publisher that receives and combines the latest elements from two publishers.

```swift
struct CombineLatest<A, B> where A : Publisher, B : Publisher, A.Failure == B.Failure
```

#### `Publishers.CombineLatest3`
*macOS 10.15, iOS 13.0*

A publisher that receives and combines the latest elements from three publishers.

```swift
struct CombineLatest3<A, B, C> where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure
```

#### `Publishers.CombineLatest4`
*macOS 10.15, iOS 13.0*

A publisher that receives and combines the latest elements from four publishers.

```swift
struct CombineLatest4<A, B, C, D> where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure
```

#### `Publishers.CompactMap`
*macOS 10.15, iOS 13.0*

A publisher that republishes all non-nil results of calling a closure with each received element.

```swift
struct CompactMap<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.Comparison`
*macOS 10.15, iOS 13.0*

A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item.

```swift
struct Comparison<Upstream> where Upstream : Publisher
```

#### `Publishers.Concatenate`
*macOS 10.15, iOS 13.0*

A publisher that emits all of one publisher’s elements before those from another publisher.

```swift
struct Concatenate<Prefix, Suffix> where Prefix : Publisher, Suffix : Publisher, Prefix.Failure == Suffix.Failure, Prefix.Output == Suffix.Output
```

#### `Publishers.Contains`
*macOS 10.15, iOS 13.0*

A publisher that emits a Boolean value when it receives a specific element from its upstream publisher.

```swift
struct Contains<Upstream> where Upstream : Publisher, Upstream.Output : Equatable
```

#### `Publishers.ContainsWhere`
*macOS 10.15, iOS 13.0*

A publisher that emits a Boolean value upon receiving an element that satisfies the predicate closure.

```swift
struct ContainsWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.Count`
*macOS 10.15, iOS 13.0*

A publisher that publishes the number of elements received from the upstream publisher.

```swift
struct Count<Upstream> where Upstream : Publisher
```

#### `Publishers.Debounce`
*macOS 10.15, iOS 13.0*

A publisher that publishes elements only after a specified time interval elapses between events.

```swift
struct Debounce<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.Decode`
*macOS 10.15, iOS 13.0*

A publisher that decodes elements received from an upstream publisher, using a given decoder.

```swift
struct Decode<Upstream, Output, Coder> where Upstream : Publisher, Output : Decodable, Coder : TopLevelDecoder, Upstream.Output == Coder.Input
```

#### `Publishers.Delay`
*macOS 10.15, iOS 13.0*

A publisher that delays delivery of elements and completion to the downstream receiver.

```swift
struct Delay<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.Drop`
*macOS 10.15, iOS 13.0*

A publisher that omits a specified number of elements before republishing later elements.

```swift
struct Drop<Upstream> where Upstream : Publisher
```

#### `Publishers.DropUntilOutput`
*macOS 10.15, iOS 13.0*

A publisher that ignores elements from the upstream publisher until it receives an element from second publisher.

```swift
struct DropUntilOutput<Upstream, Other> where Upstream : Publisher, Other : Publisher, Upstream.Failure == Other.Failure
```

#### `Publishers.DropWhile`
*macOS 10.15, iOS 13.0*

A publisher that omits elements from an upstream publisher until a given closure returns false.

```swift
struct DropWhile<Upstream> where Upstream : Publisher
```

#### `Publishers.Encode`
*macOS 10.15, iOS 13.0*

A publisher that encodes elements received from an upstream publisher, using a given encoder.

```swift
struct Encode<Upstream, Coder> where Upstream : Publisher, Coder : TopLevelEncoder, Upstream.Output : Encodable
```

#### `Publishers.Filter`
*macOS 10.15, iOS 13.0*

A publisher that republishes all elements that match a provided closure.

```swift
struct Filter<Upstream> where Upstream : Publisher
```

#### `Publishers.First`
*macOS 10.15, iOS 13.0*

A publisher that publishes the first element of a stream, then finishes.

```swift
struct First<Upstream> where Upstream : Publisher
```

#### `Publishers.FirstWhere`
*macOS 10.15, iOS 13.0*

A publisher that only publishes the first element of a stream to satisfy a predicate closure.

```swift
struct FirstWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.FlatMap`
*macOS 10.15, iOS 13.0*

A publisher that transforms elements from an upstream publisher into a new publisher.

```swift
struct FlatMap<NewPublisher, Upstream> where NewPublisher : Publisher, Upstream : Publisher, NewPublisher.Failure == Upstream.Failure
```

#### `Publishers.HandleEvents`
*macOS 10.15, iOS 13.0*

A publisher that performs the specified closures when publisher events occur.

```swift
struct HandleEvents<Upstream> where Upstream : Publisher
```

#### `Publishers.IgnoreOutput`
*macOS 10.15, iOS 13.0*

A publisher that ignores all upstream elements, but passes along the upstream publisher's completion state (finished or failed).

```swift
struct IgnoreOutput<Upstream> where Upstream : Publisher
```

#### `Publishers.Last`
*macOS 10.15, iOS 13.0*

A publisher that waits until after the stream finishes, and then publishes the last element of the stream.

```swift
struct Last<Upstream> where Upstream : Publisher
```

#### `Publishers.LastWhere`
*macOS 10.15, iOS 13.0*

A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies a predicate closure.

```swift
struct LastWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.MakeConnectable`
*macOS 10.15, iOS 13.0*

A publisher that provides explicit connectability to another publisher.  ``Publishers/MakeConnectable`` is a ``ConnectablePublisher``, which allows you to perform configuration before publishing any elements. Call ``ConnectablePublisher/connect()`` on this publisher when you want to attach to its up

```swift
struct MakeConnectable<Upstream> where Upstream : Publisher
```

#### `Publishers.Map`
*macOS 10.15, iOS 13.0*

A publisher that transforms all elements from the upstream publisher with a provided closure.

```swift
struct Map<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.MapError`
*macOS 10.15, iOS 13.0*

A publisher that converts any failure from the upstream publisher into a new error.

```swift
struct MapError<Upstream, Failure> where Upstream : Publisher, Failure : Error
```

#### `Publishers.MapKeyPath`
*macOS 10.15, iOS 13.0*

A publisher that publishes the value of a key path.

```swift
struct MapKeyPath<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.MapKeyPath2`
*macOS 10.15, iOS 13.0*

A publisher that publishes the values of two key paths as a tuple.

```swift
struct MapKeyPath2<Upstream, Output0, Output1> where Upstream : Publisher
```

#### `Publishers.MapKeyPath3`
*macOS 10.15, iOS 13.0*

A publisher that publishes the values of three key paths as a tuple.

```swift
struct MapKeyPath3<Upstream, Output0, Output1, Output2> where Upstream : Publisher
```

#### `Publishers.MeasureInterval`
*macOS 10.15, iOS 13.0*

A publisher that measures and emits the time interval between events received from an upstream publisher.

```swift
struct MeasureInterval<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.Merge`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to two upstream publishers.

```swift
struct Merge<A, B> where A : Publisher, B : Publisher, A.Failure == B.Failure, A.Output == B.Output
```

#### `Publishers.Merge3`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to three upstream publishers.

```swift
struct Merge3<A, B, C> where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output
```

#### `Publishers.Merge4`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to four upstream publishers.

```swift
struct Merge4<A, B, C, D> where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, A.Output == B.Output, B.Failure == C.Failure, B.Output == C.Output, C.Failure == D.Failure, C.Output == D.Output
```

#### `Publishers.Merge5`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to five upstream publishers.

#### `Publishers.Merge6`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to six upstream publishers.

#### `Publishers.Merge7`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to seven upstream publishers.

#### `Publishers.Merge8`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to eight upstream publishers.

#### `Publishers.MergeMany`
*macOS 10.15, iOS 13.0*

A publisher created by applying the merge function to an arbitrary number of upstream publishers.

```swift
struct MergeMany<Upstream> where Upstream : Publisher
```

#### `Publishers.Output`
*macOS 10.15, iOS 13.0*

A publisher that publishes elements specified by a range in the sequence of published elements.

```swift
struct Output<Upstream> where Upstream : Publisher
```

#### `Publishers.PrefixUntilOutput`
*macOS 10.15, iOS 13.0*

A publisher that republishes elements until another publisher emits an element.

```swift
struct PrefixUntilOutput<Upstream, Other> where Upstream : Publisher, Other : Publisher
```

#### `Publishers.PrefixWhile`
*macOS 10.15, iOS 13.0*

A publisher that republishes elements while a predicate closure indicates publishing should continue.

```swift
struct PrefixWhile<Upstream> where Upstream : Publisher
```

#### `Publishers.Print`
*macOS 10.15, iOS 13.0*

A publisher that prints log messages for all publishing events, optionally prefixed with a given string.  This publisher prints log messages when receiving the following events:  - subscription - value - normal completion - failure - cancellation

```swift
struct Print<Upstream> where Upstream : Publisher
```

#### `Publishers.ReceiveOn`
*macOS 10.15, iOS 13.0*

A publisher that delivers elements to its downstream subscriber on a specific scheduler.

```swift
struct ReceiveOn<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.Reduce`
*macOS 10.15, iOS 13.0*

A publisher that applies a closure to all received elements and produces an accumulated value when the upstream publisher finishes.

```swift
struct Reduce<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.RemoveDuplicates`
*macOS 10.15, iOS 13.0*

A publisher that publishes only elements that don’t match the previous element.

```swift
struct RemoveDuplicates<Upstream> where Upstream : Publisher
```

#### `Publishers.ReplaceEmpty`
*macOS 10.15, iOS 13.0*

A publisher that replaces an empty stream with a provided element.

```swift
struct ReplaceEmpty<Upstream> where Upstream : Publisher
```

#### `Publishers.ReplaceError`
*macOS 10.15, iOS 13.0*

A publisher that replaces any errors in the stream with a provided element.

```swift
struct ReplaceError<Upstream> where Upstream : Publisher
```

#### `Publishers.Retry`
*macOS 10.15, iOS 13.0*

A publisher that attempts to recreate its subscription to a failed upstream publisher.

```swift
struct Retry<Upstream> where Upstream : Publisher
```

#### `Publishers.Scan`
*macOS 10.15, iOS 13.0*

A publisher that transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.

```swift
struct Scan<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.Sequence`
*macOS 10.15, iOS 13.0*

A publisher that publishes a given sequence of elements.  When the publisher exhausts the elements in the sequence, the next request causes the publisher to finish.

```swift
struct Sequence<Elements, Failure> where Elements : Sequence, Failure : Error
```

#### `Publishers.SetFailureType`
*macOS 10.15, iOS 13.0*

A publisher that appears to send a specified failure type.  The publisher can't actually fail with the specified type and finishes normally. Use this publisher type when you need to match the error types for two mismatched publishers.

```swift
struct SetFailureType<Upstream, Failure> where Upstream : Publisher, Failure : Error, Upstream.Failure == Never
```

#### `Publishers.SubscribeOn`
*macOS 10.15, iOS 13.0*

A publisher that receives elements from an upstream publisher on a specific scheduler.

```swift
struct SubscribeOn<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.SwitchToLatest`
*macOS 10.15, iOS 13.0*

A publisher that flattens nested publishers.  Given a publisher that publishes ``Publisher`` instances, the ``Publishers/SwitchToLatest`` publisher produces a sequence of events from only the most recent one. For example, given the type `AnyPublisher<URLSession.DataTaskPublisher, NSError>`, calling 

```swift
struct SwitchToLatest<P, Upstream> where P : Publisher, P == Upstream.Output, Upstream : Publisher, P.Failure == Upstream.Failure
```

#### `Publishers.Throttle`
*macOS 10.15, iOS 13.0*

A publisher that publishes either the most-recent or first element published by the upstream publisher in a specified time interval.

```swift
struct Throttle<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.Timeout`
*macOS 10.15, iOS 13.0*

A publisher that terminates publishing if the upstream publisher exceeds a specified time interval without producing an element.

```swift
struct Timeout<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```

#### `Publishers.TryAllSatisfy`
*macOS 10.15, iOS 13.0*

A publisher that publishes a single Boolean value that indicates whether all received elements pass a given error-throwing predicate.

```swift
struct TryAllSatisfy<Upstream> where Upstream : Publisher
```

#### `Publishers.TryCatch`
*macOS 10.15, iOS 13.0*

A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher or producing a new error.  Because this publisher’s handler can throw an error, ``Publishers/TryCatch`` defines its ``Publisher/Failure`` type as `Error`. This is different from ``Publ

```swift
struct TryCatch<Upstream, NewPublisher> where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output
```

#### `Publishers.TryCompactMap`
*macOS 10.15, iOS 13.0*

A publisher that republishes all non-nil results of calling an error-throwing closure with each received element.

```swift
struct TryCompactMap<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.TryComparison`
*macOS 10.15, iOS 13.0*

A publisher that republishes items from another publisher only if each new item is in increasing order from the previously-published item, and fails if the ordering logic throws an error.

```swift
struct TryComparison<Upstream> where Upstream : Publisher
```

#### `Publishers.TryContainsWhere`
*macOS 10.15, iOS 13.0*

A publisher that emits a Boolean value upon receiving an element that satisfies the throwing predicate closure.

```swift
struct TryContainsWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.TryDropWhile`
*macOS 10.15, iOS 13.0*

A publisher that omits elements from an upstream publisher until a given error-throwing closure returns false.

```swift
struct TryDropWhile<Upstream> where Upstream : Publisher
```

#### `Publishers.TryFilter`
*macOS 10.15, iOS 13.0*

A publisher that republishes all elements that match a provided error-throwing closure.

```swift
struct TryFilter<Upstream> where Upstream : Publisher
```

#### `Publishers.TryFirstWhere`
*macOS 10.15, iOS 13.0*

A publisher that only publishes the first element of a stream to satisfy a throwing predicate closure.

```swift
struct TryFirstWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.TryLastWhere`
*macOS 10.15, iOS 13.0*

A publisher that waits until after the stream finishes and then publishes the last element of the stream that satisfies an error-throwing predicate closure.

```swift
struct TryLastWhere<Upstream> where Upstream : Publisher
```

#### `Publishers.TryMap`
*macOS 10.15, iOS 13.0*

A publisher that transforms all elements from the upstream publisher with a provided error-throwing closure.

```swift
struct TryMap<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.TryPrefixWhile`
*macOS 10.15, iOS 13.0*

A publisher that republishes elements while an error-throwing predicate closure indicates publishing should continue.

```swift
struct TryPrefixWhile<Upstream> where Upstream : Publisher
```

#### `Publishers.TryReduce`
*macOS 10.15, iOS 13.0*

A publisher that applies an error-throwing closure to all received elements and produces an accumulated value when the upstream publisher finishes.

```swift
struct TryReduce<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.TryRemoveDuplicates`
*macOS 10.15, iOS 13.0*

A publisher that publishes only elements that don’t match the previous element, as evaluated by a provided error-throwing closure.

```swift
struct TryRemoveDuplicates<Upstream> where Upstream : Publisher
```

#### `Publishers.TryScan`
*macOS 10.15, iOS 13.0*

A publisher that transforms elements from the upstream publisher by providing the current element to a failable closure along with the last value returned by the closure.

```swift
struct TryScan<Upstream, Output> where Upstream : Publisher
```

#### `Publishers.Zip`
*macOS 10.15, iOS 13.0*

A publisher created by applying the zip function to two upstream publishers.  Use `Publishers.Zip` to combine the latest elements from two publishers and emit a tuple to the downstream. The returned publisher waits until both publishers have emitted an event, then delivers the oldest unconsumed even

```swift
struct Zip<A, B> where A : Publisher, B : Publisher, A.Failure == B.Failure
```

#### `Publishers.Zip3`
*macOS 10.15, iOS 13.0*

A publisher created by applying the zip function to three upstream publishers.  Use a `Publishers.Zip3` to combine the latest elements from three publishers and emit a tuple to the downstream. The returned publisher waits until all three publishers have emitted an event, then delivers the oldest unc

```swift
struct Zip3<A, B, C> where A : Publisher, B : Publisher, C : Publisher, A.Failure == B.Failure, B.Failure == C.Failure
```

#### `Publishers.Zip4`
*macOS 10.15, iOS 13.0*

A publisher created by applying the zip function to four upstream publishers.  Use a `Publishers.Zip4` to combine the latest elements from four publishers and emit a tuple to the downstream. The returned publisher waits until all four publishers have emitted an event, then delivers the oldest uncons

```swift
struct Zip4<A, B, C, D> where A : Publisher, B : Publisher, C : Publisher, D : Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure
```

#### `Record`
*macOS 10.15, iOS 13.0*

A publisher that allows for recording a series of inputs and a completion, for later playback to each subscriber.

```swift
struct Record<Output, Failure> where Failure : Error
```

#### `Record.Recording`
*macOS 10.15, iOS 13.0*

A recorded sequence of outputs, followed by a completion value.

```swift
struct Recording
```

#### `Subscribers.Demand`
*macOS 10.15, iOS 13.0*

A requested number of items, sent to a publisher from a subscriber through the subscription.

```swift
@frozen struct Demand
```

### Classes

#### `AnyCancellable`
*macOS 10.15, iOS 13.0*

A type-erasing cancellable object that executes a provided closure when canceled.  Subscriber implementations can use this type to provide a “cancellation token” that makes it possible for a caller to cancel a publisher, but not to use the ``Subscription`` object to request items.  An ``AnyCancellab

```swift
final class AnyCancellable
```

#### `CurrentValueSubject`
*macOS 10.15, iOS 13.0*

A subject that wraps a single value and publishes a new element whenever the value changes.  Unlike ``PassthroughSubject``, ``CurrentValueSubject`` maintains a buffer of the most recently published element.  Calling ``CurrentValueSubject/send(_:)`` on a ``CurrentValueSubject`` also updates the curre

```swift
final class CurrentValueSubject<Output, Failure> where Failure : Error
```

#### `Future`
*macOS 10.15, iOS 13.0*

A publisher that eventually produces a single value and then finishes or fails.  Use a future to perform some work and then asynchronously publish a single element. You initialize the future with a closure that takes a ``Combine/Future/Promise``; the closure calls the promise with a <doc://com.apple

```swift
final class Future<Output, Failure> where Failure : Error
```

#### `ObservableObjectPublisher`
*macOS 10.15, iOS 13.0*

A publisher that publishes changes from observable objects.

```swift
final class ObservableObjectPublisher
```

#### `PassthroughSubject`
*macOS 10.15, iOS 13.0*

A subject that broadcasts elements to downstream subscribers.  As a concrete implementation of ``Subject``, the ``PassthroughSubject`` provides a convenient way to adapt existing imperative code to the Combine model.  Unlike ``CurrentValueSubject``, a ``PassthroughSubject`` doesn’t have an initial v

```swift
final class PassthroughSubject<Output, Failure> where Failure : Error
```

#### `Publishers.Autoconnect`
*macOS 10.15, iOS 13.0*

A publisher that automatically connects to an upstream connectable publisher.  This publisher calls ``ConnectablePublisher/connect()`` on the upstream ``ConnectablePublisher`` when first attached to by a subscriber.

```swift
class Autoconnect<Upstream> where Upstream : ConnectablePublisher
```

#### `Publishers.Multicast`
*macOS 10.15, iOS 13.0*

A publisher that uses a subject to deliver elements to multiple subscribers.  Use a multicast publisher when you have multiple downstream subscribers, but you want upstream publishers to only process one ``Subscriber/receive(_:)`` call per event.

```swift
final class Multicast<Upstream, SubjectType> where Upstream : Publisher, SubjectType : Subject, Upstream.Failure == SubjectType.Failure, Upstream.Output == SubjectType.Output
```

#### `Publishers.Share`
*macOS 10.15, iOS 13.0*

A publisher that shares the output of an upstream publisher with multiple subscribers.  This publisher type supports multiple subscribers, all of whom receive unchanged elements and completion states from the upstream publisher.   > Tip: ``Publishers/Share`` is effectively a combination of the ``Pub

```swift
final class Share<Upstream> where Upstream : Publisher
```

#### `Subscribers.Assign`
*macOS 10.15, iOS 13.0*

A simple subscriber that assigns received elements to a property indicated by a key path.

```swift
final class Assign<Root, Input>
```

#### `Subscribers.Sink`
*macOS 10.15, iOS 13.0*

A simple subscriber that requests an unlimited number of values upon subscription.

```swift
final class Sink<Input, Failure> where Failure : Error
```

### Enums

#### `Publishers`
*macOS 10.15, iOS 13.0*

A namespace for types that serve as publishers.  The various operators defined as extensions on ``Publisher`` implement their functionality as classes or structures that extend this enumeration. For example, the `contains(_:)` operator returns a `Publishers.Contains` instance.

```swift
enum Publishers
```

#### `Publishers.BufferingStrategy`
*macOS 10.15, iOS 13.0*

A strategy that handles exhaustion of a buffer’s capacity.

```swift
enum BufferingStrategy<Failure> where Failure : Error
```

#### `Publishers.PrefetchStrategy`
*macOS 10.15, iOS 13.0*

A strategy for filling a buffer.

```swift
enum PrefetchStrategy
```

#### `Publishers.TimeGroupingStrategy`
*macOS 10.15, iOS 13.0*

A strategy for collecting received elements.

```swift
enum TimeGroupingStrategy<Context> where Context : Scheduler
```

#### `Subscribers`
*macOS 10.15, iOS 13.0*

A namespace for types that serve as subscribers.

```swift
enum Subscribers
```

#### `Subscribers.Completion`
*macOS 10.15, iOS 13.0*

A signal that a publisher doesn’t produce additional elements, either due to normal completion or an error.

```swift
@frozen enum Completion<Failure> where Failure : Error
```

#### `Subscriptions`
*macOS 10.15, iOS 13.0*

A namespace for symbols related to subscriptions.

```swift
enum Subscriptions
```

### Type Aliases

#### `AsyncPublisher.AsyncIterator`
*macOS 12.0, iOS 15.0*

The type of asynchronous iterator that produces elements of this asynchronous sequence.

```swift
typealias AsyncIterator = AsyncPublisher<P>.Iterator
```

#### `AsyncPublisher.Element`
*macOS 12.0, iOS 15.0*

The type of element produced by this asynchronous sequence.

```swift
typealias Element = P.Output
```

#### `AsyncPublisher.Iterator.Element`
*macOS 12.0, iOS 15.0*

```swift
typealias Element = P.Output
```

#### `AsyncThrowingPublisher.AsyncIterator`
*macOS 12.0, iOS 15.0*

The type of asynchronous iterator that produces elements of this asynchronous sequence.

```swift
typealias AsyncIterator = AsyncThrowingPublisher<P>.Iterator
```

#### `AsyncThrowingPublisher.Element`
*macOS 12.0, iOS 15.0*

The type of element produced by this asynchronous sequence.

```swift
typealias Element = P.Output
```

#### `AsyncThrowingPublisher.Iterator.Element`
*macOS 12.0, iOS 15.0*

```swift
typealias Element = P.Output
```

#### `Deferred.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.

```swift
typealias Failure = DeferredPublisher.Failure
```

#### `Deferred.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.

```swift
typealias Output = DeferredPublisher.Output
```

#### `Future.Promise`
*macOS 10.15, iOS 13.0*

A type that represents a closure to invoke in the future, when an element or error is available.  The promise closure receives one parameter: a `Result` that contains either a single element published by a ``Future``, or an error.

```swift
typealias Promise = (Result<Output, Failure>) -> Void
```

#### `ImmediateScheduler.SchedulerOptions`
*macOS 10.15, iOS 13.0*

A type that defines options accepted by the immediate scheduler.

```swift
typealias SchedulerOptions = Never
```

#### `ImmediateScheduler.SchedulerTimeType.Stride.FloatLiteralType`
*macOS 10.15, iOS 13.0*

The type used when evaluating floating-point literals.

```swift
typealias FloatLiteralType = Double
```

#### `ImmediateScheduler.SchedulerTimeType.Stride.IntegerLiteralType`
*macOS 10.15, iOS 13.0*

The type used when evaluating integer literals.

```swift
typealias IntegerLiteralType = Int
```

#### `ImmediateScheduler.SchedulerTimeType.Stride.Magnitude`
*macOS 10.15, iOS 13.0*

The type used for expressing the stride’s magnitude.

```swift
typealias Magnitude = Int
```

#### `Just.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  Use `Never` if this `Publisher` does not publish errors.

```swift
typealias Failure = Never
```

#### `ObservableObjectPublisher.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  Use `Never` if this `Publisher` does not publish errors.

```swift
typealias Failure = Never
```

#### `ObservableObjectPublisher.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.

```swift
typealias Output = Void
```

#### `Published.Publisher.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  Use `Never` if this `Publisher` does not publish errors.

```swift
typealias Failure = Never
```

#### `Published.Publisher.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.

```swift
typealias Output = Value
```

#### `Publishers.AllSatisfy.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.AllSatisfy.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces Boolean elements.

```swift
typealias Output = Bool
```

#### `Publishers.AssertNoFailure.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher never produces errors.

```swift
typealias Failure = Never
```

#### `Publishers.AssertNoFailure.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Autoconnect.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Autoconnect.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstram publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Breakpoint.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Breakpoint.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Buffer.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Buffer.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Catch.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses the replacement publisher's failure type.

```swift
typealias Failure = NewPublisher.Failure
```

#### `Publishers.Catch.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Collect.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Collect.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher publishes arrays of its upstream publisher's output type.

```swift
typealias Output = [Upstream.Output]
```

#### `Publishers.CollectByCount.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.CollectByCount.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher publishes arrays of its upstream publisher's output type.

```swift
typealias Output = [Upstream.Output]
```

#### `Publishers.CollectByTime.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.CollectByTime.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher publishes arrays of its upstream publisher's output type.

```swift
typealias Output = [Upstream.Output]
```

#### `Publishers.CombineLatest.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the failure type shared by its upstream publishers.

```swift
typealias Failure = A.Failure
```

#### `Publishers.CombineLatest.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces two-element tuples of the upstream publishers' output types.

```swift
typealias Output = (A.Output, B.Output)
```

#### `Publishers.CombineLatest3.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the failure type shared by its upstream publishers.

```swift
typealias Failure = A.Failure
```

#### `Publishers.CombineLatest3.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces three-element tuples of the upstream publishers' output types.

```swift
typealias Output = (A.Output, B.Output, C.Output)
```

#### `Publishers.CombineLatest4.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the failure type shared by its upstream publishers.

```swift
typealias Failure = A.Failure
```

#### `Publishers.CombineLatest4.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces four-element tuples of the upstream publishers' output types.

```swift
typealias Output = (A.Output, B.Output, C.Output, D.Output)
```

#### `Publishers.CompactMap.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Comparison.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Comparison.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upsteam publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Concatenate.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its source publishers' failure type.

```swift
typealias Failure = Suffix.Failure
```

#### `Publishers.Concatenate.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its source publishers' output type.

```swift
typealias Output = Suffix.Output
```

#### `Publishers.Contains.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Contains.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces Boolean elements.

```swift
typealias Output = Bool
```

#### `Publishers.ContainsWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.ContainsWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces Boolean elements.

```swift
typealias Output = Bool
```

#### `Publishers.Count.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Count.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces integer elements.

```swift
typealias Output = Int
```

#### `Publishers.Debounce.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Debounce.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Decode.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.Delay.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Delay.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Drop.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Drop.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.DropUntilOutput.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.DropUntilOutput.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.DropWhile.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.DropWhile.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Encode.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.Encode.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses the encoder's output type.

```swift
typealias Output = Coder.Output
```

#### `Publishers.Filter.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Filter.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.First.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.First.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.FirstWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.FirstWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.FlatMap.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.FlatMap.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses the output type declared by the new publisher.

```swift
typealias Output = NewPublisher.Output
```

#### `Publishers.HandleEvents.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.HandleEvents.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.IgnoreOutput.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.IgnoreOutput.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher never produces elements.

```swift
typealias Output = Never
```

#### `Publishers.Last.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Last.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.LastWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.LastWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.MakeConnectable.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MakeConnectable.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Map.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MapError.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.MapKeyPath.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MapKeyPath2.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MapKeyPath2.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces two-element tuples, where each menber's type matches the type of the corresponding key path's property.

```swift
typealias Output = (Output0, Output1)
```

#### `Publishers.MapKeyPath3.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MapKeyPath3.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces three-element tuples, where each menber's type matches the type of the corresponding key path's property.

```swift
typealias Output = (Output0, Output1, Output2)
```

#### `Publishers.MeasureInterval.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MeasureInterval.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces elements of the provided scheduler's time type's stride.

```swift
typealias Output = Context.SchedulerTimeType.Stride
```

#### `Publishers.Merge.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge3.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge3.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge4.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge4.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge5.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge5.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge6.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge6.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge7.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge7.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.Merge8.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Merge8.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = A.Output
```

#### `Publishers.MergeMany.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.MergeMany.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publishers' common output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Multicast.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Multicast.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Output.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Output.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.PrefixUntilOutput.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.PrefixUntilOutput.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.PrefixWhile.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.PrefixWhile.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Print.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Print.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.ReceiveOn.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.ReceiveOn.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Reduce.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.RemoveDuplicates.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.RemoveDuplicates.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.ReplaceEmpty.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.ReplaceEmpty.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.ReplaceError.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher never fails.

```swift
typealias Failure = Never
```

#### `Publishers.ReplaceError.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Retry.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Retry.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Scan.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Sequence.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.

```swift
typealias Output = Elements.Element
```

#### `Publishers.SetFailureType.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Share.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Share.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.SubscribeOn.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.SubscribeOn.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.SwitchToLatest.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces errors of the type produced by the upstream publisher-of-publishers.

```swift
typealias Failure = P.Failure
```

#### `Publishers.SwitchToLatest.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces elements of the type produced by the upstream publisher-of-publishers.

```swift
typealias Output = P.Output
```

#### `Publishers.Throttle.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Throttle.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.Timeout.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publisher's failure type.

```swift
typealias Failure = Upstream.Failure
```

#### `Publishers.Timeout.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryAllSatisfy.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryAllSatisfy.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces Boolean elements.

```swift
typealias Output = Bool
```

#### `Publishers.TryCatch.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryCatch.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryCompactMap.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryComparison.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryComparison.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upsteam publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryContainsWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryContainsWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces Boolean elements.

```swift
typealias Output = Bool
```

#### `Publishers.TryDropWhile.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryDropWhile.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryFilter.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryFilter.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryFirstWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryFirstWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryLastWhere.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryLastWhere.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryMap.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryPrefixWhile.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryPrefixWhile.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher uses its upstream publisher's output type.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryReduce.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.TryRemoveDuplicates.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  Use `Never` if this `Publisher` does not publish errors.

```swift
typealias Failure = Error
```

#### `Publishers.TryRemoveDuplicates.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.

```swift
typealias Output = Upstream.Output
```

#### `Publishers.TryScan.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher produces the Swift <doc://com.apple.documentation/documentation/Swift/Error> type.

```swift
typealias Failure = Error
```

#### `Publishers.Zip.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Zip.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces two-element tuples, whose members' types correspond to the types produced by the upstream publishers.

```swift
typealias Output = (A.Output, B.Output)
```

#### `Publishers.Zip3.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Zip3.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces three-element tuples, whose members' types correspond to the types produced by the upstream publishers.

```swift
typealias Output = (A.Output, B.Output, C.Output)
```

#### `Publishers.Zip4.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this publisher might publish.  This publisher uses its upstream publishers' common failure type.

```swift
typealias Failure = A.Failure
```

#### `Publishers.Zip4.Output`
*macOS 10.15, iOS 13.0*

The kind of values published by this publisher.  This publisher produces four-element tuples, whose members' types correspond to the types produced by the upstream publishers.

```swift
typealias Output = (A.Output, B.Output, C.Output, D.Output)
```

#### `Record.Recording.Input`
*macOS 10.15, iOS 13.0*

```swift
typealias Input = Output
```

#### `Subscribers.Assign.Failure`
*macOS 10.15, iOS 13.0*

The kind of errors this subscriber might receive.  Use `Never` if this `Subscriber` cannot receive errors.

```swift
typealias Failure = Never
```
