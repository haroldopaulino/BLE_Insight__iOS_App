import CoreBluetooth
import Foundation

final class CoreBluetoothScanner: NSObject, BleScanning, @unchecked Sendable {
    var onDeviceFound: (@MainActor @Sendable (BleDevice) -> Void)?
    var onStateChanged: (@MainActor @Sendable (BluetoothPowerState) -> Void)?
    private var centralManager: CBCentralManager?
    private var devices: [UUID: BleDevice] = [:]
    private(set) var currentState: BluetoothPowerState = .unknown

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func startScanning() {
        guard currentState == .poweredOn else {
            sendStateChanged(currentState)
            return
        }

        devices.removeAll()
        centralManager?.scanForPeripherals(
            withServices: nil,
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true
            ]
        )
    }

    func stopScanning() {
        centralManager?.stopScan()
    }

    private func updateState(_ state: BluetoothPowerState) {
        currentState = state
        sendStateChanged(state)
    }

    private func sendStateChanged(_ state: BluetoothPowerState) {
        guard let onStateChanged else {
            return
        }

        Task { @MainActor in
            onStateChanged(state)
        }
    }

    private func sendDeviceFound(_ device: BleDevice) {
        guard let onDeviceFound else {
            return
        }

        Task { @MainActor in
            onDeviceFound(device)
        }
    }

    private func makeDevice(
        peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi: NSNumber
    ) -> BleDevice {
        let now = Date()
        let existing = devices[peripheral.identifier]
        let name = peripheral.name
            ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String
            ?? "Unknown Device"
        let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool ?? false
        let serviceUUIDs = (advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID])?.map(\.uuidString) ?? []
        let manufacturerDataSize = (advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data)?.count ?? 0

        return BleDevice(
            id: peripheral.identifier,
            name: name,
            rssi: rssi.intValue,
            identifier: peripheral.identifier.uuidString,
            advertisementCount: (existing?.advertisementCount ?? 0) + 1,
            firstSeen: existing?.firstSeen ?? now,
            lastSeen: now,
            connectable: connectable,
            serviceUUIDs: serviceUUIDs,
            manufacturerDataSize: manufacturerDataSize
        )
    }
}

extension CoreBluetoothScanner: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            updateState(.unknown)
        case .resetting:
            updateState(.resetting)
        case .unsupported:
            updateState(.unsupported)
        case .unauthorized:
            updateState(.unauthorized)
        case .poweredOff:
            updateState(.poweredOff)
        case .poweredOn:
            updateState(.poweredOn)
        @unknown default:
            updateState(.unknown)
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        let device = makeDevice(
            peripheral: peripheral,
            advertisementData: advertisementData,
            rssi: RSSI
        )
        devices[peripheral.identifier] = device
        sendDeviceFound(device)
    }
}
