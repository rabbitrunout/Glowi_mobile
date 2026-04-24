import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Binding var selectedTab: Tab

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
        PressableScaleButton(action: {
            selectedTab = .account
        }) {
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
        .buttonStyle(.plain)
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
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Theme.accentGradient.opacity(0.55))
                    .frame(width: 138, height: 138)
                    .blur(radius: 4)

                if let image = dashboardVM.childPhoto {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 132, height: 132)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.55))
                            .frame(width: 132, height: 132)

                        Image(systemName: "figure.gymnastics")
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(Theme.pinkDark)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }
}

// MARK: - Stats Strip
private extension DashboardView {
    var statsStrip: some View {
        HStack(spacing: 12) {
            statCard(
                title: "This Week",
                value: "\(dashboardVM.sessions.count)",
                accent: Theme.blueDark,
                bg: Theme.blue.opacity(0.16)
            )

            statCard(
                title: "Events",
                value: "\(dashboardVM.events.count)",
                accent: Theme.pinkDark,
                bg: Theme.pink.opacity(0.16)
            )

            statCard(
                title: "Awards",
                value: "\(dashboardVM.achievements.count)",
                accent: Theme.yellowDark,
                bg: Theme.yellow.opacity(0.18)
            )
        }
    }

    func statCard(title: String, value: String, accent: Color, bg: Color) -> some View {
        PressableScaleButton(action: {}) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)

                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                RoundedRectangle(cornerRadius: 10)
                    .fill(accent)
                    .frame(height: 5)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bg)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusMedium)
                    .stroke(accent.opacity(0.12), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Actions
private extension DashboardView {
    var quickActionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Quick Actions", icon: "bolt.fill")

                LazyVGrid(columns: quickColumns, spacing: 12) {
                    quickTile(
                        title: "Training",
                        assetName: "icon_schedule",
                        accent: Theme.blueDark
                    ) {
                        selectedTab = .schedule
                    }

                    quickTile(
                        title: "Events",
                        assetName: "icon_events",
                        accent: Theme.pinkDark
                    ) {
                        selectedTab = .events
                    }

                    quickTile(
                        title: "Payments",
                        assetName: "icon_payments",
                        accent: Theme.yellowDark
                    ) {
                        selectedTab = .payments
                    }

                    quickTile(
                        title: "Account",
                        assetName: "icon_account",
                        accent: Theme.lavender
                    ) {
                        selectedTab = .account
                    }
                }
            }
        }
    }

    func quickTile(title: String, assetName: String, accent: Color, action: @escaping () -> Void) -> some View {
        PressableScaleButton(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accent.opacity(0.14))
                        .frame(width: 46, height: 46)

                    Image(assetName)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .padding(16)
            .background(Color.white.opacity(0.72))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Theme.stroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Theme.shadow, radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
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
                        selectedTab = .events
                    }
                }

                HStack {
                    Text("September 2025")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    HStack(spacing: 8) {
                        monthNavButton(title: "today")
                        roundArrowButton(systemImage: "chevron.left")
                        roundArrowButton(systemImage: "chevron.right")
                    }
                }

                calendarGrid

                HStack(spacing: 14) {
                    legendDot(color: Theme.pinkDark, label: "Events")
                    legendDot(color: Theme.yellowDark, label: "Awards")
                    Spacer()
                }
            }
        }
    }

    func monthNavButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(Theme.primaryButtonGradient)
            .clipShape(Capsule())
            .shadow(color: Theme.pinkGlow, radius: 10, x: 0, y: 5)
    }

    func roundArrowButton(systemImage: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.88))
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.stroke, lineWidth: 1)
                )

            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Theme.textPrimary)
        }
        .shadow(color: Theme.shadow, radius: 8, x: 0, y: 4)
    }

    func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
    }

    var calendarGrid: some View {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let rows: [[String]] = [
            ["31","1","2","3","4","5","6"],
            ["7","8","9","10","11","12","13"],
            ["14","15","16","17","18","19","20"],
            ["21","22","23","24","25","26","27"],
            ["28","29","30","","","",""]
        ]

        return VStack(spacing: 8) {
            HStack(spacing: 6) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack(spacing: 8) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row, id: \.self) { item in
                            calendarCell(day: item)
                        }
                    }
                }
            }
        }
    }

    func calendarCell(day: String) -> some View {
        let isSelected = day == "11"
        let hasEvent = eventDays.contains(day)
        let hasAward = achievementDays.contains(day)

        return ZStack(alignment: .bottom) {
            if isSelected {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.accentGradient)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.92), lineWidth: 1)
                    )
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.72))
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
            }

            VStack(spacing: 5) {
                Text(day)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(day.isEmpty ? .clear : Theme.textPrimary)

                HStack(spacing: 4) {
                    if hasEvent, !day.isEmpty {
                        Circle()
                            .fill(Theme.pinkDark)
                            .frame(width: 6, height: 6)
                    }

                    if hasAward, !day.isEmpty {
                        Circle()
                            .fill(Theme.yellowDark)
                            .frame(width: 6, height: 6)
                    }
                }
                .frame(height: 8)
            }
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Highlights
private extension DashboardView {
    var recentHighlightsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Recent Highlights", icon: "sparkles")

