import SwiftUI
import AppKit

@main
struct VibologyApp: App {
    init() {
        // Xcode generates its own Info.plist for SPM executable targets and doesn't
        // embed CFBundleIdentifier. Disabling automatic window tabbing prevents the
        // macOS tab-indexing system from hitting that missing-identifier code path.
        NSWindow.allowsAutomaticWindowTabbing = false

        // SPM executables don't auto-activate; force the app to the foreground.
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 500, height: 694)   // 500 × 694 ≈ 0.72 aspect ratio
    }
}
