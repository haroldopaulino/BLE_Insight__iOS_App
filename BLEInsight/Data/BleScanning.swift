import Foundation

protocol BleScanning: AnyObject {
    var onDeviceFound: (@MainActor @Sendable (BleDevice) -> Void)? { get set }
    var onStateChanged: (@MainActor @Sendable (BluetoothPowerState) -> Void)? { get set }
    var currentState: BluetoothPowerState { get }

    func startScanning()
    func stopScanning()
}
