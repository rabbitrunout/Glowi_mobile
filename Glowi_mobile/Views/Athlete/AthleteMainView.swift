//
//  AthleteMainView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct AthleteMainView: View {
    @State private var selectedTab: AthleteTab = .progress

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            currentScreen
        }
        .safeAreaInset(edge: .bottom) {
            AthleteTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 10)
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch selectedTab {
        case .progress:
            NavigationStack {
                ChildProgressView()
            }

        case .awards:
            NavigationStack {
                AchievementsView()
            }

        case .schedule:
            NavigationStack {
                ScheduleView()
            }

        case .profile:
            NavigationStack {
                ChildProfileView()
            }
        }
    }
}

enum AthleteTab: CaseIterable {
    case progress
    case awards
    case schedule
    case profile

    var title: String {
        switch self {
        case .progress: return "Progress"
        case .awards: return "Awards"
        case .schedule: return "Schedule"
        case .profile: return "Me"
        }
    }

    var icon: String {
        switch self {
        case .progress: return "sparkles"
        case .awards: return "trophy.fill"
        case .schedule: return "calendar"
        case .profile: return "person.crop.circle.fill"
        }
    }
}

private struct AthleteTabBar: View {
    @Binding var selectedTab: AthleteTab

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AthleteTab.allCases, id: \.self) { tab in
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
                    .foregroundColor(selectedTab == tab ? Theme.athleteAccent : Theme.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == tab ? Theme.athleteAccent.opacity(0.12) : Color.clear)
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
    AthleteMainView()
        .environmentObject(DashboardViewModel())
}
