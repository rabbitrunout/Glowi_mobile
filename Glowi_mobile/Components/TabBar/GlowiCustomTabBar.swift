import SwiftUI

struct GlowiCustomTabBar: View {
    @Binding var selectedTab: Tab
    var unreadCount: Int = 0

    @State private var animatedTab: Tab?

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Theme.card.opacity(0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Theme.softStroke.opacity(0.7), lineWidth: 1)
                )
        )
        .shadow(color: Theme.shadow.opacity(0.6), radius: 10, x: 0, y: 4)
    }

    private func tabButton(for tab: Tab) -> some View {
        let isActive = selectedTab == tab
        let isAnimating = animatedTab == tab

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                selectedTab = tab
                animatedTab = tab
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                animatedTab = nil
            }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(isActive ? AnyShapeStyle(Theme.softPinkGradient) : AnyShapeStyle(Color.clear))
                        .frame(width: 60, height: 44)
                        .shadow(
                            color: isActive ? Theme.pinkGlow.opacity(0.5) : .clear,
                            radius: 8,
                            x: 0,
                            y: 4
                        )

                    ZStack(alignment: .topTrailing) {
                        Image(tab.assetName)
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()
                            .frame(width: isActive ? 26 : 24, height: isActive ? 26 : 24)
                            .opacity(isActive ? 1.0 : 0.6)
                            .scaleEffect(isAnimating ? 1.18 : (isActive ? 1.05 : 1.0))
                            .offset(y: isAnimating ? -4 : 0)

                        if tab == .account && unreadCount > 0 {
                            Text(unreadCount > 9 ? "9+" : "\(unreadCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: unreadCount > 9 ? 20 : 16, height: 16)
                                .background(Theme.error)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white, lineWidth: 1.5)
                                )
                                .offset(x: 10, y: -8)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: unreadCount)
                        }
                    }
                }

                Text(tab.title)
                    .font(.system(size: 11, weight: isActive ? .semibold : .medium))
                    .foregroundColor(isActive ? Theme.pinkDark : Theme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var selectedTab: Tab = .home

        var body: some View {
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    GlowiCustomTabBar(
                        selectedTab: $selectedTab,
                        unreadCount: 2
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
        }
    }

    return PreviewHost()
}
