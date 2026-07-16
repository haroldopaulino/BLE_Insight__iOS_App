import SwiftUI

@main
struct BLEInsightApp: App {
    var body: some Scene {
        WindowGroup {
            ScannerScreen()
                .preferredColorScheme(.dark)
        }
    }
}
