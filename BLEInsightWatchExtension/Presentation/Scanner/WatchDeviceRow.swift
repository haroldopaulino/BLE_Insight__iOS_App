import SwiftUI

struct WatchDeviceRow: View {
    let device: WatchBleDevice

    var body: some View {
        HStack(spacing: 8) {
            WatchGradientIcon(systemName: "antenna.radiowaves.left.and.right", size: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text(device.displayName)
                    .font(.caption.bold())
                    .lineLimit(1)
                Text(device.signalQuality)
                    .font(.caption2)
                    .foregroundStyle(WatchBLETheme.muted)
            }
            Spacer(minLength: 2)
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(device.rssi)")
                    .font(.caption.bold())
                    .foregroundStyle(WatchBLETheme.cyan)
                Text("dBm")
                    .font(.system(size: 9))
                    .foregroundStyle(WatchBLETheme.muted)
            }
        }
        .padding(8)
        .background(WatchBLETheme.card, in: RoundedRectangle(cornerRadius: 14))
    }
}
