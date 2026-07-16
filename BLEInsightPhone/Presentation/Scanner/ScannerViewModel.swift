import Foundation
import Observation

@MainActor
@Observable
final class ScannerViewModel {
    let scanner = CoreBluetoothScanner()
    var devices: [BleDevice] { scanner.devices }
    var isScanning: Bool { scanner.isScanning }
    var state: BluetoothPowerState { scanner.state }
    var strongestRSSI: String { devices.first.map { "\($0.rssi) dBm" } ?? "--" }
    func toggleScan() { isScanning ? scanner.stopScan() : scanner.startScan() }
}
