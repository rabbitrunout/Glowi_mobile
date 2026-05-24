import SwiftUI



struct GlowiSectionTitle: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Theme.gold)
                .font(.system(size: 15, weight: .semibold))

            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

struct GlowiInfoRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    var accent: Color = Theme.cyanDark

    var body: some View {
        GlowiCompactCard {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.14))
                        .frame(width: 42, height: 42)

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()
            }
        }
    }
}

struct GlowiAssetInfoRow: View {
    let assetName: String
    let title: String
    let subtitle: String?
    var accent: Color = Theme.cyanDark

    var body: some View {
        GlowiCompactCard {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.14))
                        .frame(width: 42, height: 42)

                    GlowiAssetIcon(name: assetName, size: 22)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()
            }
        }
    }
}

struct GlowiCompactRow: View {
    let icon: String
    let title: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .foregroundColor(Theme.cyanDark)
                    .font(.system(size: 18, weight: .medium))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .foregroundColor(Theme.textPrimary)
                    .font(.subheadline.weight(.semibold))

                if let subtitle {
                    Text(subtitle)
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textMuted)
                .font(.system(size: 13, weight: .medium))
        }
        .padding(10)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct GlowiAssetCompactRow: View {
    let assetName: String
    let title: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 42, height: 42)

                GlowiAssetIcon(name: assetName, size: 20)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .foregroundColor(Theme.textPrimary)
                    .font(.subheadline.weight(.semibold))

                if let subtitle {
                    Text(subtitle)
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textMuted)
                .font(.system(size: 13, weight: .medium))
        }
        .padding(10)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}


