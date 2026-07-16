import SwiftUI

struct WatchDeviceDetailsScreen: View {
    let device: WatchBleDevice

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                WatchGradientIcon(systemName: "antenna.radiowaves.left.and.right", size: 46)
                Text(device.displayName)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("\(device.rssi) dBm • \(device.signalQuality)")
                    .font(.caption)
                    .foregroundStyle(WatchBLETheme.cyan)

                detailCard

                NavigationLink {
                    WatchAdvertisementFlagsScreen(device: device)
                } label: {
                    Label("Advertisement Flags", systemImage: "flag.checkered")
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(WatchBLETheme.purple)

                valuesCard("Services", values: device.serviceUUIDs)
                valuesCard("Manufacturer", values: device.manufacturerData.map { [$0.watchHexString] } ?? [])
                valuesCard("Service Data", values: device.serviceData.map { "\($0.key): \($0.value.watchHexString)" })
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Details")
    }

    private var detailCard: some View {
        VStack(spacing: 6) {
            detail("Connectable", device.connectableText)
            detail("TX Power", device.txPower.map { "\($0) dBm" } ?? "N/A")
            detail("Packets", "\(device.advertisementCount)")
            detail("Flags", device.flagsHex)
            detail("Identifier", String(device.identifierText.prefix(8)) + "…")
        }
        .padding(9)
        .background(WatchBLETheme.card, in: RoundedRectangle(cornerRadius: 14))
    }

    private func detail(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(WatchBLETheme.muted)
            Spacer()
            Text(value).multilineTextAlignment(.trailing)
        }
        .font(.caption2)
    }

    private func valuesCard(_ title: String, values: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.caption.bold()).foregroundStyle(WatchBLETheme.cyan)
            if values.isEmpty {
                Text("None found").font(.caption2).foregroundStyle(WatchBLETheme.muted)
            } else {
                ForEach(values.prefix(8), id: \.self) {
                    Text($0).font(.system(size: 9, design: .monospaced))
                }
            }
        }
        .padding(9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(WatchBLETheme.card, in: RoundedRectangle(cornerRadius: 14))
    }
}

private extension Data {
    var watchHexString: String { map { String(format: "%02X", $0) }.joined(separator: " ") }
}
