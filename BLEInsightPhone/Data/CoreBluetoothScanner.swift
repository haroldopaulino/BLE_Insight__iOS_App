import CoreBluetooth
import Foundation
import Observation

@MainActor
@Observable
final class CoreBluetoothScanner: NSObject, BleScanning {
    private var central: CBCentralManager!
    private(set) var devices: [BleDevice] = []
    private(set) var state: BluetoothPowerState = .unknown
    private(set) var isScanning = false

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    func startScan() {
        guard central.state == .poweredOn else { return }
        devices.removeAll()
        central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        isScanning = true
    }

    func stopScan() {
        central.stopScan()
        isScanning = false
    }

    func clear() { devices.removeAll() }

    private func mapState(_ value: CBManagerState) -> BluetoothPowerState {
        switch value {
        case .unknown: .unknown
        case .resetting: .resetting
        case .unsupported: .unsupported
        case .unauthorized: .unauthorized
        case .poweredOff: .poweredOff
        case .poweredOn: .poweredOn
        @unknown default: .unknown
        }
    }

    private func dataMap(_ value: Any?) -> [String: Data] {
        guard let dictionary = value as? [CBUUID: Data] else { return [:] }
        return Dictionary(uniqueKeysWithValues: dictionary.map { ($0.key.uuidString, $0.value) })
    }

    private func strings(_ value: Any?) -> [String] {
        (value as? [CBUUID])?.map(\.uuidString) ?? []
    }

    private func rawFlags(from advertisement: [String: Any]) -> UInt8? {
        guard let data = advertisement[CBAdvertisementDataManufacturerDataKey] as? Data,
              let byte = data.first else { return nil }
        return byte <= 0x1F ? byte : nil
    }
}

extension CoreBluetoothScanner: CBCentralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            state = mapState(central.state)
            if central.state != .poweredOn { isScanning = false }
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        Task { @MainActor in
            let id = peripheral.identifier
            let now = Date()
            let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            let name = localName ?? peripheral.name ?? "Unknown Device"
            let connectable = (advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue
            let serviceUUIDs = strings(advertisementData[CBAdvertisementDataServiceUUIDsKey])
            let overflow = strings(advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey])
            let solicited = strings(advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey])
            let manufacturer = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
            let serviceData = dataMap(advertisementData[CBAdvertisementDataServiceDataKey])
            let txPower = (advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber)?.intValue
            let raw = advertisementData.reduce(into: [String:String]()) { result, pair in
                if let data = pair.value as? Data { result[pair.key] = data.hexString }
                else { result[pair.key] = String(describing: pair.value) }
            }
            let flags = rawFlags(from: advertisementData)

            if let index = devices.firstIndex(where: { $0.id == id }) {
                devices[index].name = name
                devices[index].rssi = RSSI.intValue
                devices[index].isConnectable = connectable
                devices[index].advertisementCount += 1
                devices[index].serviceUUIDs = serviceUUIDs
                devices[index].overflowServiceUUIDs = overflow
                devices[index].solicitedServiceUUIDs = solicited
                devices[index].manufacturerData = manufacturer
                devices[index].serviceData = serviceData
                devices[index].txPower = txPower
                devices[index].localName = localName
                devices[index].lastSeen = now
                devices[index].rawAdvertisement = raw
                devices[index].rawFlags = flags
            } else {
                devices.append(BleDevice(id: id, name: name, rssi: RSSI.intValue,
                    isConnectable: connectable, advertisementCount: 1,
                    serviceUUIDs: serviceUUIDs, overflowServiceUUIDs: overflow,
                    solicitedServiceUUIDs: solicited, manufacturerData: manufacturer,
                    serviceData: serviceData, txPower: txPower, localName: localName,
                    lastSeen: now, rawAdvertisement: raw, rawFlags: flags))
            }
            devices.sort { $0.rssi > $1.rssi }
        }
    }
}

private extension Data {
    var hexString: String { map { String(format: "%02X", $0) }.joined(separator: " ") }
}
