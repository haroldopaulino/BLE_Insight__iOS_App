import SwiftUI

struct AdvertisementFlagsScreen: View {
    let device: BleDevice
    var body: some View {
        ZStack {
            BLETheme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(device.decodedFlags) { flag in flagRow(flag) }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Raw Flags").font(.headline)
                        Text(device.rawFlags.map { "\(device.flagsHex) (\($0))" } ?? "Not exposed by iOS")
                            .font(.title3.monospaced().bold()).foregroundStyle(device.rawFlags == nil ? .orange : BLETheme.cyan)
                        Text("CoreBluetooth normally omits the GAP Flags AD structure. A value is decoded only when compatible firmware mirrors it in manufacturer data.")
                            .font(.caption).foregroundStyle(BLETheme.muted)
                    }.padding(16).frame(maxWidth:.infinity,alignment:.leading).background(BLETheme.card,in:RoundedRectangle(cornerRadius:20))
                    legend
                }.padding(16)
            }
        }
        .navigationTitle("Advertisement Flags").navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(BLETheme.background, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
    }
    private func flagRow(_ flag: AdvertisementFlag) -> some View {
        HStack(spacing: 13) {
            Image(systemName: flag.isSet == true ? "checkmark.circle.fill" : flag.isSet == false ? "circle" : "questionmark.circle.fill")
                .font(.title2).foregroundStyle(flag.isSet == true ? BLETheme.green : flag.isSet == false ? BLETheme.muted : .orange)
            VStack(alignment:.leading,spacing:3){ Text(flag.title).font(.headline); Text(flag.detail).font(.caption).foregroundStyle(BLETheme.muted) }
            Spacer(); Text("Bit \(flag.bit)").font(.caption2.monospaced()).foregroundStyle(BLETheme.cyan)
        }.padding(15).background(BLETheme.card,in:RoundedRectangle(cornerRadius:18))
    }
    private var legend: some View { HStack { Label("Set",systemImage:"circle.fill").foregroundStyle(BLETheme.green); Spacer(); Label("Not Set",systemImage:"circle").foregroundStyle(BLETheme.muted); Spacer(); Label("Unknown",systemImage:"questionmark.circle.fill").foregroundStyle(.orange) }.font(.caption) }
}
