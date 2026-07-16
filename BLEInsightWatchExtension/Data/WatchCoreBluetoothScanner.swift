import CoreBluetooth
import Foundation
import Observation

@MainActor
@Observable
final class WatchCoreBluetoothScanner: NSObject {
    private var central: CBCentralManager!
    private var autoStopTask: Task<Void, Never>?
    private var lastAcceptedUpdate: [UUID: Date] = [:]

    private(set) var devices: [WatchBleDevice] = []
    private(set) var state: WatchBluetoothPowerState = .unknown
    private(set) var isScanning = false

    private let scanDuration: Duration = .seconds(20)
    private let minimumUpdateInterval: TimeInterval = 0.5
    private let maximumDevices = 40

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }


    func startScan() {
        guard central.state == .poweredOn else { return }
        devices.removeAll(keepingCapacity: true)
        lastAcceptedUpdate.removeAll(keepingCapacity: true)
        central.scanForPeripherals(
            withServices: nil,
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        )
        isScanning = true
        autoStopTask?.cancel()
        autoStopTask = Task { [weak self] in
            try? await Task.sleep(for: scanDuration)
            guard !Task.isCancelled else { return }
            self?.stopScan()
        }
    }

    func stopScan() {
        autoStopTask?.cancel()
        autoStopTask = nil
        central.stopScan()
        isScanning = false
    }

    func clear() {
        devices.removeAll(keepingCapacity: true)
        lastAcceptedUpdate.removeAll(keepingCapacity: true)
    }

    private func mapState(_ value: CBManagerState) -> WatchBluetoothPowerState {
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

    private func strings(_ value: Any?) -> [String] {
        (value as? [CBUUID])?.map(\.uuidString) ?? []
    }

    private func dataMap(_ value: Any?) -> [String: Data] {
        guard let dictionary = value as? [CBUUID: Data] else { return [:] }
        return Dictionary(uniqueKeysWithValues: dictionary.map { ($0.key.uuidString, $0.value) })
    }

    private func rawFlags(from advertisement: [String: Any]) -> UInt8? {
        guard let data = advertisement[CBAdvertisementDataManufacturerDataKey] as? Data,
              let byte = data.first, byte <= 0x1F else { return nil }
        return byte
    }
}

extension WatchCoreBluetoothScanner: CBCentralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            state = mapState(central.state)
            if central.state != .poweredOn { stopScan() }
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
            if let previous = lastAcceptedUpdate[id],
               now.timeIntervalSince(previous) < minimumUpdateInterval { return }
            lastAcceptedUpdate[id] = now

            let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            let name = localName ?? peripheral.name ?? "Unknown Device"
            let connectable = (advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue
            let serviceUUIDs = strings(advertisementData[CBAdvertisementDataServiceUUIDsKey])
            let manufacturer = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data
            let serviceData = dataMap(advertisementData[CBAdvertisementDataServiceDataKey])
            let txPower = (advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber)?.intValue
            let flags = rawFlags(from: advertisementData)

            if let index = devices.firstIndex(where: { $0.id == id }) {
                devices[index].name = name
                devices[index].rssi = RSSI.intValue
                devices[index].isConnectable = connectable
                devices[index].advertisementCount += 1
                devices[index].serviceUUIDs = serviceUUIDs
                devices[index].manufacturerData = manufacturer
                devices[index].serviceData = serviceData
                devices[index].txPower = txPower
                devices[index].lastSeen = now
                devices[index].rawFlags = flags
            } else {
                devices.append(WatchBleDevice(
                    id: id, name: name, rssi: RSSI.intValue,
                    isConnectable: connectable, advertisementCount: 1,
                    serviceUUIDs: serviceUUIDs, manufacturerData: manufacturer,
                    serviceData: serviceData, txPower: txPower,
                    lastSeen: now, rawFlags: flags
                ))
            }

            devices.sort { $0.rssi > $1.rssi }
            if devices.count > maximumDevices {
                devices.removeLast(devices.count - maximumDevices)
            }
        }
    }
}
