import SwiftUI

enum BLETheme {
    static let background = Color(red: 0.035, green: 0.045, blue: 0.08)
    static let card = Color(red: 0.075, green: 0.085, blue: 0.14)
    static let cardElevated = Color(red: 0.105, green: 0.11, blue: 0.18)
    static let purple = Color(red: 0.55, green: 0.33, blue: 0.96)
    static let cyan = Color(red: 0.22, green: 0.83, blue: 0.88)
    static let green = Color(red: 0.31, green: 0.87, blue: 0.56)
    static let muted = Color.white.opacity(0.62)
    static let gradient = LinearGradient(colors: [purple, cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct GradientIcon: View {
    let systemName: String
    var size: CGFloat = 44
    var body: some View {
        ZStack {
            Circle().fill(BLETheme.gradient.opacity(0.22))
            Circle().stroke(BLETheme.gradient, lineWidth: 1.5)
            Image(systemName: systemName).font(.system(size: size * 0.42, weight: .semibold)).foregroundStyle(BLETheme.gradient)
        }.frame(width: size, height: size)
    }
}

struct StatusChip: View {
    let icon: String
    let text: String
    var color: Color = BLETheme.cyan
    var body: some View {
        Label(text, systemImage: icon).font(.caption.weight(.semibold)).foregroundStyle(color)
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(color.opacity(0.12), in: Capsule()).overlay(Capsule().stroke(color.opacity(0.28)))
    }
}
