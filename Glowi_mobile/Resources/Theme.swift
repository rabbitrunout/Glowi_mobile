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
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.92),
            Color.white.opacity(0.78)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Brand Colors
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

    // MARK: - Role Colors

    // Parent App — warm, family, payments, care
    static let parentAccent = pinkDark
    static let parentSoft = pink.opacity(0.16)
    static let parentGradient = LinearGradient(
        colors: [
            Color(hex: "#F8D7D2"),
            Color(hex: "#EFB6B6"),
            Color(hex: "#FFF1ED")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Athlete / Child View — playful, progress, motivation
    static let athleteAccent = Color(hex: "#9B7BC7")
    static let athleteSoft = lavender.opacity(0.22)
    static let athleteGradient = LinearGradient(
        colors: [
            Color(hex: "#EADDF5"),
            Color(hex: "#F4D6E8"),
            Color(hex: "#FFF1F5")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Coach Portal — professional, operational, results
    static let coachAccent = blueDark
    static let coachSoft = blue.opacity(0.18)
    static let coachGradient = LinearGradient(
        colors: [
            Color(hex: "#DCECF7"),
            Color(hex: "#EAF4FB"),
            Color(hex: "#FFFFFF")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Admin Dashboard — secure, system, permissions
    static let adminAccent = Color(hex: "#4F9B75")
    static let adminSoft = Color(hex: "#DCEFE5")
    static let adminGradient = LinearGradient(
        colors: [
            Color(hex: "#E6F4EC"),
            Color(hex: "#F4FAF6"),
            Color(hex: "#FFFFFF")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Public Rankings — public results / verified data
    static let rankingAccent = yellowDark
    static let rankingSoft = yellow.opacity(0.20)

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

    // MARK: - Layout Tokens
    static let screenPadding: CGFloat = 20
    static let cardPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 16

    static let radiusSmall: CGFloat = 12
    static let radiusMedium: CGFloat = 16
    static let radiusLarge: CGFloat = 20
    static let radiusXLarge: CGFloat = 24
    static let radiusHero: CGFloat = 28

    // MARK: - Backward Compatibility
    static let cyan = Theme.blue
    static let cyanDark = Theme.blueDark
    static let gold = Theme.yellow
}

// MARK: - Role Helper
enum AppRole {
    case parent
    case athlete
    case coach
    case admin
}

extension Theme {
    static func accent(for role: AppRole) -> Color {
        switch role {
        case .parent:
            return parentAccent
        case .athlete:
            return athleteAccent
        case .coach:
            return coachAccent
        case .admin:
            return adminAccent
        }
    }
}

// MARK: - HEX Support
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
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.92),
            Color.white.opacity(0.78)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
