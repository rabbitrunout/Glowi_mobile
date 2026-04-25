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
        VStack(alignment: .leading, spacing: 10) {

            // TOP ROW
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accent.opacity(0.16))
                        .frame(width: 46, height: 46)

                    Image(systemName: isDone ? "checkmark.seal.fill" : "star.fill")
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    Text("\(event.date) • \(event.time)")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)

                    Text(event.location)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                Text(isDone ? "Done" : event.type)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(accent)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(accent.opacity(0.15))
                    .clipShape(Capsule())
            }

            // 💳 PAYMENT BLOCK
            if let payment = dashboardVM.paymentForEvent(event.id) {

                Divider().opacity(0.2)

                HStack {
                    Text(payment.amount)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    Text(payment.status)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(
                            payment.status == "Paid"
                            ? Theme.greenDark
                            : Theme.warning
                        )
                }

                HStack {
                    Text("Due: \(payment.dueDate)")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textSecondary)

                    Spacer()

                    if payment.status != "Paid" {
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                dashboardVM.payForEvent(event.id)
                            }
                        } label: {
                            Text("Pay Now")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Theme.primaryButtonGradient)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(rowBackground(isDone: isDone))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
    func rowBackground(isDone: Bool) -> Color {
        isDone ? Theme.lavender.opacity(0.22) : Theme.pink.opacity(0.24)
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
