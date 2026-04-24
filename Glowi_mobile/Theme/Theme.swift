import SwiftUI

enum Theme {
    // MARK: - Backgrounds
    static let bgTop = Color(hex: "#F7F3F0")
    static let bgMid = Color(hex: "#F5EFEB")
    static let bgBottom = Color(hex: "#F2ECE8")

    static let backgroundGradient = LinearGradient(
        colors: [bgTop, bgMid, bgBottom],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Surfaces
    static let card = Color(hex: "#FFF8F4")
    static let softSurface = Color(hex: "#FCF6F2")
    static let elevatedSurface = Color.white.opacity(0.72)

    // MARK: - Brand colors
    static let pink = Color(hex: "#EFB6B6")
    static let pinkDark = Color(hex: "#E28F95")

    static let blue = Color(hex: "#BFD7EA")
    static let blueDark = Color(hex: "#7FB6D9")

    static let green = Color(hex: "#DCE7DF")
    static let greenDark = Color(hex: "#9FB7A7")

    static let yellow = Color(hex: "#F3D9A7")
    static let yellowDark = Color(hex: "#D8B36C")

    static let peach = Color(hex: "#F3C8BC")
    static let lavender = Color(hex: "#DCCFE8")
    static let cream = Color(hex: "#F9F2EC")

    // MARK: - Text
    static let textPrimary = Color(hex: "#4A3F3A")
    static let textSecondary = Color(hex: "#8E7F78")
    static let textMuted = Color(hex: "#B6AAA3")
    static let textOnDark = Color.white

    // MARK: - Status
    static let success = Color(hex: "#B8D7C2")
    static let warning = Color(hex: "#EBCB8B")
    static let error = Color(hex: "#E6A4A4")
    static let info = Color(hex: "#BFD7EA")

    // MARK: - Strokes
    static let stroke = Color.white.opacity(0.82)
    static let softStroke = Color(hex: "#E8DCD5")

    // MARK: - Shadows
    static let shadow = Color.black.opacity(0.06)
    static let softShadow = Color.black.opacity(0.035)
    static let pinkGlow = pink.opacity(0.16)
    static let blueGlow = blue.opacity(0.16)

    // MARK: - Gradients
    static let primaryButtonGradient = LinearGradient(
        colors: [
            Color(hex: "#F3C8BC"),
            Color(hex: "#EFB6B6"),
            Color(hex: "#DCCFE8")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let accentGradient = LinearGradient(
        colors: [
            Color(hex: "#F4D6D1"),
            Color(hex: "#E7D8F1"),
            Color(hex: "#D8E7F2")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroRibbonGradient = LinearGradient(
        colors: [
            Color(hex: "#F2D0D0"),
            Color(hex: "#E5D7EF"),
            Color(hex: "#D4E5F1")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let softPinkGradient = LinearGradient(
        colors: [
            Color(hex: "#F5D1CB"),
            Color(hex: "#EFB6B6")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Layout tokens
    static let screenPadding: CGFloat = 20
    static let cardPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 16

    static let radiusSmall: CGFloat = 12
    static let radiusMedium: CGFloat = 16
    static let radiusLarge: CGFloat = 20
    static let radiusXLarge: CGFloat = 24
    static let radiusHero: CGFloat = 28

    // MARK: - Backward compatibility
    static let cyan = Theme.blue
    static let cyanDark = Theme.blueDark
    static let gold = Theme.yellow
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 255, 255, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
