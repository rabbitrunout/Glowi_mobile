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
                    smartInsightsCard
                    quickActionsCard
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
        GlowiHeroCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(currentChildName)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        HStack(spacing: 8) {
                            Text("\(currentChildAge) y.o.")
                            Text("•")
                            Text(currentChildLevel)
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                        levelBadge

                        VStack(alignment: .leading, spacing: 10) {
                            GlowiAssetInfoRow(
                                assetName: "icon_schedule",
                                title: "Training",
                                subtitle: nextTrainingText,
                                accent: Theme.blueDark
                            )

                            GlowiAssetInfoRow(
                                assetName: "icon_events",
                                title: "Next Event",
                                subtitle: nextEventText,
                                accent: Theme.pinkDark
                            )
                        }
                    }

                    Spacer(minLength: 0)

                    heroImage
                }

                GlowiPrimaryButton(title: "Open Schedule", icon: "arrow.right") {
                    selectedTab = .schedule
                }
            }
        }
    }

    var levelBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "trophy.fill")
                .foregroundColor(Theme.yellowDark)

            Text(currentChildLevel)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Theme.yellow.opacity(0.25))
        )
    }

    var heroImage: some View {
        ZStack {
            Circle()
                .fill(Theme.accentGradient.opacity(0.55))
                .frame(width: 138, height: 138)

            if let image = dashboardVM.childPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 132, height: 132)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
            } else {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 132, height: 132)
                    .overlay(
                        Image(systemName: "figure.gymnastics")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.pinkDark)
                    )
            }
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
        .background(Color.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Quick Actions
private extension DashboardView {
    var quickActionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Quick Actions", icon: "bolt.fill")

                LazyVGrid(columns: quickColumns, spacing: 12) {
                    quickTile("Schedule", tab: .schedule)
                    quickTile("Events", tab: .events)
                    quickTile("Payments", tab: .payments)
                    quickTile("Account", tab: .account)
                }
            }
        }
    }

    func quickTile(_ title: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.white.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
                        ForEach(dashboardPreviewItems) { item in
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
        .background(Color.white.opacity(0.68))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
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
                Text(nextTrainingText)
                Text(latestPaymentText)
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
        .background(Color.white.opacity(0.62))
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
    var currentChildName: String { dashboardVM.child.name.isEmpty ? "Kira" : dashboardVM.child.name }
    var currentChildAge: Int { dashboardVM.child.age == 0 ? 12 : dashboardVM.child.age }
    var currentChildLevel: String { dashboardVM.child.level.isEmpty ? "Level" : dashboardVM.child.level }

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
            .fill(Color.white)
            .frame(width: size, height: size)
    }
    
    private struct PressableScaleButton<Content: View>: View {
        let action: () -> Void
        @ViewBuilder let content: Content

        @State private var isPressed = false

        var body: some View {
            Button(action: action) {
                content
                    .scaleEffect(isPressed ? 0.985 : 1.0)
                    .animation(.spring(response: 0.22, dampingFraction: 0.82), value: isPressed)
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
        }
    }
    
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
                                .background(Color.white.opacity(0.7))
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
            .background(Color.white.opacity(0.62))
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
}

#Preview {
    DashboardView(selectedTab: .constant(.home))
        .environmentObject(DashboardViewModel())
}
