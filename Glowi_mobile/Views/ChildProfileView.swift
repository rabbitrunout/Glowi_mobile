import SwiftUI

struct ChildProfileView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea(edges: .top)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    headerSection
                    profileCard
                    upcomingTrainingCard
                    achievementsPreviewCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

private extension ChildProfileView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Child Profile",
            subtitle: "Athlete details and recent progress"
        )
    }

    var profileCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Profile", icon: "person.crop.circle.fill")

                HStack(alignment: .center, spacing: 14) {
                    avatarView

                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentChildName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        HStack(spacing: 6) {
                            Text("\(currentChildAge) y.o.")
                            Text("•")
                            Text(currentChildLevel)
                        }
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)

                        Text("Gender: female")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }

                    Spacer()
                }
            }
        }
    }

    var upcomingTrainingCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Upcoming Training", icon: "calendar.badge.clock")

                if dashboardVM.sessions.isEmpty {
                    GlowiEmptyState(
                        icon: "calendar",
                        title: "No training yet",
                        message: "Training sessions will appear here once added."
                    )
                } else {
                    VStack(spacing: 10) {
                        ForEach(dashboardVM.sessions.prefix(2)) { session in
                            compactTrainingRow(session)
                        }
                    }
                }
            }
        }
    }

    var achievementsPreviewCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Recent Achievements", icon: "medal")

                if dashboardVM.achievements.isEmpty {
                    GlowiEmptyState(
                        icon: "medal",
                        title: "No achievements yet",
                        message: "Achievements and awards will appear here."
                    )
                } else {
                    VStack(spacing: 10) {
                        ForEach(dashboardVM.achievements.prefix(3)) { achievement in
                            compactAchievementRow(achievement)
                        }
                    }
                }

                NavigationLink(destination: AchievementsView().environmentObject(dashboardVM)) {
                    GlowiPrimaryButton(
                        title: "View All Achievements",
                        icon: "star"
                    ) {
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private extension ChildProfileView {
    var currentChildName: String {
        dashboardVM.child.name.isEmpty ? "Kiriia" : dashboardVM.child.name
    }

    var currentChildAge: Int {
        dashboardVM.child.age == 0 ? 11 : dashboardVM.child.age
    }

    var currentChildLevel: String {
        dashboardVM.child.level.isEmpty ? "Novice" : dashboardVM.child.level
    }

    var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.72))
                .frame(width: 74, height: 74)
                .overlay(
                    Circle()
                        .stroke(Theme.stroke, lineWidth: 1)
                )

            if let image = dashboardVM.childPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 74, height: 74)
                    .clipShape(Circle())
            } else {
                Image(systemName: "figure.gymnastics")
                    .font(.system(size: 30))
                    .foregroundColor(Theme.pinkDark)
            }
        }
        .shadow(color: Theme.shadow, radius: 8, x: 0, y: 4)
    }

    func compactTrainingRow(_ session: TrainingSession) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.cyan.opacity(0.16))
                    .frame(width: 42, height: 42)

                Image(systemName: "calendar")
                    .foregroundColor(Theme.cyanDark)
                    .font(.system(size: 18, weight: .medium))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(session.title)
                    .foregroundColor(Theme.textPrimary)
                    .fontWeight(.semibold)

                Text("\(session.date) • \(session.time)")
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)

                Text(session.coach)
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.72))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func compactAchievementRow(_ achievement: Achievement) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.gold.opacity(0.18))
                    .frame(width: 42, height: 42)

                Text(medalEmoji(for: achievement.place))
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .foregroundColor(Theme.textPrimary)
                    .fontWeight(.semibold)

                Text(achievement.date)
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)

                Text("Place: \(achievement.place)")
                    .foregroundColor(Theme.textSecondary)
                    .font(.caption)
            }

            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.72))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func medalEmoji(for place: String) -> String {
        let lower = place.lowercased()
        if lower.contains("1") { return "🥇" }
        if lower.contains("2") { return "🥈" }
        return "🥉"
    }
}

#Preview {
    NavigationStack {
        ChildProfileView()
            .environmentObject(DashboardViewModel())
    }
}
