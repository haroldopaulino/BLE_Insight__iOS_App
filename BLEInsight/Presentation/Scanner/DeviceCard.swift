import SwiftUI

struct DeviceCard: View {
    let device: BleDevice

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(BLEInsightTheme.surface)
                        .frame(width: 54, height: 54)

                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(BLEInsightTheme.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(BLEInsightTheme.textPrimary)
                        .lineLimit(1)

                    Text(shortIdentifier(device.identifier))
                        .font(.subheadline.monospaced())
                        .foregroundStyle(BLEInsightTheme.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(device.rssi)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(BLEInsightTheme.textPrimary)

                    Text("dBm")
                        .font(.caption)
                        .foregroundStyle(BLEInsightTheme.textSecondary)
                }
            }

            SignalMeter(rssi: device.rssi)

            HStack {
                DeviceChip(title: device.signalQuality.rawValue, systemImage: "cellularbars")
                DeviceChip(title: device.connectable ? "Connectable" : "Advertiser", systemImage: device.connectable ? "link" : "dot.radiowaves.left.and.right")
                DeviceChip(title: "\(device.advertisementCount)x", systemImage: "number")
            }

            if !device.serviceUUIDs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Services")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(BLEInsightTheme.textSecondary)

                    ForEach(device.serviceUUIDs.prefix(3), id: \.self) { uuid in
                        Text(uuid)
                            .font(.caption.monospaced())
                            .foregroundStyle(BLEInsightTheme.textPrimary)
                            .lineLimit(1)
                    }
                }
            }

            HStack {
                Label("Manufacturer data: \(device.manufacturerDataSize) bytes", systemImage: "memorychip")
                Spacer()
                Text(device.lastSeen, style: .time)
            }
            .font(.caption)
            .foregroundStyle(BLEInsightTheme.textSecondary)
        }
        .padding(16)
        .background(BLEInsightTheme.surfaceHigh, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func shortIdentifier(_ identifier: String) -> String {
        let parts = identifier.split(separator: "-")
        guard let first = parts.first, let last = parts.last else {
            return identifier
        }
        return "\(first)-\(last)"
    }
}

private struct SignalMeter: View {
    let rssi: Int

    private var normalized: CGFloat {
        let clamped = min(max(rssi, -100), -35)
        return CGFloat(clamped + 100) / 65
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(BLEInsightTheme.surface)

                Capsule()
                    .fill(LinearGradient(
                        colors: [BLEInsightTheme.secondary, BLEInsightTheme.primary, BLEInsightTheme.tertiary],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: proxy.size.width * normalized)
            }
        }
        .frame(height: 8)
    }
}

private struct DeviceChip: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.semibold))
            .foregroundStyle(BLEInsightTheme.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(BLEInsightTheme.surface, in: Capsule())
    }
}
