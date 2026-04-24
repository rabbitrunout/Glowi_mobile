import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var dashboardVM: DashboardViewModel
    

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    thisWeekSection
                    nextWeekSection
                    addToCalendarButton
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
private extension ScheduleView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Schedule",
            subtitle: "Training plan and recent sessions"
        )
    }
}

// MARK: - Sections
private extension ScheduleView {
    var thisWeekSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("This Week")

            if upcomingSessions.isEmpty {
                GlowiEmptyState(
                    icon: "calendar",
                    title: "No sessions this week",
                    message: "New training sessions will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(upcomingSessions) { session in
                        PressableScheduleRow {
                            sessionRow(session, accent: Theme.blueDark, isDone: false)
                        }
                    }
                }
            }
        }
    }

    var nextWeekSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Next Week")

            if nextWeekSessions.isEmpty {
                GlowiEmptyState(
                    icon: "calendar.badge.plus",
                    title: "No sessions planned",
                    message: "Next week’s training schedule will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(nextWeekSessions) { session in
                        PressableScheduleRow {
                            sessionRow(session, accent: Theme.greenDark, isDone: true)
                        }
                    }
                }
            }
        }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
            .padding(.top, 2)
    }
}

// MARK: - Row
private extension ScheduleView {
    func sessionRow(_ session: TrainingSession, accent: Color, isDone: Bool) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent.opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: isDone ? "checkmark.circle.fill" : "calendar")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(session.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text("\(session.date) • \(session.time)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                Text(session.coach)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            Text(isDone ? "Done" : "60 min")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(accent.opacity(0.13))
                .clipShape(Capsule())
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(Theme.elevatedSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Button
private extension ScheduleView {
    var addToCalendarButton: some View {
        Group {
            if auth.isAdmin {
                PremiumPrimaryButton(title: "Add to Calendar", icon: "plus.circle") {
                    dashboardVM.addSession()
                }
                .padding(.top, 6)
            }
        }
    }
}

// MARK: - Helpers
private extension ScheduleView {
    var upcomingSessions: [TrainingSession] {
        Array(dashboardVM.sessions.prefix(3))
    }

    var nextWeekSessions: [TrainingSession] {
        Array(dashboardVM.sessions.dropFirst(3))
    }
}

// MARK: - Pressable Row
private struct PressableScheduleRow<Content: View>: View {
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
                        isPressed = false }
            )
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
            .environmentObject(DashboardViewModel())
    }
}
