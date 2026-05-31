import Foundation

enum BluetoothPowerState: Equatable, Sendable {
    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn

    var title: String {
        switch self {
        case .unknown:
            return "Checking Bluetooth"
        case .resetting:
            return "Bluetooth Resetting"
        case .unsupported:
            return "Bluetooth Unsupported"
        case .unauthorized:
            return "Bluetooth Permission Needed"
        case .poweredOff:
            return "Bluetooth Off"
        case .poweredOn:
            return "Bluetooth Ready"
        }
    }

    var message: String {
        switch self {
        case .unknown:
            return "Waiting for iOS to report Bluetooth status."
        case .resetting:
            return "Bluetooth is restarting. Try again shortly."
        case .unsupported:
            return "This device does not support Bluetooth Low Energy scanning."
        case .unauthorized:
            return "Allow Bluetooth access in Settings to scan nearby BLE devices."
        case .poweredOff:
            return "Turn Bluetooth on in Control Center or Settings to scan."
        case .poweredOn:
            return "Ready to scan nearby Bluetooth Low Energy devices."
        }
    }
}
