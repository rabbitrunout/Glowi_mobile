import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            GlowiCustomTabBar(
                selectedTab: $selectedTab,
                unreadCount: dashboardVM.unreadNotificationsCount
            )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 10)
                .background(
                    LinearGradient(
                        colors: [
                            Theme.bgBottom.opacity(0),
                            Theme.bgBottom
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea(edges: .bottom)
                )
        }
        .animation(.easeInOut(duration: 0.18), value: selectedTab)
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch selectedTab {
        case .home:
            NavigationStack {
                DashboardView(selectedTab: $selectedTab)
                    .withTabBarSafeArea()
            }

        case .schedule:
            NavigationStack {
                ScheduleView()
                    .withTabBarSafeArea()
            }

        case .events:
            NavigationStack {
                EventsView()
                    .withTabBarSafeArea()
            }

        case .payments:
            NavigationStack {
                PaymentsView()
                    .withTabBarSafeArea()
            }

        case .account:
            NavigationStack {
                ParentProfileView()
                    .withTabBarSafeArea()
            }
        }
    }
}

enum Tab: CaseIterable {
    case home
    case schedule
    case events
    case payments
    case account

    var title: String {
        switch self {
        case .home: return "Home"
        case .schedule: return "Schedule"
        case .events: return "Events"
        case .payments: return "Payments"
        case .account: return "Account"
        }
    }

    var assetName: String {
        switch self {
        case .home: return "icon_home"
        case .schedule: return "icon_schedule"
        case .events: return "icon_events"
        case .payments: return "icon_payments"
        case .account: return "icon_account"
        }
    }
}

private struct TabBarSafeAreaModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 92)
            }
    }
}

private extension View {
    func withTabBarSafeArea() -> some View {
        modifier(TabBarSafeAreaModifier())
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environmentObject(DashboardViewModel())
}