                VStack(spacing: 10) {
                    PressableCardRow {
                        GlowiAssetInfoRow(
                            assetName: "icon_payments",
                            title: "Latest Payment",
                            subtitle: latestPaymentText,
                            accent: Theme.yellowDark
                        )
                    }

                    PressableCardRow {
                        GlowiAssetInfoRow(
                            assetName: "icon_events",
                            title: "Next Event",
                            subtitle: nextEventText,
                            accent: Theme.pinkDark
                        )
                    }

                    PressableCardRow {
                        GlowiAssetInfoRow(
                            assetName: "icon_schedule",
                            title: "Training",
                            subtitle: nextTrainingText,
                            accent: Theme.blueDark
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Data helpers
private extension DashboardView {
    var currentChildName: String {
        dashboardVM.child.name.isEmpty ? "Kiriia" : dashboardVM.child.name
    }

    var currentChildAge: Int {
        dashboardVM.child.age == 0 ? 11 : dashboardVM.child.age
    }

    var currentChildLevel: String {
        dashboardVM.child.level.isEmpty ? "Novice" : dashboardVM.child.level
    }

    var nextTrainingText: String {
        if !dashboardVM.child.nextTraining.isEmpty {
            return dashboardVM.child.nextTraining
        }
        if let first = dashboardVM.sessions.first {
            return "\(first.date) • \(first.time)"
        }
        return "No training planned today"
    }

    var nextEventText: String {
        if let first = dashboardVM.events.first {
            return "\(first.date) • \(first.title)"
        }
        return "No event scheduled"
    }

    var latestPaymentText: String {
        if let first = dashboardVM.payments.first {
            return "\(first.month) • \(first.status)"
        }
        return "No payment records"
    }

    var eventDays: Set<String> {
        Set(dashboardVM.events.map { $0.dateNumberOnly })
    }

    var achievementDays: Set<String> {
        Set(dashboardVM.achievements.map { $0.dateNumberOnly })
    }

    func childAvatar(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.72))
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Theme.stroke, lineWidth: 1)
                )

            if let image = dashboardVM.childPhoto {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.62, height: size * 0.62)
                    .foregroundColor(Theme.pinkDark)
            }
        }
        .shadow(color: Theme.shadow, radius: 10, x: 0, y: 6)
    }
}

// MARK: - Date helpers
private extension Event {
    var dateNumberOnly: String {
        let parts = date.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }
        return parts.first ?? ""
    }
}

private extension Achievement {
    var dateNumberOnly: String {
        let components = date.split(separator: "-")
        if components.count == 3 {
            return String(Int(components[2]) ?? 0)
        }
        return ""
    }
}

// MARK: - Pressable helpers
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

private struct PressableCardRow<Content: View>: View {
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
    DashboardView(selectedTab: .constant(.home))
        .environmentObject(DashboardViewModel())
}
