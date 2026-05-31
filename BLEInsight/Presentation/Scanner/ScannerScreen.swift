import SwiftUI

struct ScannerScreen: View {
    @Bindable var viewModel: ScannerViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HeroCard(
                        isScanning: viewModel.isScanning,
                        state: viewModel.powerState,
                        onStart: viewModel.startScan,
                        onStop: viewModel.stopScan
                    )

                    StatsCard(
                        deviceCount: viewModel.devices.count,
                        strongestRssi: viewModel.strongestRssiText,
                        status: viewModel.isScanning ? "Active" : "Idle"
                    )

                    if let message = viewModel.message {
                        MessageCard(message: message)
                    }

                    if viewModel.devices.isEmpty {
                        EmptyStateCard(isScanning: viewModel.isScanning)
                    } else {
                        DeviceSection(devices: viewModel.devices)
                    }
                }
                .padding(16)
            }
            .background(BLEInsightTheme.background.ignoresSafeArea())
            .navigationTitle("BLE Insight")
            .navigationBarTitleDisplayMode(.large)
        }
        .tint(BLEInsightTheme.primary)
    }
}

private struct HeroCard: View {
    let isScanning: Bool
    let state: BluetoothPowerState
    let onStart: () -> Void
    let onStop: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isScanning ? BLEInsightTheme.primary : BLEInsightTheme.surfaceHigh)
                        .frame(width: 68, height: 68)

                    Image(systemName: isScanning ? "dot.radiowaves.left.and.right" : "antenna.radiowaves.left.and.right")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(isScanning ? .black : BLEInsightTheme.primary)
                        .symbolEffect(.pulse, options: .repeating, value: isScanning)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(isScanning ? "Scanning nearby devices" : state.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(BLEInsightTheme.textPrimary)

                    Text(isScanning ? "Listening for BLE advertisements in real time." : state.message)
                        .font(.subheadline)
                        .foregroundStyle(BLEInsightTheme.textSecondary)
                }
            }

            if isScanning {
                ProgressView()
                    .progressViewStyle(.linear)
                    .tint(BLEInsightTheme.primary)
            }

            HStack(spacing: 12) {
                Button(action: onStart) {
                    Label("Start Scan", systemImage: "dot.radiowaves.left.and.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isScanning)

                Button(action: onStop) {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(!isScanning)
            }
        }
        .padding(20)
        .background(BLEInsightTheme.surfaceHigh, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct StatsCard: View {
    let deviceCount: Int
    let strongestRssi: String
    let status: String

    var body: some View {
        HStack {
            StatView(title: "Devices", value: "\(deviceCount)")
            Spacer()
            StatView(title: "Strongest RSSI", value: strongestRssi)
            Spacer()
            StatView(title: "Status", value: status)
        }
        .padding(18)
        .background(BLEInsightTheme.surface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct StatView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(BLEInsightTheme.textPrimary)

            Text(title)
                .font(.caption)
                .foregroundStyle(BLEInsightTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MessageCard: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(BLEInsightTheme.secondary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(BLEInsightTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(BLEInsightTheme.surface, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct EmptyStateCard: View {
    let isScanning: Bool

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "sensor.tag.radiowaves.forward")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(BLEInsightTheme.primary)

            Text(isScanning ? "Waiting for advertisements" : "No devices yet")
                .font(.headline.weight(.semibold))
                .foregroundStyle(BLEInsightTheme.textPrimary)

            Text(isScanning ? "BLE devices will appear here as soon as iOS receives advertisements." : "Start scanning to discover nearby watches, sensors, beacons, phones, and accessories.")
                .font(.subheadline)
                .foregroundStyle(BLEInsightTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(BLEInsightTheme.surface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct DeviceSection: View {
    let devices: [BleDevice]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Discovered devices")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(BLEInsightTheme.textPrimary)

                Spacer()

                Text("\(devices.count) found")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(BLEInsightTheme.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(BLEInsightTheme.surfaceHigh, in: Capsule())
            }

            ForEach(devices) { device in
                DeviceCard(device: device)
            }
        }
    }
}
