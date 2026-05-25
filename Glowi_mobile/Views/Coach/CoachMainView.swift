//
//  CoachMainView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachMainView: View {
    @State private var selectedTab: CoachTab = .dashboard

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .safeAreaInset(edge: .bottom) {
            CoachTabBar(selectedTab: $selectedTab)
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
                CoachDashboardView()
            }

        case .athletes:
            NavigationStack {
                CoachAthletesView()
            }

        case .results:
            NavigationStack {
                CoachAddResultView()
            }

        case .competitions:
            NavigationStack {
                CoachSuggestCompetitionView()
            }

        case .levels:
            NavigationStack {
                CoachUpdateLevelView()
            }
        }
    }
}

enum CoachTab: CaseIterable {
    case dashboard
    case athletes
    case results
    case competitions
    case levels

    var title: String {
        switch self {
        case .dashboard: return "Home"
        case .athletes: return "Athletes"
        case .results: return "Results"
        case .competitions: return "Events"
        case .levels: return "Levels"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "house.fill"
        case .athletes: return "person.2.fill"
        case .results: return "trophy.fill"
        case .competitions: return "star.fill"
        case .levels: return "checkmark.seal.fill"
        }
    }
}

private struct CoachTabBar: View {
    @Binding var selectedTab: CoachTab

    var body: some View {
        HStack(spacing: 8) {
            ForEach(CoachTab.allCases, id: \.self) { tab in
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
                    .foregroundColor(selectedTab == tab ? Theme.blueDark : Theme.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        selectedTab == tab
                        ? Theme.blueDark.opacity(0.12)
                        : Color.clear
                    )
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
    CoachMainView()
        .environmentObject(DashboardViewModel())
}
