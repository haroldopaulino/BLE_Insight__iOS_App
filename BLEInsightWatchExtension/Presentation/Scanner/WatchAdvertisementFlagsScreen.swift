import SwiftUI

struct WatchAdvertisementFlagsScreen: View {
    let device: WatchBleDevice

    var body: some View {
        ScrollView {
            VStack(spacing: 7) {
                Text(device.rawFlags.map { "\(device.flagsHex) (\($0))" } ?? "Not exposed by iOS")
                    .font(.caption.monospaced().bold())
                    .foregroundStyle(device.rawFlags == nil ? .orange : WatchBLETheme.cyan)

                ForEach(device.decodedFlags) { flag in
                    HStack(spacing: 7) {
                        Image(systemName: flag.isSet == true ? "checkmark.circle.fill" : flag.isSet == false ? "circle" : "questionmark.circle.fill")
                            .foregroundStyle(flag.isSet == true ? WatchBLETheme.green : flag.isSet == false ? WatchBLETheme.muted : .orange)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(flag.title).font(.caption2.bold())
                            Text("Bit \(flag.bit)").font(.system(size: 9)).foregroundStyle(WatchBLETheme.muted)
                        }
                        Spacer()
                    }
                    .padding(7)
                    .background(WatchBLETheme.card, in: RoundedRectangle(cornerRadius: 12))
                }

                Text("CoreBluetooth normally omits the GAP Flags structure. A value is decoded only when firmware mirrors it in manufacturer data.")
                    .font(.system(size: 9))
                    .foregroundStyle(WatchBLETheme.muted)
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Flags")
    }
}
