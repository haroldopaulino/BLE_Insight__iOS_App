import Foundation

struct WatchAdvertisementFlag: Identifiable, Hashable {
    let bit: UInt8
    let title: String
    let detail: String
    let isSet: Bool?
    var id: UInt8 { bit }
}

struct WatchBleDevice: Identifiable, Hashable {
    let id: UUID
    var name: String
    var rssi: Int
    var isConnectable: Bool?
    var advertisementCount: Int
    var serviceUUIDs: [String]
    var manufacturerData: Data?
    var serviceData: [String: Data]
    var txPower: Int?
    var lastSeen: Date
    var rawFlags: UInt8?

    var displayName: String { name.isEmpty ? "Unknown Device" : name }
    var identifierText: String { id.uuidString.uppercased() }
    var connectableText: String {
        guard let isConnectable else { return "Unknown" }
        return isConnectable ? "Connectable" : "Not Connectable"
    }
    var signalQuality: String {
        if rssi >= -55 {
            return "Excellent"
        } else if rssi >= -67 {
            return "Good"
        } else if rssi >= -79 {
            return "Fair"
        } else {
            return "Weak"
        }
    }
    var flagsHex: String { rawFlags.map { String(format: "0x%02X", $0) } ?? "Unavailable" }
    var decodedFlags: [WatchAdvertisementFlag] {
        let definitions: [(UInt8, String, String)] = [
            (0, "Limited Discoverable", "Limited discoverability is enabled."),
            (1, "General Discoverable", "General discoverability is enabled."),
            (2, "BR/EDR Not Supported", "The device is operating as BLE-only."),
            (3, "LE + BR/EDR Controller", "Controller supports simultaneous operation."),
            (4, "LE + BR/EDR Host", "Host supports simultaneous operation."),
            (5, "Reserved Flag 5", "Reserved by Bluetooth."),
            (6, "Reserved Flag 6", "Reserved by Bluetooth."),
            (7, "Reserved Flag 7", "Reserved by Bluetooth.")
        ]
        return definitions.map { bit, title, detail in
            WatchAdvertisementFlag(bit: bit, title: title, detail: detail,
                isSet: rawFlags.map { ($0 & (1 << bit)) != 0 })
        }
    }
}
