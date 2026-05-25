//
//  AdminMainView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct AdminMainView: View {
    @State private var selectedTab: AdminTab = .dashboard

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            currentScreen
        }
        .safeAreaInset(edge: .bottom) {
            AdminTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 10)
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch selectedTab {
        case .dashboard:
            NavigationStack {
                AdminDashboardView()
            }

        case .competitions:
            NavigationStack {
                CoachSuggestCompetitionView()
            }

        case .payments:
            NavigationStack {
                PaymentsView()
            }

        case .reports:
            NavigationStack {
                ChildProgressView()
            }
        }
    }
}

enum AdminTab: CaseIterable {
    case dashboard
    case competitions
    case payments
    case reports

    var title: String {
        switch self {
        case .dashboard: return "Home"
        case .competitions: return "Events"
        case .payments: return "Payments"
        case .reports: return "Reports"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "shield.fill"
        case .competitions: return "calendar.badge.plus"
        case .payments: return "creditcard.fill"
        case .reports: return "chart.bar.fill"
        }
    }
}

private struct AdminTabBar: View {
    @Binding var selectedTab: AdminTab

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AdminTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 17, weight: .semibold))

                        Text(tab.title)
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(selectedTab == tab ? Theme.greenDark : Theme.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == tab ? Theme.greenDark.opacity(0.12) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: Theme.shadow.opacity(0.4), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    AdminMainView()
        .environmentObject(DashboardViewModel())
}
