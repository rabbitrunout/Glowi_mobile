import SwiftUI

struct ChildProgressView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    private let apparatusOrder = ["Free", "Hoop", "Ball", "Clubs", "Ribbon"]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    athleteHeroCard
                    weeklyStats
                    latestAchievementCard
                    apparatusCard
                    resultsTimelineCard
                    qualificationCard
                    readinessCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Sections
private extension ChildProgressView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Progress",
            subtitle: "Awards, scores, and competition readiness"
        )
    }

    var athleteHeroCard: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Theme.athleteGradient)

            Circle()
                .fill(Color.white.opacity(0.16))
                .frame(width: 180, height: 180)
                .offset(x: 45, y: 45)

            VStack(alignment: .leading, spacing: 16) {
                Text("Hi \(currentChildName) 👋")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text("You’re doing amazing!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.86))

                HStack(spacing: 10) {
                    heroBadge(title: "Level", value: currentChildLevel)
                    heroBadge(title: "Awards", value: "\(dashboardVM.recentResults.count)")
                }

                if let latest = latestResult {
                    Text("Latest: \(latest.place) • \(latest.apparatus)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "figure.gymnastics")
                .font(.system(size: 92, weight: .regular))
                .foregroundColor(.white.opacity(0.78))
                .offset(x: -14, y: -12)
        }
        .frame(height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Theme.pinkGlow.opacity(0.8), radius: 16, x: 0, y: 10)
    }

    func heroBadge(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.72))

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.16))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var weeklyStats: some View {
        HStack(spacing: 12) {
            progressStat(title: "This Week", value: "\(dashboardVM.sessions.count)", subtitle: "Trainings")
            progressStat(title: "Results", value: "\(dashboardVM.recentResults.count)", subtitle: "Added")
            progressStat(title: "Goals", value: "3/4", subtitle: "Ready")
        }
    }

    func progressStat(title: String, value: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text(subtitle)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Theme.textMuted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    var latestAchievementCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Latest Achievement")

            if let latest = latestResult {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Theme.yellow.opacity(0.35))
                            .frame(width: 60, height: 60)

                        Text(medalEmoji(for: latest.place))
                            .font(.system(size: 30))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("You did it!")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text(latest.competition)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)

                        Text("\(latest.place) • \(latest.apparatus) • \(latest.score)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textMuted)
                    }

                    Spacer()
                }

                Text(latest.coachNote)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
                    .padding(.top, 2)
            } else {
                GlowiEmptyState(
                    icon: "trophy",
                    title: "No results yet",
                    message: "Your competition results will appear here."
                )
            }
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    var apparatusCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Routines")

            HStack(spacing: 10) {
                ForEach(apparatusOrder, id: \.self) { apparatus in
                    apparatusChip(apparatus)
                }
            }

            Text("Free is a full routine too — it can receive scores, placements, and awards.")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    func apparatusChip(_ title: String) -> some View {
        VStack(spacing: 7) {
            ZStack {
                Circle()
                    .fill(apparatusColor(title).opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: apparatusIcon(title))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(apparatusColor(title))
            }

            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    var resultsTimelineCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Results Timeline")

            if dashboardVM.recentResults.isEmpty {
                GlowiEmptyState(
                    icon: "medal",
                    title: "No results yet",
                    message: "Coach-added results will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(dashboardVM.recentResults) { result in
                        resultTimelineRow(result)
                    }
                }
            }
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    func resultTimelineRow(_ result: ResultItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(apparatusColor(result.apparatus).opacity(0.14))
                    .frame(width: 48, height: 48)

                Text(medalEmoji(for: result.place))
                    .font(.system(size: 23))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(result.competition)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("\(result.date) • \(result.apparatus)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                Text("D \(result.difficulty) • A \(result.artistry) • E \(result.execution)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Theme.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(result.score)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(result.place)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.58))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var qualificationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Qualification Progress")

            Text("Eastern Championships")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Theme.textPrimary)

            ProgressView(value: 74.5, total: 75.0)
                .tint(Theme.pinkDark)

            HStack {
                Text("74.5 / 75.0")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.pinkDark)

                Spacer()

                Text("Almost qualified")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    var readinessCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Competition Ready")

            readinessRow("Registration paid", done: true)
            readinessRow("Music uploaded", done: true)
            readinessRow("Leotard ready", done: true)
            readinessRow("Apparatus confirmed", done: true)
            readinessRow("Travel confirmed", done: false)
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    func readinessRow(_ title: String, done: Bool) -> some View {
        HStack {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(done ? Theme.greenDark : Theme.textMuted)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textPrimary)

            Spacer()
        }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }
}

// MARK: - Helpers
private extension ChildProgressView {
    var currentChildName: String {
        dashboardVM.child.name.isEmpty ? "Kira" : dashboardVM.child.name
    }

    var currentChildLevel: String {
        dashboardVM.child.level.isEmpty ? "Pending" : dashboardVM.child.level
    }

    var latestResult: ResultItem? {
        dashboardVM.recentResults.first
    }

    func medalEmoji(for place: String) -> String {
        let lower = place.lowercased()

        if lower.contains("1") || lower.contains("gold") {
            return "🥇"
        }

        if lower.contains("2") || lower.contains("silver") {
            return "🥈"
        }

        if lower.contains("3") || lower.contains("bronze") {
            return "🥉"
        }

        return "🏅"
    }

    func apparatusIcon(_ apparatus: String) -> String {
        switch apparatus.lowercased() {
        case "free":
            return "figure.gymnastics"
        case "hoop":
            return "circle"
        case "ball":
            return "circle.fill"
        case "clubs":
            return "figure.core.training"
        case "ribbon":
            return "waveform.path"
        default:
            return "sparkles"
        }
    }

    func apparatusColor(_ apparatus: String) -> Color {
        switch apparatus.lowercased() {
        case "free":
            return Theme.pinkDark
        case "hoop":
            return Theme.blueDark
        case "ball":
            return Theme.greenDark
        case "clubs":
            return Theme.yellowDark
        case "ribbon":
            return Theme.parentAccent
        default:
            return Theme.textSecondary
        }
    }
}

#Preview {
    NavigationStack {
        ChildProgressView()
            .environmentObject(DashboardViewModel())
    }
}
