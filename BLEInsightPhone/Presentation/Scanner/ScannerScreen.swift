import SwiftUI

struct ScannerScreen: View {
    @State private var viewModel = ScannerViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                BLETheme.background.ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 14) {
                        header
                        scanCard
                        stats
                        HStack { Text("Discovered Devices").font(.title3.bold()); Spacer(); Text("\(viewModel.devices.count) found").font(.caption.bold()).foregroundStyle(BLETheme.cyan) }
                        if viewModel.devices.isEmpty { emptyState } else {
                            ForEach(viewModel.devices) { device in
                                NavigationLink(value: device) { DeviceCard(device: device) }.buttonStyle(.plain)
                            }
                        }
                    }.padding(.horizontal, 16).padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: BleDevice.self) { DeviceDetailsScreen(device: $0) }
        }.tint(BLETheme.cyan)
    }

    private var header: some View {
        HStack(spacing: 12) {
            GradientIcon(systemName: "bolt.horizontal.circle.fill", size: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text("BLE Insight").font(.largeTitle.bold()).foregroundStyle(BLETheme.gradient)
                Text("Nearby Bluetooth Low Energy devices").font(.subheadline).foregroundStyle(BLETheme.muted)
            }
            Spacer()
        }.padding(.top, 8)
    }

    private var scanCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 13) {
                GradientIcon(systemName: viewModel.isScanning ? "dot.radiowaves.left.and.right" : "wave.3.right.circle", size: 54)
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.isScanning ? "Scanning nearby devices" : "Ready to scan").font(.headline)
                    Text(viewModel.isScanning ? "Listening for BLE advertisements in real time." : "Start a scan to discover nearby BLE devices.").font(.subheadline).foregroundStyle(BLETheme.muted)
                }
                Spacer()
            }
            if viewModel.isScanning { ProgressView().tint(BLETheme.purple).frame(maxWidth: .infinity) }
            Button(action: viewModel.toggleScan) {
                Label(viewModel.isScanning ? "Stop Scan" : "Start Scan", systemImage: viewModel.isScanning ? "stop.fill" : "play.fill")
                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(BLETheme.gradient, in: RoundedRectangle(cornerRadius: 14)).foregroundStyle(.white)
            }.disabled(viewModel.state != .poweredOn)
            if viewModel.state != .poweredOn { Text(viewModel.state.title).font(.caption).foregroundStyle(.orange) }
        }.padding(18).background(BLETheme.card, in: RoundedRectangle(cornerRadius: 24))
    }

    private var stats: some View {
        HStack { stat("\(viewModel.devices.count)", "Devices"); Divider().overlay(Color.white.opacity(0.12)); stat(viewModel.strongestRSSI, "Strongest RSSI"); Divider().overlay(Color.white.opacity(0.12)); stat(viewModel.isScanning ? "Active" : "Idle", "Status") }
            .frame(height: 68).padding(.horizontal).background(BLETheme.cardElevated, in: RoundedRectangle(cornerRadius: 18))
    }
    private func stat(_ value: String,_ label: String) -> some View { VStack { Text(value).font(.headline).foregroundStyle(value == "Active" ? BLETheme.green : .white); Text(label).font(.caption2).foregroundStyle(BLETheme.muted) }.frame(maxWidth: .infinity) }
    private var emptyState: some View { VStack(spacing: 14) { GradientIcon(systemName: "sensor.tag.radiowaves.forward", size: 76); Text("No devices yet").font(.title3.bold()); Text("Start scanning to discover nearby beacons, watches, phones, sensors, and accessories.").multilineTextAlignment(.center).foregroundStyle(BLETheme.muted) }.padding(.vertical, 48).frame(maxWidth: .infinity) }
}
