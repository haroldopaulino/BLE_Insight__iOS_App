import SwiftUI

enum WatchBLETheme {
    static let background = Color(red: 0.035, green: 0.045, blue: 0.08)
    static let card = Color(red: 0.075, green: 0.085, blue: 0.14)
    static let purple = Color(red: 0.55, green: 0.33, blue: 0.96)
    static let cyan = Color(red: 0.22, green: 0.83, blue: 0.88)
    static let green = Color(red: 0.31, green: 0.87, blue: 0.56)
    static let muted = Color.white.opacity(0.62)
    static let gradient = LinearGradient(colors: [purple, cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct WatchGradientIcon: View {
    let systemName: String
    var size: CGFloat = 34
    var body: some View {
        ZStack {
            Circle().fill(WatchBLETheme.gradient.opacity(0.22))
            Circle().stroke(WatchBLETheme.gradient, lineWidth: 1)
            Image(systemName: systemName)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(WatchBLETheme.gradient)
        }
        .frame(width: size, height: size)
    }
}
