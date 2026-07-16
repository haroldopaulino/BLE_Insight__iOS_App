import SwiftUI

struct DeviceDetailsScreen: View {
    let device: BleDevice
    var body: some View {
        ZStack {
            BLETheme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    hero
                    detailSection
                    NavigationLink { AdvertisementFlagsScreen(device: device) } label: { flagsCard }.buttonStyle(.plain)
                    dataSection("Service UUIDs", icon: "point.3.connected.trianglepath.dotted", values: device.serviceUUIDs)
                    dataSection("Manufacturer Data", icon: "cpu", values: device.manufacturerData.map { [$0.hexString] } ?? [])
                    dataSection("Service Data", icon: "square.stack.3d.up", values: device.serviceData.map { "\($0.key): \($0.value.hexString)" })
                    dataSection("Raw Advertisement", icon: "doc.text.magnifyingglass", values: device.rawAdvertisement.sorted(by: {$0.key < $1.key}).map { "\($0.key): \($0.value)" })
                }.padding(16).padding(.bottom, 28)
            }
        }
        .navigationTitle("Device Details").navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(BLETheme.background, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
    }

    private var hero: some View {
        HStack(spacing: 14) {
            GradientIcon(systemName: "antenna.radiowaves.left.and.right", size: 62)
            VStack(alignment: .leading, spacing: 5) { Text(device.displayName).font(.title3.bold()); Text(device.identifierText).font(.caption2.monospaced()).foregroundStyle(BLETheme.muted).textSelection(.enabled); HStack { StatusChip(icon: "link", text: device.connectableText); StatusChip(icon: "chart.bar.fill", text: device.signalQuality, color: BLETheme.green) } }
            Spacer(); VStack(alignment: .trailing) { Text("\(device.rssi)").font(.title.bold()).foregroundStyle(BLETheme.cyan); Text("dBm").font(.caption).foregroundStyle(BLETheme.muted) }
        }.padding(16).background(BLETheme.card, in: RoundedRectangle(cornerRadius: 22))
    }

    private var detailSection: some View {
        VStack(spacing: 0) {
            row("Identifier", device.identifierText)
            row("Address", "Unavailable on iOS")
            row("Advertising Type", device.connectableText)
            row("Bond State", "Unavailable on iOS")
            row("Primary PHY", "Not exposed during scan")
            row("TX Power", device.txPower.map { "\($0) dBm" } ?? "N/A")
            row("RSSI", "\(device.rssi) dBm")
            row("Advertisements", "\(device.advertisementCount)")
            row("Last Seen", device.lastSeen.formatted(date: .omitted, time: .standard))
        }.background(BLETheme.card, in: RoundedRectangle(cornerRadius: 20))
    }

    private var flagsCard: some View {
        HStack { GradientIcon(systemName: "flag.checkered", size: 46); VStack(alignment: .leading, spacing: 4) { Text("Advertisement Flags").font(.headline); Text(device.rawFlags == nil ? "Raw GAP flags are not exposed by CoreBluetooth" : "Flags \(device.rawFlags!) • \(device.flagsHex)").font(.subheadline).foregroundStyle(BLETheme.muted) }; Spacer(); Image(systemName: "chevron.right").foregroundStyle(BLETheme.cyan) }.padding(16).background(BLETheme.card, in: RoundedRectangle(cornerRadius: 20))
    }
    private func row(_ title:String,_ value:String) -> some View { HStack(alignment:.top) { Text(title).foregroundStyle(BLETheme.muted); Spacer(); Text(value).multilineTextAlignment(.trailing).textSelection(.enabled) }.font(.subheadline).padding(14).overlay(alignment:.bottom){ Divider().overlay(Color.white.opacity(0.07)) } }
    private func dataSection(_ title:String,icon:String,values:[String]) -> some View { VStack(alignment:.leading,spacing:12){ Label(title,systemImage:icon).font(.headline).foregroundStyle(BLETheme.cyan); if values.isEmpty { Text("No \(title.lowercased()) found").foregroundStyle(BLETheme.muted) } else { ForEach(values,id:\.self){ Text($0).font(.caption.monospaced()).textSelection(.enabled).frame(maxWidth:.infinity,alignment:.leading) } } }.padding(16).frame(maxWidth:.infinity,alignment:.leading).background(BLETheme.card,in:RoundedRectangle(cornerRadius:20)) }
}

private extension Data { var hexString:String { map{String(format:"%02X",$0)}.joined(separator:" ") } }
