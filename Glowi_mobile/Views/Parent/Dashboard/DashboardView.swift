import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Binding var selectedTab: Tab
    @State private var showAllInsights = false

    private let quickColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    screenHeader
                    heroChildCard
                    statsStrip
                    progressOverviewCard
                    smartInsightsCard
                    quickActionsCard
                    suggestedCompetitionsCard
                    recentResultsCard
                    compactCalendarCard
                    recentHighlightsCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showAllInsights) {
            SmartInsightsSheet()
                .environmentObject(dashboardVM)
        }
    }
}

// MARK: - Header
private extension DashboardView {
    var screenHeader: some View {
        GlowiScreenHeader(
            title: "Hi, Irina 👋",
            subtitle: "Here’s your child’s latest overview",
            trailing: AnyView(childAvatar(size: 52))
        )
    }
}

// MARK: - Hero
private extension DashboardView {
    var heroChildCard: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.lavender,
                            Theme.pink.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(Color.white.opacity(0.18))
                .frame(width: 220, height: 220)
                .offset(x: 50, y: 45)

            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Hi \(currentChildName) 👋")
                        .font(.system(size: 30, weight: .bold))

                    Text("You’re doing amazing!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.82))
                }
                .foregroundColor(.white)

                HStack(spacing: 14) {
                    heroBadge(title: "Level", value: currentChildLevel)
                    heroBadge(title: "Goals", value: "3/4")
                }

                VStack(alignment: .leading, spacing: 10) {
                    heroInfoRow(icon: "calendar", text: nextTrainingText)
                    heroInfoRow(icon: "star.fill", text: nextEventText)
                }

                GlowiPrimaryButton(
                    title: "Open Schedule",
                    icon: "arrow.right"
                ) {
                    selectedTab = .schedule
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "figure.gymnastics")
                .font(.system(size: 118))
                .foregroundColor(.white.opacity(0.88))
                .offset(x: -12, y: -12)
        }
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .shadow(color: Theme.pinkGlow, radius: 18, x: 0, y: 10)
    }

    func heroBadge(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    func heroInfoRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.white)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
        }
    }
}

// MARK: - Stats
private extension DashboardView {
    var statsStrip: some View {
        HStack(spacing: 12) {
            statCard(title: "This Week", value: "\(dashboardVM.sessions.count)")
            statCard(title: "Events", value: "\(dashboardVM.events.count)")
            statCard(title: "Awards", value: "\(dashboardVM.achievements.count)")
        }
    }

    func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Quick Actions
private extension DashboardView {
    var quickActionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    GlowiSectionTitle(
                        text: "Quick Access",
                        icon: "square.grid.2x2.fill"
                    )

                    Spacer()

