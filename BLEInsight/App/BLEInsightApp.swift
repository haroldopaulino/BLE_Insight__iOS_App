import SwiftUI

@main
struct BLEInsightApp: App {
    @State private var viewModel = ScannerViewModel(scanner: CoreBluetoothScanner())

    var body: some Scene {
        WindowGroup {
            ScannerScreen(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
