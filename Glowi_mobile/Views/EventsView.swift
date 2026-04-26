import SwiftUI

struct EventsView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var selectedPayment: Payment?
    @State private var selectedChecklistEvent: Event?
    @State private var showSuccessToast = false

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

            if showSuccessToast {
                VStack {
                    Spacer()

                    successToast
                        .padding(.horizontal, 24)
                        .padding(.bottom, 110)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $selectedPayment) { payment in
            ConfirmPaymentSheet(payment: payment) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    dashboardVM.payPayment(payment.id)
                    selectedPayment = nil
                    showSuccessToast = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showSuccessToast = false
                    }
                }
            }
        }
        .sheet(item: $selectedChecklistEvent) { event in
            ChecklistSheetView(event: event)
                .environmentObject(dashboardVM)
        }
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
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(accent.opacity(0.16))
                        .frame(width: 46, height: 46)

                    Image(systemName: isDone ? "checkmark.seal.fill" : "star.fill")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 4) {
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
                    .padding(.vertical, 6)
                    .background(accent.opacity(0.15))
                    .clipShape(Capsule())
            }

            if let payment = dashboardVM.paymentForEvent(event.id) {
                Divider().opacity(0.2)

                HStack {
                    Text(payment.amount)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    let urgency = dashboardVM.paymentUrgency(for: payment)

                    Text(urgency)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(dashboardVM.paymentUrgencyColor(for: urgency))
                }

                HStack {
                    Text("Due: \(payment.dueDate)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    Spacer()

                    if payment.status.lowercased() != "paid" {
                        Button {
                            selectedPayment = payment
                        } label: {
                            Text("Pay Now")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Theme.primaryButtonGradient)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if event.type.lowercased().contains("competition") && !isDone {
                aiChecklistBlock(for: event)
            }
        }
        .padding(14)
        .background(rowBackground(isDone: isDone))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func aiChecklistBlock(for event: Event) -> some View {
        let checklist = dashboardVM.generateCompetitionChecklist(for: event)

        return VStack(alignment: .leading, spacing: 10) {
            Divider().opacity(0.2)

            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)

                Text("AI Checklist")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Spacer()

                Text("\(checklist.count) items")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.textSecondary)
            }

            VStack(alignment: .leading, spacing: 7) {
                ForEach(checklist.prefix(3)) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.greenDark)

                        Text(item.title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }

            Button {
                selectedChecklistEvent = event
            } label: {
                Text("View full checklist")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color.white.opacity(0.52))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    func rowBackground(isDone: Bool) -> Color {
        isDone ? Theme.lavender.opacity(0.22) : Theme.pink.opacity(0.24)
    }
}

// MARK: - Button
private extension EventsView {
    var addEventButton: some View {
        Group {
            if auth.isAdmin {
                PremiumPrimaryButton(title: "Add Event", icon: "plus.circle") {
                    dashboardVM.addEvent()
                }
                .padding(.top, 6)
            }
        }
    }
}

// MARK: - Toast
private extension EventsView {
    var successToast: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Theme.greenDark)

            VStack(alignment: .leading, spacing: 2) {
                Text("Payment completed")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("The fee is now marked as paid.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.card.opacity(0.96))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Theme.shadow.opacity(0.8), radius: 14, x: 0, y: 8)
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

// MARK: - Checklist Sheet
private struct ChecklistSheetView: View {
    let event: Event

    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("AI Checklist")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text(event.title)
                            .font(.system(size: 15, weight: .medium))
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

                VStack(spacing: 10) {
                    ForEach(dashboardVM.generateCompetitionChecklist(for: event)) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.greenDark)

                            Text(item.title)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Theme.textPrimary)

                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white.opacity(0.65))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                Spacer()
            }
            .padding(24)
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    NavigationStack {
        EventsView()
            .environmentObject(AuthViewModel())
            .environmentObject(DashboardViewModel())
    }
}