                    Text("Parent")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.parentAccent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Theme.parentSoft)
                        .clipShape(Capsule())
                }

                LazyVGrid(columns: quickColumns, spacing: 12) {
                    dashboardTile(
                        title: "Schedule",
                        subtitle: "Training calendar",
                        icon: "calendar",
                        accent: Theme.coachAccent
                    ) {
                        selectedTab = .schedule
                    }

                    dashboardTile(
                        title: "Progress",
                        subtitle: "Awards & growth",
                        icon: "chart.line.uptrend.xyaxis",
                        accent: Theme.athleteAccent
                    ) {
                        selectedTab = .progress
                    }

                    dashboardTile(
                        title: "Payments",
                        subtitle: "Invoices & fees",
                        icon: "creditcard.fill",
                        accent: Theme.yellowDark
                    ) {
                        selectedTab = .payments
                    }

                    dashboardTile(
                        title: "Account",
                        subtitle: "Club & profile",
                        icon: "person.crop.circle",
                        accent: Theme.parentAccent
                    ) {
                        selectedTab = .account
                    }
                }
            }
        }
    }

    func dashboardTile(
        title: String,
        subtitle: String,
        icon: String,
        accent: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accent.opacity(0.14))
                        .frame(width: 46, height: 46)

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
            .background(Theme.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Progress
private extension DashboardView {
    var progressOverviewCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(
                    text: "My Progress",
                    icon: "chart.line.uptrend.xyaxis"
                )

                HStack(spacing: 12) {
                    ForEach(dashboardVM.progressStats, id: \.id) { stat in
                        VStack(spacing: 10) {
                            Image(systemName: stat.icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.athleteAccent)

                            Text(stat.value)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text(stat.title)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.cardGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
            }
        }
    }
}

// MARK: - Suggested Competitions
private extension DashboardView {
    var suggestedCompetitionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(
                    text: "Suggested Competitions",
                    icon: "star.fill"
                )

                ForEach(dashboardVM.suggestedCompetitions) { competition in
                    NavigationLink {
                        CompetitionDetailsView(competition: competition)
                            .environmentObject(dashboardVM)
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(competition.title)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)

                                    Text("\(competition.date) • \(competition.location)")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Theme.textSecondary)
                                }

                                Spacer()

                                Text(competition.level)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.parentAccent)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Theme.parentSoft)
                                    .clipShape(Capsule())
                            }

                            HStack {
                                Text("Entry Fee")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)

                                Spacer()

                                Text(competition.entryFee)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                            }

                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Theme.blueDark)

                                Text("Open competition details")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(Theme.blueDark)

                                Spacer()
                            }
                            .padding(.top, 4)
                        }
                        .padding(16)
                        .background(Theme.cardGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Results
private extension DashboardView {
    var recentResultsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(
                    text: "Recent Results",
                    icon: "trophy.fill"
                )

                ForEach(dashboardVM.recentResults, id: \.id) { result in
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(result.competition)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text(result.apparatus)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 6) {
                            Text(result.place)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.pinkDark)

                            Text(result.score)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(14)
                    .background(Theme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}

// MARK: - Calendar
private extension DashboardView {
    var compactCalendarCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    GlowiSectionTitle(text: "Calendar", icon: "calendar")

                    Spacer()

                    GlowiGhostButton(title: "See all") {
                        selectedTab = .schedule
                    }
                }

                if dashboardVM.calendarItems.isEmpty {
                    Text("No calendar items yet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                } else {
                    VStack(spacing: 10) {
                        ForEach(dashboardPreviewItems, id: \.id) { item in
                            dashboardCalendarRow(item)
                        }
                    }
                }
            }
        }
    }

    func dashboardCalendarRow(_ item: CalendarItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(calendarColor(for: item.type).opacity(0.14))
                    .frame(width: 42, height: 42)

                Image(systemName: calendarIcon(for: item.type))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(calendarColor(for: item.type))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(1)

                Text(item.time.isEmpty ? item.subtitle : "\(item.time) • \(item.subtitle)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(item.date)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(calendarColor(for: item.type))
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(calendarColor(for: item.type).opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Theme.cardGradient)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    func calendarColor(for type: String) -> Color {
        switch type {
        case "training":
            return Theme.blueDark
        case "competition", "event":
            return Theme.pinkDark
        case "payment":
            return Theme.yellowDark
        default:
            return Theme.textSecondary
        }
    }

    func calendarIcon(for type: String) -> String {
        switch type {
        case "training":
            return "figure.gymnastics"
        case "competition":
            return "star.fill"
        case "event":
            return "calendar.badge.plus"
        case "payment":
            return "creditcard.fill"
        default:
            return "calendar"
        }
    }
}

// MARK: - Highlights
private extension DashboardView {
    var recentHighlightsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 10) {
                GlowiSectionTitle(text: "Highlights", icon: "sparkles")

                Text(nextEventText)
                    .foregroundColor(Theme.textPrimary)

                Text(nextTrainingText)
                    .foregroundColor(Theme.textPrimary)

                Text(latestPaymentText)
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }

    var dashboardPreviewItems: [CalendarItem] {
        Array(
            dashboardVM.calendarItems
                .sorted { first, second in
                    if first.type == "payment" && second.type != "payment" {
                        return true
                    }
                    return false
                }
                .prefix(4)
        )
    }
}

