# Entitlements & Code Signing Reference

> Applicable to Vibology macOS 26 — a non-App-Store personal professional tool
> Platform: macOS 26 (Sequoia) / Xcode 26
> Last updated: February 2026

---

## Table of Contents

1. [Part 1 — The Sandbox Decision](#part-1--the-sandbox-decision)
   - [What the App Sandbox Is](#what-the-app-sandbox-is)
   - [What the Sandbox Restricts](#what-the-sandbox-restricts)
   - [Sandbox On vs. Off: The Tradeoffs](#sandbox-on-vs-off-the-tradeoffs)
   - [Recommendation for Vibology: Disable the Sandbox](#recommendation-for-vibology-disable-the-sandbox)
   - [How to Disable the Sandbox in Xcode](#how-to-disable-the-sandbox-in-xcode)
2. [Part 2 — Hardened Runtime](#part-2--hardened-runtime)
   - [What Hardened Runtime Is](#what-hardened-runtime-is)
   - [Why to Keep It Enabled Without the Sandbox](#why-to-keep-it-enabled-without-the-sandbox)
   - [How to Configure Hardened Runtime in Xcode](#how-to-configure-hardened-runtime-in-xcode)
3. [Part 3 — Required Entitlements for Vibology](#part-3--required-entitlements-for-vibology)
   - [Network Client — Cartographer Calls](#network-client--cartographer-calls)
   - [Keychain Access](#keychain-access)
   - [Apple Intelligence / Foundation Models](#apple-intelligence--foundation-models)
   - [File Access to ~/Vibology/](#file-access-to-vibology)
4. [Part 4 — Info.plist Keys](#part-4--infoplist-keys)
   - [NSAppTransportSecurity](#nsapptransportsecurity)
   - [Privacy Usage Descriptions](#privacy-usage-descriptions)
5. [Part 5 — The .entitlements File](#part-5--the-entitlements-file)
   - [Complete File for Vibology](#complete-file-for-vibology)
   - [Creating and Configuring in Xcode](#creating-and-configuring-in-xcode)
6. [Part 6 — Code Signing](#part-6--code-signing)
   - [Signing Identities: Personal Team vs. Developer ID](#signing-identities-personal-team-vs-developer-id)
   - [Running on Your Own Mac During Development](#running-on-your-own-mac-during-development)
   - [Distributing to Another Mac](#distributing-to-another-mac)
   - [Verifying Your Signature and Entitlements](#verifying-your-signature-and-entitlements)

---

## Part 1 — The Sandbox Decision

### What the App Sandbox Is

The macOS App Sandbox is an access control technology enforced by the kernel. When an app is sandboxed, it runs inside a restricted container: its file system access is confined to a set of explicitly granted locations, outbound network connections require a declared entitlement, and access to hardware or system services (camera, microphone, location, Keychain) must be both declared in the entitlements file and granted by the user at runtime.

The sandbox is enforced by the kernel's `Mandatory Access Control` subsystem and the `Sandbox.kext`. It cannot be bypassed at runtime — it is a hard boundary, not a suggestion.

The sandbox is **required for Mac App Store distribution**. Apple's app review verifies that the `com.apple.security.app-sandbox` entitlement is present before accepting a submission.

### What the Sandbox Restricts

By default, a sandboxed app can:

- Read and write files inside its own container (`~/Library/Containers/<bundle-id>/`)
- Read from its own bundle
- Access nothing else on the filesystem without an additional entitlement or user-driven open/save dialog

To do anything beyond that baseline, you must declare additional entitlements — and some capabilities simply cannot be unlocked inside the sandbox at all. Specific restrictions relevant to Vibology:

| Capability | Sandbox Behavior |
|---|---|
| Outbound network connections | Blocked unless `com.apple.security.network.client` is declared |
| Arbitrary file system reads | Blocked; requires user to pick a location via `NSOpenPanel` or `NSFilePresenter` |
| FSEvents on arbitrary paths | Blocked for paths outside the container or a user-granted security scope |
| Reading `~/Library/Mobile Documents/` directly | Technically accessible via iCloud entitlement but requires additional entitlement and `NSUbiquitousContainersUsageDescription` |
| Calling the local Keychain | Works, but only for items the app previously stored; cross-app Keychain sharing requires explicit groups and entitlements |

### Sandbox On vs. Off: The Tradeoffs

| | Sandbox ON | Sandbox OFF |
|---|---|---|
| **App Store eligibility** | Required | Disqualified |
| **Filesystem access** | Gated; requires user interaction or entitlements for every path | Full POSIX access as the logged-in user |
| **FSEvents on ~/Vibology/** | Requires user to grant access via `NSOpenPanel` first; security-scoped bookmarks must be stored and revalidated | Works directly — no user interaction required |
| **Network** | Needs `network.client` entitlement | Works without any entitlement |
| **Security posture** | App is isolated; a vulnerability cannot read arbitrary files | A vulnerability has same filesystem access as the user — no worse than a CLI tool or script |
| **Development friction** | High — power-user tools hit sandbox walls constantly | Low — the app behaves like any POSIX process |
| **Gatekeeper/Notarization** | Fully compatible | Fully compatible (notarization does not require the sandbox) |

### Recommendation for Vibology: Disable the Sandbox

**Disable the App Sandbox for Vibology.**

Vibology is a single-user professional tool that:

1. Watches `~/Vibology/Knowledge Base/` with FSEvents — a path that is completely outside any sandbox container and not inside an iCloud app container the app controls. Getting FSEvents to work with the sandbox on would require the user to explicitly grant access via `NSOpenPanel` on every launch (or store a security-scoped bookmark), adding friction to a daily workflow tool.

2. Reads PDF files from `~/Vibology/Knowledge Base/The Athenaeum/` — again, an arbitrary path outside the container.

3. Will never be distributed through the App Store; the primary requirement for the sandbox does not apply.

The sandbox offers real security value for consumer apps that handle untrusted input from the internet and are installed by non-technical users who need a kernel-enforced blast radius limit. Vibology is none of those things. It runs under one developer's user account, handles only that user's own data, and connects only to services that user controls (Cloud Run, Turso). The security posture of a sandboxed vs. unsandboxed Vibology is functionally identical from the perspective of an attacker — both run as the same user with the same file system access.

Running without the sandbox does not reduce Gatekeeper protection, does not prevent notarization, and does not affect Hardened Runtime (which is a separate and independent protection layer that you should keep enabled — see Part 2).

### How to Disable the Sandbox in Xcode

The sandbox is controlled by the presence (or absence) of the `com.apple.security.app-sandbox` key in the app's `.entitlements` file. Removing the key disables the sandbox entirely.

**Step 1.** Open the project's `.entitlements` file (e.g., `Vibology.entitlements`). If Xcode created one with the sandbox enabled, it will contain:

```xml
<key>com.apple.security.app-sandbox</key>
<true/>
```

**Step 2.** Delete those two lines. Do not set the key to `<false/>` — omit it entirely. Setting it to `false` is equivalent to omitting it, but omitting it is cleaner and leaves no ambiguity.

**Step 3.** Verify in Xcode's Signing & Capabilities tab that the "App Sandbox" capability does not appear in the capabilities list for the target. If it does, click the "–" button to remove it. Removing it from the GUI removes the key from the entitlements file automatically.

**Step 4.** Build and run. The app now has the same filesystem access as the running user.

> Xcode 26 note: When you create a new macOS SwiftUI app target, Xcode adds the App Sandbox capability by default. Remove it before writing any file-access or FSEvents code to avoid hitting walls during development.

---

## Part 2 — Hardened Runtime

### What Hardened Runtime Is

Hardened Runtime is a separate and independent security technology from the App Sandbox. It is a set of compile-time and link-time flags that harden the process against a class of runtime exploitation techniques:

- Prevents code injection via dylib hijacking
- Prevents unsigned code from being loaded into the process
- Prevents debugging (ptrace) by processes that are not explicitly allowed
- Prevents JIT compilation unless explicitly allowed
- Prevents certain memory region configurations used by shellcode

It has nothing to do with filesystem access or network permissions. It is about what code can execute inside your process, not what your process can access.

Hardened Runtime is enabled by checking **"Enable Hardened Runtime"** in Xcode's Signing & Capabilities tab (or by passing `-o runtime` to `codesign`). It is **required for notarization**.

### Why to Keep It Enabled Without the Sandbox

Removing the sandbox does not remove Hardened Runtime — they are independent. You should keep Hardened Runtime enabled for Vibology because:

1. **Notarization requires it.** To distribute Vibology to another Mac (or even to your own second Mac), you will submit the app to Apple's notary service. The notary rejects apps that are not signed with the Hardened Runtime flag. This is a hard requirement regardless of sandbox status.

2. **It protects against dylib injection.** Without Hardened Runtime, a malicious process running as the same user could inject code into Vibology's process via `DYLD_INSERT_LIBRARIES` or by placing a rogue dylib earlier on the library search path. With Hardened Runtime, this is blocked at the OS level.

3. **It costs nothing for Vibology's use case.** Hardened Runtime has entitlement exceptions for capabilities like JIT (used by JavaScript engines) or unsigned executable memory (used by some game engines). Vibology uses none of these. Enabling Hardened Runtime places no restrictions on what Vibology can do.

### How to Configure Hardened Runtime in Xcode

**In Xcode's GUI:**

1. Select the app target in the project navigator.
2. Open the **Signing & Capabilities** tab.
3. Ensure **Hardened Runtime** appears as an enabled capability. If it is not present, click the **"+ Capability"** button and add it.
4. No additional options need to be enabled under Hardened Runtime for Vibology. Leave all exception checkboxes unchecked.

**Verification via build settings:**

In Build Settings, confirm:
```
CODE_SIGN_INJECT_BASE_ENTITLEMENTS = YES   (Xcode default, do not change)
ENABLE_HARDENED_RUNTIME = YES
```

**Verification via command line after building:**

```bash
codesign -dvvv /path/to/Vibology.app
```

Look for `flags=0x10000(runtime)` in the output. The `runtime` flag confirms Hardened Runtime is active.

---

## Part 3 — Required Entitlements for Vibology

### Network Client — Cartographer Calls

**Entitlement:** `com.apple.security.network.client`

This entitlement is only required when the App Sandbox is enabled. It grants the sandboxed process permission to open outbound TCP sockets — which is necessary for any HTTPS call, including calls to Cartographer on Cloud Run and connections to Turso.

**For Vibology (sandbox disabled), this entitlement is not required.** Without the sandbox, the app can make outbound network connections freely, exactly like any command-line tool or script.

However, including it does no harm and is good practice for documentation purposes. The canonical entitlement XML is:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

**Decision for Vibology:** Include it anyway. It clearly communicates intent in the entitlements file and ensures zero friction if you ever experiment with sandbox-on mode during a debugging session.

### Keychain Access

**No special entitlement is required** to access the macOS Keychain for an unsandboxed app.

The Keychain is a system service accessible to any process running as the current user via the Security framework (`SecItemAdd`, `SecItemCopyMatching`, etc.). The user's login Keychain is unlocked automatically when the user logs in. An unsandboxed app can read and write Keychain items it owns freely, without declaring any entitlement.

The only Keychain-related entitlements exist for:

- **Keychain Sharing Groups** (`keychain-access-groups`) — required only when multiple distinct apps (with different bundle IDs) need to share the same Keychain items. Vibology has no companion apps, so this does not apply.
- **Sandboxed apps** — inside the sandbox, Keychain access is automatically scoped to the app's own items; the entitlement is implicit.

For Vibology's use case — storing Turso auth tokens, Cloud Run API keys, and any other secrets — standard `SecItem` calls work without any entitlement. See `Security-Reference.md` for the Swift API patterns.

### Apple Intelligence / Foundation Models

**No special entitlement is required** to use the `FoundationModels` framework.

The `SystemLanguageModel` API (used to access the on-device Apple Intelligence model) is gated at runtime by hardware and OS availability (`SystemLanguageModel.Availability`), not by entitlements or capabilities. Any app on a device with Apple Intelligence enabled can call `FoundationModels` without declaring anything in its entitlements file.

There is no `com.apple.security.foundationmodels` entitlement or equivalent. The framework requires:

- macOS 26+ (Sequoia)
- A device with Apple Intelligence enabled (Apple Silicon, region/language requirements met)
- The `FoundationModels` framework linked against the target

If the device does not meet the requirements, `SystemLanguageModel.default.availability` returns an `UnavailableReason` case at runtime. Handle this gracefully in the UI. See `FoundationModels-Reference.md` for complete availability handling patterns.

### File Access to ~/Vibology/

**No entitlement is required** for an unsandboxed app to read or write any path under `~/Vibology/`.

Without the sandbox, Vibology runs with the full POSIX file system permissions of the logged-in user. It can open, read, write, and watch any file the user has permission to access — including `~/Vibology/Knowledge Base/` for FSEvents and `~/Vibology/Knowledge Base/The Athenaeum/` for PDF reads — without declaring any entitlement.

The only scenario in which a file-access entitlement would be relevant:

- **`com.apple.security.files.user-selected.read-write`** and similar keys — these are sandbox-only entitlements that grant access to files the user picks via `NSOpenPanel`. They have no meaning outside the sandbox.

If you ever re-enable the sandbox during experimentation, you would need to obtain a security-scoped bookmark to `~/Vibology/` via `NSOpenPanel`, store it in `UserDefaults`, and revalidate it on launch. That complexity is one of the key reasons the sandbox is disabled for this tool.

---

## Part 4 — Info.plist Keys

### NSAppTransportSecurity

`NSAppTransportSecurity` is an `Info.plist` dictionary that configures App Transport Security (ATS) — the system's policy of requiring HTTPS with TLS 1.2+ for all network connections.

**For Vibology, no `NSAppTransportSecurity` configuration is needed.**

All of Vibology's outbound connections go to:
- **Cartographer on Google Cloud Run** — served over HTTPS with a valid TLS certificate from Google's infrastructure.
- **Turso** — served over HTTPS (the libSQL wire protocol runs over TLS).

Both endpoints already satisfy ATS's default requirements: HTTPS, TLS 1.2+, forward secrecy, certificate validity. ATS will pass both connections through without complaint.

`NSAppTransportSecurity` exceptions (like `NSAllowsArbitraryLoads` or per-domain `NSExceptionAllowsInsecureHTTPLoads`) are only needed when connecting to HTTP endpoints or TLS configurations that fall below Apple's minimum standard. Vibology has no such connections.

> Do not add `NSAllowsArbitraryLoads = true` as a convenience. It silences legitimate TLS warnings and is a red flag during notarization review, even for non-App-Store tools. It is not needed here.

### Privacy Usage Descriptions

Privacy usage description strings appear in the system permission dialog shown to the user when the app first requests access to a protected resource. For each resource Vibology uses, the requirement is:

| Resource | Info.plist Key | Required for Vibology? |
|---|---|---|
| Camera | `NSCameraUsageDescription` | No |
| Microphone | `NSMicrophoneUsageDescription` | No |
| Contacts | `NSContactsUsageDescription` | No |
| Calendar | `NSCalendarsUsageDescription` | No |
| Location | `NSLocationUsageDescription` | No |
| Photos | `NSPhotoLibraryUsageDescription` | No |
| File system (arbitrary) | None — POSIX access, no prompt | N/A (sandbox disabled) |

**Vibology requires no privacy usage description strings** for its current feature set. The app does not request access to any hardware or protected system resource that triggers a TCC (Transparency, Consent, and Control) prompt.

**One future exception to watch for:** If Vibology ever uses `NSUserNotificationCenter` / `UNUserNotificationCenter` to send local notifications, it must call `requestAuthorization(options:)` at runtime. This does not require an `Info.plist` key, but it does require the user to grant permission. No entitlement is needed.

---

## Part 5 — The .entitlements File

### Complete File for Vibology

This is the complete `.entitlements` file for the Vibology target. It is intentionally minimal — it includes only what Vibology actually uses, with no placeholder entitlements for capabilities that are not yet implemented.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>

    <!--
        HARDENED RUNTIME
        The app-sandbox entitlement is intentionally omitted.
        Vibology is a non-App-Store personal professional tool.
        Removing this entitlement disables the sandbox entirely,
        granting full POSIX filesystem access as the logged-in user.
        This is appropriate and intentional — see Entitlements-Reference.md.
    -->

    <!--
        NETWORK CLIENT
        Permits outbound TCP connections from a sandboxed process.
        Technically not required since the sandbox is disabled, but
        included for clarity and forward-compatibility.
    -->
    <key>com.apple.security.network.client</key>
    <true/>

</dict>
</plist>
```

**What is conspicuously absent and why:**

| Missing Key | Why It Is Absent |
|---|---|
| `com.apple.security.app-sandbox` | Disabled by omission — this is intentional |
| `com.apple.security.files.user-selected.read-write` | Sandbox-only entitlement; meaningless without sandbox |
| `com.apple.security.files.downloads.read-write` | Same — sandbox only |
| `keychain-access-groups` | Not needed; Vibology has no companion apps sharing Keychain items |
| `com.apple.security.network.server` | Vibology accepts no incoming connections |
| `com.apple.developer.aps-environment` | Push notifications — not used |

### Creating and Configuring in Xcode

**If an entitlements file does not yet exist:**

1. In the Xcode project navigator, right-click the `VibologyApp` group and choose **New File**.
2. Select **Property List** (under the Resource section). Name it `Vibology.entitlements`.
3. Place it in the `VibologyApp/` directory alongside the source files.
4. Select the app target, open the **Build Settings** tab, and search for `CODE_SIGN_ENTITLEMENTS`.
5. Set the value to the relative path from the project root: `VibologyApp/Vibology.entitlements`.

**If Xcode already created an entitlements file with the sandbox:**

1. Open `Vibology.entitlements` in the source editor (right-click → Open As → Source Code).
2. Replace the contents with the XML above.
3. In the **Signing & Capabilities** tab, verify the "App Sandbox" row is absent. If present, click the **"–"** button on that row to remove it.

**Confirming the entitlements file is wired up:**

```bash
# After building (replace path with your DerivedData build output):
codesign -d --entitlements - /path/to/Vibology.app
```

The output should show exactly the entitlements in the file — `com.apple.security.network.client` and nothing else (plus any Xcode-injected base entitlements like `com.apple.security.get-task-allow` in Debug builds).

**Debug builds and `get-task-allow`:**

In Debug builds, Xcode automatically injects `com.apple.security.get-task-allow = true` into the signed binary (unless `CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO`). This entitlement allows the debugger to attach. It is automatically removed for Archive builds. You do not need to add it manually, and you must not include it in a build you intend to notarize.

---

## Part 6 — Code Signing

### Signing Identities: Personal Team vs. Developer ID

macOS apps can be signed with different types of certificates, each granting different distribution rights:

| Identity Type | Description | Gatekeeper | Notarization | Distribution |
|---|---|---|---|---|
| **Development (Personal Team)** | Free; associated with your Apple ID | Only runs on the Mac used to build it (or with provisioning profile) | Not supported | Not distributable |
| **Mac Development** | Paid developer account; requires provisioning profile | Runs on specific provisioned devices | Not supported | Not distributable |
| **Developer ID Application** | Paid developer account ($99/year); no provisioning profile | Runs on any Mac after Gatekeeper check | Supported and recommended | Distributable to any Mac |
| **Apple Distribution** | App Store only | App Store | Via App Store pipeline | App Store only |

**For Vibology:**

- **During development on your own Mac:** Personal Team or Mac Development signing is sufficient. The app runs fine without notarization when you are the one building and launching it.
- **To run on a second Mac you own or distribute to a colleague:** Developer ID Application signing + notarization is required.

### Running on Your Own Mac During Development

During active development, Xcode signs the app automatically using your development team. This is called **ad-hoc signing** (when using a Personal Team) or **development signing** (when using a paid developer account with a Mac Development certificate).

Requirements:
- Xcode handles signing automatically with the "Automatically manage signing" checkbox enabled.
- The built app can be launched from Xcode, from Finder, or from the command line on the same Mac where it was built.
- No notarization is required.
- No provisioning profile is required for a macOS app targeting your own machine.

In Xcode's Signing & Capabilities tab:
- **Team:** Select your Apple ID (Personal Team) or your paid developer team.
- **Bundle Identifier:** `com.vibology.app` (or whatever you set; must be unique).
- **Signing Certificate:** Xcode selects this automatically.
- **Provisioning Profile:** "None" or Xcode Managed Profile — either is fine for local development.

### Distributing to Another Mac

To install Vibology on a second Mac (e.g., a backup machine, a collaborator's machine, or a future replacement laptop), you need:

1. **A Developer ID Application certificate** — obtained from the Apple Developer portal (requires a paid $99/year Apple Developer Program membership). In Xcode, go to Preferences → Accounts → Manage Certificates → "+" → Developer ID Application.

2. **Hardened Runtime enabled** — already covered in Part 2. Required for notarization.

3. **Notarization** — Apple's automated malware-scanning service. You submit the app (or a ZIP/DMG containing it) to the notary service, which returns a ticket. You then staple the ticket to the app. Gatekeeper on the receiving Mac verifies the ticket online (or reads the stapled ticket when offline) before allowing the app to launch.

**Notarization workflow using `notarytool` (Xcode 13+, replaces deprecated `altool`):**

```bash
# Step 1: Archive the app in Xcode (Product → Archive)
# Then export it as a Developer ID signed app via the Organizer window.

# Step 2: Create a ZIP for submission
ditto -c -k --keepParent /path/to/Vibology.app /tmp/Vibology.zip

# Step 3: Submit to the notary service
xcrun notarytool submit /tmp/Vibology.zip \
    --apple-id "your@email.com" \
    --team-id "YOURTEAMID" \
    --password "app-specific-password" \
    --wait

# Step 4: Staple the notarization ticket to the app
xcrun stapler staple /path/to/Vibology.app

# Step 5: Verify
xcrun stapler validate /path/to/Vibology.app
spctl --assess --verbose /path/to/Vibology.app
```

The `--wait` flag blocks until the notary service completes (usually under 5 minutes). On success, the output contains `status: Accepted`.

**Distribution methods for a personal non-App-Store tool:**

- **Direct copy** — copy `Vibology.app` to the second Mac via AirDrop, USB, or a shared drive. Gatekeeper will allow it after seeing the notarization ticket.
- **DMG** — create a DMG containing the app, notarize and staple the DMG itself. Provides a more polished install experience and keeps the app's extended attributes intact during transfer.
- **No installer needed** — macOS apps are self-contained bundles. The user drags `Vibology.app` to `/Applications/` and it is installed.

### Verifying Your Signature and Entitlements

These commands are useful during development and before distributing:

```bash
# Verify the signature and display signing details:
codesign --verify --verbose=4 /path/to/Vibology.app

# Display the entitlements embedded in the signed binary:
codesign -d --entitlements - /path/to/Vibology.app

# Display all code signing details (team, certificate, flags, etc.):
codesign -dvvv /path/to/Vibology.app

# Check Gatekeeper assessment (simulates what happens on another Mac):
spctl --assess --verbose /path/to/Vibology.app

# Verify notarization staple:
xcrun stapler validate /path/to/Vibology.app

# Check that Hardened Runtime is active (look for "flags=0x10000(runtime)"):
codesign -dvvv /path/to/Vibology.app 2>&1 | grep flags
```

**Expected output from `codesign -d --entitlements -` for a correctly configured Vibology build:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.network.client</key>
    <true/>
    <!-- com.apple.security.get-task-allow will appear in Debug builds only -->
</dict>
</plist>
```

If `com.apple.security.app-sandbox` appears in this output, the sandbox is still enabled. Remove it from the entitlements file and rebuild.
