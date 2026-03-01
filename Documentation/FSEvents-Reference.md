# FSEvents Reference
> Extracted from macOS SDK — `CoreServices/FSEvents.framework` — available macOS 10.5+
> Relevant to Vibology: watching `~/Vibology/Knowledge Base/` (iCloud-synced Obsidian vault) for Markdown file changes

---

## Table of Contents

1. [Overview](#overview)
2. [FSEvents vs. Alternatives](#fsevents-vs-alternatives)
3. [Key Types](#key-types)
   - [FSEventStreamRef](#fseventstreamref)
   - [FSEventStreamEventId](#fseventstreameventid)
   - [FSEventStreamCreateFlags](#fseventstreamcreateflags)
   - [FSEventStreamEventFlags](#fseventstreameventflags)
   - [FSEventStreamCallback](#fseventstreamcallback)
   - [FSEventStreamContext](#fseventstreamcontext)
4. [Stream Lifecycle](#stream-lifecycle)
5. [Create Flags Reference](#create-flags-reference)
6. [Event Flags Reference](#event-flags-reference)
7. [Latency Parameter Guidance](#latency-parameter-guidance)
8. [sinceWhen and kFSEventStreamEventIdSinceNow](#sincewhen-and-kfseventstreameventidsincenow)
9. [Complete Swift Implementation](#complete-swift-implementation)
10. [iCloud-Specific Considerations](#icloud-specific-considerations)
11. [Resolving the iCloud Vault Path at Runtime](#resolving-the-icloud-vault-path-at-runtime)
12. [Exclusion Paths](#exclusion-paths)
13. [Debugging](#debugging)

---

## Overview

FSEvents is a macOS kernel-level file system notification API in `CoreServices`. The `fseventsd` daemon receives change events from the VFS layer and delivers them to registered clients in batches. The API surfaces changes as directory-level (default) or file-level (with `FileEvents` flag) notifications.

**Key design points:**
- Events are delivered in bulk after a configurable latency window — this coalesces bursts of changes into a single callback.
- The FSEvents daemon maintains a persistent, per-volume event log. Clients can request events since a stored event ID after an app restart, avoiding a full re-scan.
- Unlike polling, FSEvents scales to arbitrarily deep directory trees — a single stream can watch an entire Obsidian vault with thousands of notes.
- Event flags are **hints**, not a reliable transaction log. Always reconcile with the actual file system; the state may have changed further by the time the callback fires.

**Required framework:**

```swift
import CoreServices
```

Add `CoreServices.framework` to the target's linked frameworks, or rely on the transitive link through `AppKit`/`SwiftUI` on macOS.

---

## FSEvents vs. Alternatives

| Mechanism | Scope | Granularity | Strengths | Weaknesses |
|-----------|-------|-------------|-----------|------------|
| **FSEvents** | Recursive directory tree | Directory or file (with flag) | Scales to large trees; persistent event log; low overhead at rest | Slightly higher latency than kqueue; delivers hints, not exact operations |
| **DispatchSource (.vnode)** | Single file or directory descriptor | High (rename, write, delete, attrib) | Very precise per-descriptor events; built into libdispatch | Must open one file descriptor per watched item; does not recurse; unsuitable for watching a vault |
| **kqueue** | Per-fd kernel queue | High | Precise, low-level | Same fd-per-item limitation as DispatchSource; complex setup |
| **NSFilePresenter** | Single URL | App-level coordination | Participates in file coordination (safe for shared documents) | Only notified when another coordinator is involved; misses raw fs changes by non-coordinating writers |

**Use FSEvents for Vibology.** The Obsidian vault contains thousands of Markdown files in a nested directory tree. FSEvents watches the entire tree with one stream and one callback. DispatchSource/kqueue would require a separate file descriptor for every file and subdirectory — impractical and fragile as the vault grows.

---

## Key Types

### FSEventStreamRef

```c
typedef struct __FSEventStream *FSEventStreamRef;
typedef const struct __FSEventStream *ConstFSEventStreamRef;
```

An opaque reference to a stream object. Manually reference-counted: initial refcount is 1 after `FSEventStreamCreate`. Use `FSEventStreamRetain` / `FSEventStreamRelease` to manage lifetime. In Swift, store as `FSEventStreamRef?` on the watcher class.

### FSEventStreamEventId

```c
typedef UInt64 FSEventStreamEventId;

enum {
    kFSEventStreamEventIdSinceNow = 0xFFFFFFFFFFFFFFFFULL
};
```

A monotonically increasing, system-wide event counter that survives reboots. Pass `kFSEventStreamEventIdSinceNow` as `sinceWhen` to receive only future events. Pass a previously stored event ID to receive historical events since that point (useful for catching changes that happened while the app was not running).

### FSEventStreamCreateFlags

```c
typedef UInt32 FSEventStreamCreateFlags;
```

A bitmask passed to `FSEventStreamCreate` to configure stream behavior. See [Create Flags Reference](#create-flags-reference) for all values.

### FSEventStreamEventFlags

```c
typedef UInt32 FSEventStreamEventFlags;
```

A bitmask delivered per-event in the callback, describing the kind of change that occurred. See [Event Flags Reference](#event-flags-reference) for all values.

### FSEventStreamCallback

```c
typedef void (*FSEventStreamCallback)(
    ConstFSEventStreamRef streamRef,
    void * __nullable clientCallBackInfo,  // the context info pointer — your `self`
    size_t numEvents,
    void *eventPaths,                      // cast depends on create flags
    const FSEventStreamEventFlags *eventFlags,
    const FSEventStreamEventId *eventIds
);
```

A C function pointer. `eventPaths` is a raw `char**` unless `kFSEventStreamCreateFlagUseCFTypes` is set, in which case it is a `CFArrayRef` of `CFStringRef`. If both `UseCFTypes` and `UseExtendedData` are set it becomes a `CFArrayRef` of `CFDictionaryRef`.

The callback fires on whatever queue or run loop the stream was scheduled on. It is **not** called on the main thread by default.

### FSEventStreamContext

```c
struct FSEventStreamContext {
    CFIndex  version;           // must be 0
    void    *info;              // arbitrary pointer — pass Unmanaged<T>.passRetained(self).toOpaque()
    CFAllocatorRetainCallBack    retain;          // can be NULL
    CFAllocatorReleaseCallBack   release;         // can be NULL
    CFAllocatorCopyDescriptionCallBack copyDescription; // can be NULL
};
```

Used to associate client data with the stream so the C callback can recover a Swift `self` reference. The framework copies the struct's fields at creation time; the original can be stack-allocated.

---

## Stream Lifecycle

The mandatory six-step lifecycle:

```
FSEventStreamCreate          → creates the stream (refcount = 1)
FSEventStreamSetDispatchQueue → assigns a dispatch queue for callbacks
FSEventStreamStart           → registers with fseventsd; callbacks begin
    ... receiving events ...
FSEventStreamStop            → pauses; callbacks cease; can restart cleanly
FSEventStreamInvalidate      → detaches from the queue (must call before Release)
FSEventStreamRelease         → decrements refcount; deallocates when it reaches zero
```

> **Rule:** Always call `Stop` before `Invalidate`, and `Invalidate` before `Release`. Never call `Invalidate` without first scheduling the stream on a queue or run loop (the API documents this as an error).

**Scheduling options:**

`FSEventStreamScheduleWithRunLoop` is deprecated as of macOS 13. Use `FSEventStreamSetDispatchQueue` instead:

```c
extern void FSEventStreamSetDispatchQueue(FSEventStreamRef streamRef, dispatch_queue_t __nullable q);
```

Pass `nil` to remove the queue association (equivalent to unscheduling), but do not do this before calling `FSEventStreamInvalidate`.

---

## Create Flags Reference

| Flag | Value | Notes |
|------|-------|-------|
| `kFSEventStreamCreateFlagNone` | `0x00000000` | Default: directory-level events, deferred latency mode |
| `kFSEventStreamCreateFlagUseCFTypes` | `0x00000001` | `eventPaths` delivered as `CFArrayRef` of `CFStringRef`; required for `UseExtendedData` |
| `kFSEventStreamCreateFlagNoDefer` | `0x00000002` | After a quiet period, the first event is delivered immediately; subsequent events coalesce normally. Use for interactive apps that need fast first-response |
| `kFSEventStreamCreateFlagWatchRoot` | `0x00000004` | Fires `RootChanged` if the watched path itself is renamed or deleted. Useful for detecting iCloud eviction of the vault folder |
| `kFSEventStreamCreateFlagIgnoreSelf` | `0x00000008` | Suppress events triggered by the current process. Has no effect on historical events |
| `kFSEventStreamCreateFlagFileEvents` | `0x00000010` | Promote to file-level granularity. Required to receive `ItemIsFile`, `ItemCreated`, `ItemModified`, etc. per individual file. Generates significantly more events |
| `kFSEventStreamCreateFlagMarkSelf` | `0x00000020` | Instead of suppressing own events, tags them with `OwnEvent` flag |
| `kFSEventStreamCreateFlagUseExtendedData` | `0x00000040` | Requires `UseCFTypes`; delivers each event as a `CFDictionaryRef` containing `kFSEventStreamEventExtendedDataPathKey` (path), `kFSEventStreamEventExtendedFileIDKey` (inode), and `kFSEventStreamEventExtendedDocIDKey` (document ID) |
| `kFSEventStreamCreateFlagFullHistory` | `0x00000080` | When replaying historical events, includes the entire chunk containing `sinceWhen` even if some event IDs predate it. Avoids skipping events at restart boundaries |

**Recommended flags for Vibology vault watcher:**

```swift
let flags: FSEventStreamCreateFlags = UInt32(
    kFSEventStreamCreateFlagUseCFTypes |
    kFSEventStreamCreateFlagFileEvents |
    kFSEventStreamCreateFlagNoDefer    |
    kFSEventStreamCreateFlagWatchRoot
)
```

`FileEvents` provides per-file paths (essential for filtering to `.md` files). `NoDefer` ensures the first notification after a quiet period is prompt. `WatchRoot` detects if the vault directory itself is moved or removed by iCloud.

---

## Event Flags Reference

Flags set on each event in the callback. Multiple flags can be ORed together on a single event.

### Structural / Error Flags

| Flag | Value | Meaning |
|------|-------|---------|
| `kFSEventStreamEventFlagNone` | `0x00000000` | A change occurred in the directory; no further detail |
| `kFSEventStreamEventFlagMustScanSubDirs` | `0x00000001` | Events were coalesced or dropped; rescan the entire subtree. Check `UserDropped` / `KernelDropped` for the source |
| `kFSEventStreamEventFlagUserDropped` | `0x00000002` | Client-side event buffer overflow; accompanies `MustScanSubDirs` |
| `kFSEventStreamEventFlagKernelDropped` | `0x00000004` | Kernel-side event buffer overflow; accompanies `MustScanSubDirs` |
| `kFSEventStreamEventFlagEventIdsWrapped` | `0x00000008` | The 64-bit event ID counter wrapped; previously stored IDs are invalid |
| `kFSEventStreamEventFlagHistoryDone` | `0x00000010` | Sentinel: all historical events have been delivered; contemporaneous events follow |
| `kFSEventStreamEventFlagRootChanged` | `0x00000020` | The watched path itself changed (requires `WatchRoot` flag); event ID is zero |
| `kFSEventStreamEventFlagMount` | `0x00000040` | A volume was mounted under a watched path |
| `kFSEventStreamEventFlagUnmount` | `0x00000080` | A volume was unmounted from under a watched path |

### File-Level Flags (require `kFSEventStreamCreateFlagFileEvents`)

| Flag | Value | Meaning |
|------|-------|---------|
| `kFSEventStreamEventFlagItemCreated` | `0x00000100` | A new file or directory was created at the path |
| `kFSEventStreamEventFlagItemRemoved` | `0x00000200` | The file or directory at the path was deleted |
| `kFSEventStreamEventFlagItemInodeMetaMod` | `0x00000400` | Inode metadata changed (permissions, timestamps, etc.) |
| `kFSEventStreamEventFlagItemRenamed` | `0x00000800` | The item was renamed. The path is the old or new name; FSEvents does not pair the two events — check both |
| `kFSEventStreamEventFlagItemModified` | `0x00001000` | File data was written |
| `kFSEventStreamEventFlagItemFinderInfoMod` | `0x00002000` | Finder info (extended attributes) changed |
| `kFSEventStreamEventFlagItemChangeOwner` | `0x00004000` | Ownership or permissions changed |
| `kFSEventStreamEventFlagItemXattrMod` | `0x00008000` | Extended attributes changed |
| `kFSEventStreamEventFlagItemIsFile` | `0x00010000` | The item at the event path is a regular file |
| `kFSEventStreamEventFlagItemIsDir` | `0x00020000` | The item at the event path is a directory |
| `kFSEventStreamEventFlagItemIsSymlink` | `0x00040000` | The item is a symbolic link |
| `kFSEventStreamEventFlagOwnEvent` | `0x00080000` | The event was triggered by this process (requires `MarkSelf`) |
| `kFSEventStreamEventFlagItemIsHardlink` | `0x00100000` | The item is a hard link |
| `kFSEventStreamEventFlagItemIsLastHardlink` | `0x00200000` | This is the last hard link to the inode |
| `kFSEventStreamEventFlagItemCloned` | `0x00400000` | The item was cloned (APFS copy-on-write clone) |

**Filtering pattern for Markdown files:**

```swift
let isFile     = flags & UInt32(kFSEventStreamEventFlagItemIsFile) != 0
let isModified = flags & UInt32(
    kFSEventStreamEventFlagItemCreated  |
    kFSEventStreamEventFlagItemRemoved  |
    kFSEventStreamEventFlagItemRenamed  |
    kFSEventStreamEventFlagItemModified
) != 0
let isMd = path.hasSuffix(".md")

guard isFile && isModified && isMd else { return }
```

---

## Latency Parameter Guidance

The `latency` parameter (a `CFTimeInterval`, i.e. `Double` seconds) controls how long `fseventsd` waits after the first event before delivering the batch. Larger values reduce callback frequency by coalescing more events; smaller values reduce perceived delay.

| Use case | Recommended latency |
|----------|---------------------|
| Background indexing / batch processing | `2.0` – `5.0` |
| Interactive app, tolerates slight delay | `0.5` – `1.0` |
| Near-real-time (Vibology Ephemeris refresh) | `0.3` – `0.5` |
| Minimum practical value | `0.1` (below this, overhead increases with no perceptible benefit) |

**Vibology recommendation: `0.5` seconds.** iCloud sync produces clusters of file operations (download, rename temp file, replace final). A 500 ms window coalesces the entire sync burst into one callback rather than firing three or four times per note save.

With `kFSEventStreamCreateFlagNoDefer`, the first event after a quiet period fires immediately, then subsequent rapid events coalesce per the latency window. This gives the fastest initial response without flooding the app during a bulk sync.

```swift
let latency: CFTimeInterval = 0.5
```

---

## sinceWhen and kFSEventStreamEventIdSinceNow

`sinceWhen` tells `fseventsd` the last event ID the client processed. The service will replay any events that occurred after that ID before switching to live events.

```swift
// Only receive events from this moment forward (standard case):
let sinceWhen = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

// Resume from a stored event ID after restart:
let storedId: FSEventStreamEventId = UserDefaults.standard.object(
    forKey: "lastFSEventId") as? UInt64 ?? FSEventStreamEventId(kFSEventStreamEventIdSinceNow)
```

**Persisting the event ID for crash recovery:**

```swift
// Inside the callback, after processing, persist the latest ID:
let latestId = FSEventStreamGetLatestEventId(streamRef)
UserDefaults.standard.set(latestId, forKey: "lastFSEventId")
```

Before using a stored ID after app restart, verify the volume UUID has not changed (which would indicate the FSEvents database was reset):

```swift
func volumeUUIDChanged(for path: String) -> Bool {
    var statResult = stat()
    guard stat(path, &statResult) == 0 else { return true }
    let dev = statResult.st_dev
    guard let uuid = FSEventsCopyUUIDForDevice(dev) else { return true }
    let uuidString = CFUUIDCreateString(nil, uuid) as String
    let stored = UserDefaults.standard.string(forKey: "volumeUUID") ?? ""
    UserDefaults.standard.set(uuidString, forKey: "volumeUUID")
    return uuidString != stored
}
```

If the UUID changed, discard the stored event ID and fall back to `kFSEventStreamEventIdSinceNow`, then trigger a full re-index.

---

## Complete Swift Implementation

The following `VaultWatcher` class wraps the FSEvents C API in a Swift-concurrency-safe interface. It watches a directory recursively, delivers a debounced set of changed `.md` file paths to a `@MainActor` handler, and manages the stream lifecycle correctly.

```swift
import CoreServices
import Foundation

/// Watches a directory tree for Markdown file changes using FSEvents.
/// Safe to create and use from the main actor.
@MainActor
final class VaultWatcher {

    // MARK: - Public interface

    /// The absolute path being watched (e.g., the resolved iCloud vault path).
    let watchedPath: String

    /// Called on the main actor whenever one or more .md files change.
    /// Receives the set of changed file paths in that batch.
    var onChange: (([String]) -> Void)?

    // MARK: - Init / deinit

    init(path: String, onChange: (([String]) -> Void)? = nil) {
        self.watchedPath = path
        self.onChange = onChange
    }

    deinit {
        stopInternal()
    }

    // MARK: - Lifecycle

    /// Start watching. Safe to call multiple times; subsequent calls are no-ops.
    func start() {
        guard eventStream == nil else { return }

        let pathsToWatch = [watchedPath] as CFArray

        // The context passes `self` through the C callback via an unmanaged pointer.
        // We use `passUnretained` because the stream's lifetime is scoped to `self`;
        // `self` will always outlive the stream.
        var context = FSEventStreamContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        let flags = UInt32(
            kFSEventStreamCreateFlagUseCFTypes |
            kFSEventStreamCreateFlagFileEvents |
            kFSEventStreamCreateFlagNoDefer    |
            kFSEventStreamCreateFlagWatchRoot
        )

        guard let stream = FSEventStreamCreate(
            nil,                                     // allocator: default
            vaultWatcherCallback,                    // C callback (free function below)
            &context,
            pathsToWatch,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            0.5,                                     // latency: 500 ms
            FSEventStreamCreateFlags(flags)
        ) else {
            print("VaultWatcher: FSEventStreamCreate failed for path: \(watchedPath)")
            return
        }

        eventStream = stream

        // Deliver callbacks on a background serial queue; we dispatch to MainActor
        // inside the callback so the handler can safely touch SwiftUI state.
        let queue = DispatchQueue(label: "com.vibology.vaultwatcher", qos: .utility)
        FSEventStreamSetDispatchQueue(stream, queue)

        guard FSEventStreamStart(stream) else {
            print("VaultWatcher: FSEventStreamStart failed")
            FSEventStreamInvalidate(stream)
            FSEventStreamRelease(stream)
            eventStream = nil
            return
        }
    }

    /// Stop watching and release all resources. Safe to call when not started.
    func stop() {
        stopInternal()
    }

    // MARK: - Private

    private var eventStream: FSEventStreamRef?

    private func stopInternal() {
        guard let stream = eventStream else { return }
        FSEventStreamStop(stream)
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        eventStream = nil
    }

    /// Called from the C callback with the set of changed `.md` paths.
    fileprivate func handleEvents(_ paths: [String]) {
        let mdPaths = paths.filter { $0.hasSuffix(".md") }
        guard !mdPaths.isEmpty else { return }
        // Already on the main actor because we dispatch to it in the C callback.
        onChange?(mdPaths)
    }
}

// MARK: - C callback (free function — must not capture state)

/// This is a plain C function registered with FSEvents.
/// It recovers the `VaultWatcher` instance from the context pointer
/// and dispatches filtered events to the main actor.
private func vaultWatcherCallback(
    _ streamRef: ConstFSEventStreamRef,
    _ clientCallBackInfo: UnsafeMutableRawPointer?,
    _ numEvents: Int,
    _ eventPathsVoid: UnsafeMutableRawPointer,
    _ eventFlags: UnsafePointer<FSEventStreamEventFlags>,
    _ eventIds: UnsafePointer<FSEventStreamEventId>
) {
    guard let info = clientCallBackInfo else { return }

    // Recover the Swift instance from the unmanaged pointer.
    let watcher = Unmanaged<VaultWatcher>.fromOpaque(info).takeUnretainedValue()

    // Because we used kFSEventStreamCreateFlagUseCFTypes, eventPaths is a CFArray of CFString.
    let eventPaths = unsafeBitCast(eventPathsVoid, to: CFArray.self) as [AnyObject]

    var changedPaths: [String] = []

    for i in 0..<numEvents {
        let flags = eventFlags[i]

        // Filter to file-level events only.
        let isFile = flags & UInt32(kFSEventStreamEventFlagItemIsFile) != 0

        // Accept created, removed, renamed, or data-modified events.
        let isRelevant = flags & UInt32(
            kFSEventStreamEventFlagItemCreated  |
            kFSEventStreamEventFlagItemRemoved  |
            kFSEventStreamEventFlagItemRenamed  |
            kFSEventStreamEventFlagItemModified
        ) != 0

        // MustScanSubDirs means events were dropped — treat as a broad change signal.
        let mustRescan = flags & UInt32(kFSEventStreamEventFlagMustScanSubDirs) != 0

        guard isFile && isRelevant || mustRescan else { continue }

        if mustRescan {
            // Deliver the watched path itself as the signal to trigger a full re-index.
            changedPaths.append(watcher.watchedPath)
            break
        }

        if let path = eventPaths[i] as? String {
            changedPaths.append(path)
        }
    }

    guard !changedPaths.isEmpty else { return }

    // Jump to the main actor to call the handler.
    // `watcher` is @MainActor-isolated, so we use Task { @MainActor in ... }.
    Task { @MainActor in
        watcher.handleEvents(changedPaths)
    }
}
```

### Usage in a ViewModel

```swift
@MainActor
final class EphemerisViewModel: ObservableObject {
    @Published var notes: [EphemerisNote] = []

    private var watcher: VaultWatcher?

    func startWatching(vaultPath: String) {
        watcher = VaultWatcher(path: vaultPath) { [weak self] changedPaths in
            guard let self else { return }
            // changedPaths is a [String] of .md file paths that changed.
            // Re-query GRDB and refresh the view.
            Task {
                await self.refreshNotes(changedPaths: changedPaths)
            }
        }
        watcher?.start()
    }

    func stopWatching() {
        watcher?.stop()
        watcher = nil
    }

    private func refreshNotes(changedPaths: [String]) async {
        // Re-query Turso/GRDB index for the changed notes.
        // ...
    }
}
```

---

## iCloud-Specific Considerations

iCloud Drive materialises file changes on the local filesystem through a series of intermediate operations that all appear as FSEvents. Understanding these patterns prevents spurious re-indexing.

### How iCloud Sync Appears as FSEvents

When Obsidian saves a note and iCloud picks it up on another Mac, the receiving Mac sees a sequence like:

1. **`.icloud` placeholder created** (`ItemCreated | ItemIsFile`) — iCloud creates `Myfile.md.icloud` before downloading the real file. This path ends in `.icloud`, not `.md`, so it is filtered out by the `.hasSuffix(".md")` check automatically.
2. **Download begins** — The `.icloud` file is removed and a temp file appears (e.g., `.~lock.Myfile.md#`). Also filtered by the `.md` suffix check.
3. **File materialised** (`ItemCreated | ItemModified | ItemIsFile` on `Myfile.md`) — The actual `.md` file appears or is overwritten with the synced content. This is the event to act on.
4. **Metadata xattr updated** (`ItemXattrMod`) — iCloud stamps the file with sync metadata. Usually not actionable; the content is already correct from step 3.

The 500 ms latency window collapses steps 2–4 into a single callback in most cases.

### Deferred Downloads (iCloud Optimised Storage)

When macOS evicts a note from local storage to iCloud, the `.md` file is replaced by a `.icloud` stub. If the vault watcher fires a `ItemRemoved` event for `Myfile.md`, it may indicate eviction rather than true deletion. Check whether a `.icloud` counterpart exists:

```swift
func isEvictedToCloud(path: String) -> Bool {
    let dir = (path as NSString).deletingLastPathComponent
    let name = (path as NSString).lastPathComponent
    let cloudStub = (dir as NSString).appendingPathComponent(".\(name).icloud")
    return FileManager.default.fileExists(atPath: cloudStub)
}
```

Do not remove a note from the GRDB index on `ItemRemoved` without this check. Either ignore the event (the note is still "there" conceptually) or mark it as locally unavailable.

### Safe-Save Patterns

Obsidian and many text editors perform atomic writes via a rename:
1. Write to a temp file (`Myfile-tmp.md` or a hidden file).
2. `rename()` the temp file over the final path.

This produces an `ItemCreated` on the temp path and an `ItemRenamed` on both the temp and the final path. The 500 ms latency window collapses all three events. The final event on `Myfile.md` will carry `ItemRenamed | ItemIsFile`, which is caught by the `ItemRenamed` flag in the filter.

### iCloud Conflict Files

iCloud can create conflict copies with names like `Myfile (Joe's MacBook Pro's conflicted copy 2025-12-01).md`. These are valid `.md` files and will appear as `ItemCreated` events. Handle them in the GRDB indexer — do not silently discard them.

---

## Resolving the iCloud Vault Path at Runtime

The iCloud Drive path for the Obsidian vault is **not** simply `~/Library/Mobile Documents/`. The canonical method is to ask `FileManager` for the iCloud container or to resolve it via `NSFileManager.url(forUbiquityContainerIdentifier:)`. However, for a vault that lives in the user's iCloud Drive root (not inside an app container), the correct approach is to resolve the path directly:

```swift
/// Returns the local filesystem path for `~/Vibology/Knowledge Base/` stored in iCloud Drive.
///
/// iCloud Drive on macOS mirrors content at:
///   ~/Library/Mobile Documents/com~apple~CloudDocs/<path>
/// This is the same tree exposed as ~/iCloud Drive/ in Finder.
///
/// Returns nil if the directory does not exist locally (e.g., not yet downloaded,
/// or iCloud Drive is disabled).
func vaultPath() -> String? {
    let fm = FileManager.default
    guard let home = fm.homeDirectoryForCurrentUser as URL?,
          // iCloud Drive root on macOS
          let cloudDocs = try? fm.url(
              for: .documentDirectory,
              in: .userDomainMask,
              appropriateFor: nil,
              create: false
          ).deletingLastPathComponent()
              .appendingPathComponent("Mobile Documents/com~apple~CloudDocs") else {
        return nil
    }
    let vaultURL = cloudDocs
        .appendingPathComponent("Vibology")
        .appendingPathComponent("Knowledge Base")
    return fm.fileExists(atPath: vaultURL.path) ? vaultURL.path : nil
}
```

A simpler and more robust alternative — expand the tilde path that mirrors what Finder shows:

```swift
func vaultPath() -> String? {
    // Finder shows iCloud Drive contents under ~/iCloud Drive/ as a synthetic link,
    // but the real location on disk is the Mobile Documents path.
    // The most portable runtime resolution:
    let candidates: [String] = [
        // Primary: standard iCloud Drive location
        ("~/Library/Mobile Documents/com~apple~CloudDocs/Vibology/Knowledge Base" as NSString)
            .expandingTildeInPath,
        // Fallback: user placed vault directly in ~/Vibology (local, non-iCloud)
        ("~/Vibology/Knowledge Base" as NSString).expandingTildeInPath,
    ]
    return candidates.first { FileManager.default.fileExists(atPath: $0) }
}
```

Use this at app launch and after receiving a `RootChanged` event (which indicates the vault directory was moved or its parent was renamed):

```swift
// In AppDelegate or the top-level SwiftUI App:
Task { @MainActor in
    guard let path = vaultPath() else {
        print("Vault not found locally — iCloud may not have synced yet")
        return
    }
    viewModel.startWatching(vaultPath: path)
}
```

**Note:** The path `~/Library/Mobile Documents/com~apple~CloudDocs` may contain spaces. Always use it as a `String` with proper path APIs (`URL`, `NSString.appendingPathComponent`) rather than shell-style string concatenation.

---

## Exclusion Paths

`FSEventStreamSetExclusionPaths` (macOS 10.9+) filters up to **8** subdirectories out of a stream. Useful for ignoring Obsidian's `.obsidian/` configuration directory (which changes frequently on open and does not contain notes):

```swift
// Call after creating the stream, before starting it.
let exclusions = [
    (watchedPath as NSString).appendingPathComponent(".obsidian"),
    (watchedPath as NSString).appendingPathComponent(".trash"),
] as CFArray

FSEventStreamSetExclusionPaths(stream, exclusions)
```

> Maximum of 8 paths. Exclusions are path-prefix matches; subdirectories of an excluded path are also excluded.

---

## Debugging

```swift
// Print a human-readable description of the stream to stderr:
FSEventStreamShow(stream)

// Get a CFString description (useful for logging):
if let desc = FSEventStreamCopyDescription(stream) {
    print(desc as String)
}

// Flush buffered events immediately (async — callback fires later):
FSEventStreamFlushAsync(stream)

// Flush and block until all pending callbacks have fired (sync):
FSEventStreamFlushSync(stream)
```

**Command-line tool:** `fsevents_watch` (available via Homebrew as part of `fswatch`) can monitor any path and print raw events — useful for verifying what events iCloud generates for your vault before writing Swift code.

**System log:** `fseventsd` logs to the unified system log. Filter in Console.app with subsystem `com.apple.fsevents` or run:

```bash
log stream --predicate 'subsystem == "com.apple.fsevents"' --level debug
```
