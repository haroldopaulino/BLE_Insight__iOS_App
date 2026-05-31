import Foundation
import Observation

@MainActor
@Observable
final class ScannerViewModel: @unchecked Sendable {
    private let scanner: BleScanning
    private var scanTimer: Timer?
    private let scanDurationSeconds: TimeInterval = 60

    var devices: [BleDevice] = []
    var powerState: BluetoothPowerState = .unknown
    var isScanning = false
    var message: String?

    var strongestRssiText: String {
        guard let strongest = devices.max(by: { $0.rssi < $1.rssi }) else {
            return "--"
        }
        return "\(strongest.rssi) dBm"
    }

    init(scanner: BleScanning) {
        self.scanner = scanner
        self.powerState = scanner.currentState
        self.message = scanner.currentState.message

        scanner.onDeviceFound = { [weak self] device in
            self?.upsert(device)
        }

        scanner.onStateChanged = { [weak self] state in
            self?.powerState = state
            self?.message = state.message
            if state != .poweredOn {
                self?.stopScan()
            }
        }
    }

    func startScan() {
        guard powerState == .poweredOn else {
            message = powerState.message
            return
        }

        devices.removeAll()
        message = "Scanning nearby BLE devices..."
        isScanning = true
        scanner.startScanning()

        scanTimer?.invalidate()
        scanTimer = Timer.scheduledTimer(withTimeInterval: scanDurationSeconds, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.finishScanIfNeeded()
            }
        }
    }

    func stopScan() {
        scanTimer?.invalidate()
        scanTimer = nil
        scanner.stopScanning()
        isScanning = false
    }

    private func finishScanIfNeeded() {
        guard isScanning else {
            return
        }

        stopScan()
        message = devices.isEmpty
            ? "No BLE devices found. Make sure nearby devices are advertising."
            : nil
    }

    private func upsert(_ device: BleDevice) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = device
        } else {
            devices.append(device)
        }

        devices.sort {
            if $0.rssi == $1.rssi {
                return $0.lastSeen > $1.lastSeen
            }
            return $0.rssi > $1.rssi
        }

        message = nil
    }
}
