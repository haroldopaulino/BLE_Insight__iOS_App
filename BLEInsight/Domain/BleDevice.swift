import Foundation

struct BleDevice: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let rssi: Int
    let identifier: String
    let advertisementCount: Int
    let firstSeen: Date
    let lastSeen: Date
    let connectable: Bool
    let serviceUUIDs: [String]
    let manufacturerDataSize: Int

    var signalQuality: SignalQuality {
        if rssi >= -55 {
            return .excellent
        }
        if rssi >= -70 {
            return .good
        }
        if rssi >= -85 {
            return .fair
        }
        return .weak
    }
}

enum SignalQuality: String, Sendable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case weak = "Weak"
}
