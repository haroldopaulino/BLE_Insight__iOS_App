import Foundation

enum WatchBluetoothPowerState: Equatable {
    case unknown, resetting, unsupported, unauthorized, poweredOff, poweredOn

    var title: String {
        switch self {
        case .unknown: "Unknown"
        case .resetting: "Resetting"
        case .unsupported: "Unsupported"
        case .unauthorized: "Permission Required"
        case .poweredOff: "Bluetooth Off"
        case .poweredOn: "Ready"
        }
    }
}
