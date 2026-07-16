import Foundation
import Observation

@MainActor
@Observable
final class WatchScannerViewModel {
    let scanner = WatchCoreBluetoothScanner()
    var devices: [WatchBleDevice] { scanner.devices }
    var isScanning: Bool { scanner.isScanning }
    var state: WatchBluetoothPowerState { scanner.state }
    func toggleScan() { isScanning ? scanner.stopScan() : scanner.startScan() }
}
