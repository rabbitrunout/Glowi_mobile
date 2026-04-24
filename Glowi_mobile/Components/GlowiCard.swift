import SwiftUI

struct GlowiCard<Content: View>: View {
    let padding: CGFloat
    let content: Content

    init(
        padding: CGFloat = Theme.cardPadding,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusXLarge, style: .continuous)
                .fill(Theme.card.opacity(0.94))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusXLarge, style: .continuous)
                .stroke(Theme.stroke.opacity(0.9), lineWidth: 1)
        )
        .shadow(color: Theme.shadow.opacity(0.5), radius: 8, x: 0, y: 4)
    }
}

struct GlowiHeroCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusHero, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.90),
                            Theme.card.opacity(0.96)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusHero, style: .continuous)
                .stroke(Theme.stroke.opacity(0.95), lineWidth: 1)
        )
        .shadow(color: Theme.shadow.opacity(0.58), radius: 12, x: 0, y: 6)
    }
}

struct GlowiCompactCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusMedium, style: .continuous)
                .fill(Theme.softSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusMedium, style: .continuous)
                .stroke(Theme.softStroke, lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 16) {
            GlowiCard {
                Text("Standard Card")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }

            GlowiHeroCard {
                Text("Hero Card")
                    .font(.headline)
                    .foregroundColor(Theme.textPrimary)
            }

            GlowiCompactCard {
                Text("Compact Card")
                    .font(.subheadline)
                    .foregroundColor(Theme.textPrimary)
            }
        }
        .padding(20)
    }
}
