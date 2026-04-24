import SwiftUI

struct EventsView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var dashboardVM: DashboardViewModel

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    upcomingSection
                    pastSection
                    addEventButton
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
private extension EventsView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Events",
            subtitle: "Competitions and upcoming activities"
        )
    }
}

// MARK: - Sections
private extension EventsView {
    var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Upcoming Events")

            if upcomingEvents.isEmpty {
                GlowiEmptyState(
                    icon: "calendar",
                    title: "No upcoming events",
                    message: "New competitions will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(upcomingEvents) { event in
                        PressableEventRow {
                            eventRow(event, accent: Theme.pinkDark, isDone: false)
                        }
                    }
                }
            }
        }
    }

    var pastSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Past Events")

            if pastEvents.isEmpty {
                GlowiEmptyState(
                    icon: "checkmark.circle",
                    title: "No past events yet",
                    message: "Completed events will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(pastEvents) { event in
                        PressableEventRow {
                            eventRow(event, accent: Theme.lavender, isDone: true)
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
private extension EventsView {
    func eventRow(_ event: Event, accent: Color, isDone: Bool) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent.opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: isDone ? "checkmark.seal.fill" : "star.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(event.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text("\(event.date) • \(event.time)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                Text(event.location)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(isDone ? "Done" : event.type)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(accent.opacity(0.13))
                .clipShape(Capsule())
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(rowBackground(isDone: isDone))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func rowBackground(isDone: Bool) -> Color {
        isDone ? Theme.lavender.opacity(0.22) : Theme.pink.opacity(0.24)
    }
}

// MARK: - Button
private extension EventsView {
    var addEventButton: some View {
        PremiumPrimaryButton(title: "Add Event", icon: "plus.circle") {
            dashboardVM.addEvent()
        }
        .padding(.top, 6)
    }
}

// MARK: - Helpers
private extension EventsView {
    var upcomingEvents: [Event] {
        Array(dashboardVM.events.prefix(3))
    }

    var pastEvents: [Event] {
        Array(dashboardVM.events.dropFirst(3))
    }
}

// MARK: - Pressable Row
private struct PressableEventRow<Content: View>: View {
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
        EventsView()
            .environmentObject(DashboardViewModel())
    }
}
