import SwiftUI

struct DeviceCard: View {
    let device: BleDevice
    var body: some View {
        HStack(spacing: 14) {
            GradientIcon(systemName: "antenna.radiowaves.left.and.right", size: 50)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(device.displayName).font(.headline).lineLimit(1)
                        Text(device.identifierText).font(.caption2.monospaced()).foregroundStyle(BLETheme.muted).lineLimit(1)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("\(device.rssi)").font(.title3.bold()).foregroundStyle(BLETheme.cyan)
                        Text("dBm").font(.caption2).foregroundStyle(BLETheme.muted)
                    }
                    Image(systemName: "chevron.right").foregroundStyle(BLETheme.muted)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        StatusChip(icon: "chart.bar.fill", text: device.signalQuality, color: BLETheme.green)
                        StatusChip(icon: "link", text: device.connectableText)
                        StatusChip(icon: "flag.fill", text: device.rawFlags.map(String.init) ?? "Flags N/A", color: BLETheme.purple)
                    }
                }
            }
        }
        .padding(14).background(BLETheme.card, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.07)))
    }
}
