import SwiftUI

@main
struct BLEInsightWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchScannerScreen()
                .preferredColorScheme(.dark)
        }
    }
}
