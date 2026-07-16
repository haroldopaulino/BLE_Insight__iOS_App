import Foundation

struct AdvertisementFlag: Identifiable, Hashable {
    let bit: UInt8
    let title: String
    let detail: String
    let isSet: Bool?
    var id: UInt8 { bit }
}

struct BleDevice: Identifiable, Hashable {
    let id: UUID
    var name: String
    var rssi: Int
    var isConnectable: Bool?
    var advertisementCount: Int
    var serviceUUIDs: [String]
    var overflowServiceUUIDs: [String]
    var solicitedServiceUUIDs: [String]
    var manufacturerData: Data?
    var serviceData: [String: Data]
    var txPower: Int?
    var localName: String?
    var lastSeen: Date
    var rawAdvertisement: [String: String]
    var rawFlags: UInt8?

    var displayName: String { name.isEmpty ? "Unknown Device" : name }
    var identifierText: String { id.uuidString.uppercased() }
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
    var connectableText: String {
        guard let isConnectable else { return "Unknown" }
        return isConnectable ? "Connectable" : "Not Connectable"
    }
    var flagsHex: String { rawFlags.map { String(format: "0x%02X", $0) } ?? "Unavailable" }

    var decodedFlags: [AdvertisementFlag] {
        let definitions: [(UInt8,String,String)] = [
            (0,"LE Limited Discoverable Mode","Limited discoverability is enabled."),
            (1,"LE General Discoverable Mode","General discoverability is enabled."),
            (2,"BR/EDR Not Supported","The device is operating as BLE-only."),
            (3,"Simultaneous LE and BR/EDR (Controller)","Controller supports simultaneous LE and BR/EDR."),
            (4,"Simultaneous LE and BR/EDR (Host)","Host supports simultaneous LE and BR/EDR."),
            (5,"Reserved Flag 5","Reserved by the Bluetooth specification."),
            (6,"Reserved Flag 6","Reserved by the Bluetooth specification."),
            (7,"Reserved Flag 7","Reserved by the Bluetooth specification.")
        ]
        return definitions.map { definition in
            let (bit, title, detail) = definition
            return AdvertisementFlag(bit: bit, title: title, detail: detail, isSet: rawFlags.map { ($0 & (1 << bit)) != 0 })
        }
    }
}
