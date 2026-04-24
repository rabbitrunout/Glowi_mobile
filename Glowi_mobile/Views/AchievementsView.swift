//
//  AchievementsView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    headerSection
                    overviewCard
                    achievementsListCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Header
private extension AchievementsView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Achievements",
            subtitle: "Progress, awards and milestones"
        )
    }
}

// MARK: - Overview
private extension AchievementsView {
    var overviewCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Overview", icon: "trophy.fill")

                HStack(spacing: 12) {
                    statCard(
                        title: "Total",
                        value: "\(dashboardVM.achievements.count)",
                        accent: Theme.yellowDark
                    )

                    statCard(
                        title: "This Month",
                        value: "\(monthlyAchievements)",
                        accent: Theme.pinkDark
                    )
                }
            }
        }
    }

    func statCard(title: String, value: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            RoundedRectangle(cornerRadius: 10)
                .fill(accent)
                .frame(height: 6)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.softSurface)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusMedium)
                .stroke(Theme.softStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
    }
}

// MARK: - List
private extension AchievementsView {
    var achievementsListCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Achievements", icon: "star.fill")

                if dashboardVM.achievements.isEmpty {
                    GlowiEmptyState(
                        icon: "trophy",
                        title: "No achievements yet",
                        message: "Awards and milestones will appear here."
                    )
                } else {
                    VStack(spacing: 10) {
                        ForEach(dashboardVM.achievements) { achievement in
                            PressableAchievementRow {
                                achievementRow(achievement)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Row
private extension AchievementsView {
    func achievementRow(_ achievement: Achievement) -> some View {
        HStack(alignment: .top, spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.yellow.opacity(0.18))
                    .frame(width: 46, height: 46)

                Image(systemName: "trophy.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.yellowDark)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text(achievement.date)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)

                Text(achievementSubtitle(for: achievement))
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            Text(achievementLevel(for: achievement))
                .font(.caption.weight(.semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Theme.yellow.opacity(0.18))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Color.white.opacity(0.72))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Helpers
private extension AchievementsView {
    var monthlyAchievements: Int {
        dashboardVM.achievements.count / 2 // можно потом заменить на реальную логику
    }

    func achievementSubtitle(for achievement: Achievement) -> String {
        "Rhythmic gymnastics competition"
    }

    func achievementLevel(for achievement: Achievement) -> String {
        "Award"
    }
}

// MARK: - Pressable Row
private struct PressableAchievementRow<Content: View>: View {
    @ViewBuilder let content: Content
    @State private var isPressed = false

    var body: some View {
        content
            .scaleEffect(isPressed ? 0.99 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.84), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed { isPressed = true }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
            .environmentObject(DashboardViewModel())
    }
}
