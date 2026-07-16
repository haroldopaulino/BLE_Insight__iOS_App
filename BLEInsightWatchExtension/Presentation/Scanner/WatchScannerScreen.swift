import SwiftUI

struct WatchScannerScreen: View {
    @State private var viewModel = WatchScannerViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                WatchBLETheme.background.ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 8) {
                        header
                        scanButton
                        if viewModel.state != .poweredOn {
                            Text(viewModel.state.title)
                                .font(.caption2)
                                .foregroundStyle(.orange)
                        }
                        if viewModel.devices.isEmpty {
                            emptyState
                        } else {
                            ForEach(viewModel.devices) { device in
                                NavigationLink(value: device) {
                                    WatchDeviceRow(device: device)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 8)
                }
            }
            .navigationDestination(for: WatchBleDevice.self) {
                WatchDeviceDetailsScreen(device: $0)
            }
        }
        .tint(WatchBLETheme.cyan)
    }

    private var header: some View {
        VStack(spacing: 4) {
            WatchGradientIcon(systemName: "bolt.horizontal.circle.fill", size: 38)
            Text("BLE Insight")
                .font(.headline)
                .foregroundStyle(WatchBLETheme.gradient)
            Text("\(viewModel.devices.count) nearby")
                .font(.caption2)
                .foregroundStyle(WatchBLETheme.muted)
        }
    }

    private var scanButton: some View {
        Button(action: viewModel.toggleScan) {
            Label(
                viewModel.isScanning ? "Stop Scan" : "Start Scan",
                systemImage: viewModel.isScanning ? "stop.fill" : "dot.radiowaves.left.and.right"
            )
            .font(.caption.bold())
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(viewModel.isScanning ? WatchBLETheme.purple : WatchBLETheme.cyan)
        .disabled(viewModel.state != .poweredOn)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            WatchGradientIcon(systemName: "sensor.tag.radiowaves.forward", size: 48)
            Text(viewModel.isScanning ? "Scanning…" : "No devices")
                .font(.caption.bold())
            Text("Scans stop after 20 seconds to preserve battery.")
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundStyle(WatchBLETheme.muted)
        }
        .padding(.vertical, 12)
    }
}