// MARK: - Smart Insights
private extension DashboardView {
    var smartInsightsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .foregroundColor(Theme.pinkDark)

                    Text("Smart Insights")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    Button {
                        showAllInsights = true
                    } label: {
                        Text("View all")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.pinkDark)
                    }
                    .buttonStyle(.plain)

                    Text("AI")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Theme.primaryButtonGradient)
                        .clipShape(Capsule())
                }

                if let firstInsight = dashboardVM.smartInsights.first {
                    insightRow(firstInsight)
                } else {
                    Text("No insights yet")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }

    func insightRow(_ insight: AIInsight) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(insightColor(insight.type).opacity(0.16))
                    .frame(width: 44, height: 44)

                Image(systemName: insightIcon(insight.type))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(insightColor(insight.type))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text(insight.message)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .background(Theme.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func insightColor(_ type: String) -> Color {
        switch type {
        case "training":
            return Theme.blueDark
        case "event":
            return Theme.pinkDark
        case "payment":
            return Theme.yellowDark
        case "progress":
            return Theme.greenDark
        default:
            return Theme.textSecondary
        }
    }

    func insightIcon(_ type: String) -> String {
        switch type {
        case "training":
            return "figure.gymnastics"
        case "event":
            return "star.fill"
        case "payment":
            return "creditcard.fill"
        case "progress":
            return "chart.line.uptrend.xyaxis"
        default:
            return "sparkles"
        }
    }
}

// MARK: - Helpers
private extension DashboardView {
    var currentChildName: String {
        dashboardVM.child.name.isEmpty ? "Kira" : dashboardVM.child.name
    }

    var currentChildAge: Int {
        dashboardVM.child.age == 0 ? 12 : dashboardVM.child.age
    }

    var currentChildLevel: String {
        dashboardVM.child.level.isEmpty ? "Level" : dashboardVM.child.level
    }

    var nextTrainingText: String {
        dashboardVM.sessions.first.map { "\($0.date) • \($0.time)" } ?? "No training"
    }

    var nextEventText: String {
        dashboardVM.events.first.map { "\($0.date) • \($0.title)" } ?? "No event"
    }

    var latestPaymentText: String {
        dashboardVM.payments.first.map { "\($0.month) • \($0.status)" } ?? "No payment"
    }

    func childAvatar(size: CGFloat) -> some View {
        Circle()
            .fill(Theme.cardGradient)
            .frame(width: size, height: size)
    }
}

// MARK: - Smart Insights Sheet
private struct SmartInsightsSheet: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Smart Insights")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("AI-powered overview of training, events, and payments")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 38, height: 38)
                            .background(Theme.cardGradient)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(dashboardVM.smartInsights) { insight in
                            sheetInsightRow(insight)
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
        .presentationDetents([.medium, .large])
    }

    func sheetInsightRow(_ insight: AIInsight) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(insightColor(insight.type).opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: insightIcon(insight.type))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(insightColor(insight.type))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(insight.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(insight.message)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func insightColor(_ type: String) -> Color {
        switch type {
        case "training": return Theme.blueDark
        case "event": return Theme.pinkDark
        case "payment": return Theme.yellowDark
        case "progress": return Theme.greenDark
        default: return Theme.textSecondary
        }
    }

    func insightIcon(_ type: String) -> String {
        switch type {
        case "training": return "figure.gymnastics"
        case "event": return "star.fill"
        case "payment": return "creditcard.fill"
        case "progress": return "chart.line.uptrend.xyaxis"
        default: return "sparkles"
        }
    }
}

#Preview {
    DashboardView(selectedTab: .constant(.home))
        .environmentObject(DashboardViewModel())
}
