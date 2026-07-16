import Foundation

@MainActor
protocol BleScanning: AnyObject {
    var devices: [BleDevice] { get }
    var state: BluetoothPowerState { get }
    var isScanning: Bool { get }
    func startScan()
    func stopScan()
    func clear()
}
