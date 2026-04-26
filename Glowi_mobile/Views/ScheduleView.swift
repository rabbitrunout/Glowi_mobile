import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var selectedDay: String = "22"
    @State private var showPaymentSuccess = false

    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    private let calendarRows: [[String]] = [
        ["30", "31", "1", "2", "3", "4", "5"],
        ["6", "7", "8", "9", "10", "11", "12"],
        ["13", "14", "15", "16", "17", "18", "19"],
        ["20", "21", "22", "23", "24", "25", "26"],
        ["27", "28", "29", "30", "", "", ""]
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    calendarCard
                    selectedDaySection
                    legendSection
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }

            if showPaymentSuccess {
                VStack {
                    Spacer()

                    paymentSuccessToast
                        .padding(.horizontal, 24)
                        .padding(.bottom, 110)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Header

private extension ScheduleView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Calendar",
            subtitle: "Training, competitions, and payment deadlines"
        )
    }
}

// MARK: - Calendar

private extension ScheduleView {
    var calendarCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("April 2026")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Spacer()

                    Text("Today")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Theme.primaryButtonGradient)
                        .clipShape(Capsule())
                }

                HStack(spacing: 6) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(calendarRows, id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(row, id: \.self) { day in
                                calendarCell(day)
                            }
                        }
                    }
                }
            }
        }
    }

    func calendarCell(_ day: String) -> some View {
        let isSelected = selectedDay == day
        let items = dashboardVM.calendarItems(for: day)

        return Button {
            guard !day.isEmpty else { return }

            withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                selectedDay = day
            }
        } label: {
            VStack(spacing: 6) {
                Text(day)
                    .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                    .foregroundColor(day.isEmpty ? .clear : Theme.textPrimary)

                HStack(spacing: 3) {
                    ForEach(items.prefix(3)) { item in
                        Circle()
                            .fill(dotColor(for: item.type))
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        isSelected
                        ? AnyShapeStyle(Theme.accentGradient)
                        : AnyShapeStyle(Color.white.opacity(0.65))
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Color.white.opacity(0.9) : Theme.stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(day.isEmpty)
    }
}

// MARK: - Selected Day

private extension ScheduleView {
    var selectedDaySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Apr \(selectedDay)")

            let items = dashboardVM.calendarItems(for: selectedDay)

            if items.isEmpty {
                GlowiEmptyState(
                    icon: "calendar",
                    title: "Nothing planned",
                    message: "No training, events, or payment deadlines for this day."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(items) { item in
                        calendarItemRow(item)
                    }
                }
            }
        }
    }

    func calendarItemRow(_ item: CalendarItem) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(dotColor(for: item.type).opacity(0.16))
                    .frame(width: 48, height: 48)

                Image(systemName: icon(for: item.type))
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(dotColor(for: item.type))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(1)

                Text(item.time.isEmpty ? item.subtitle : "\(item.time) • \(item.subtitle)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(label(for: item.type))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(dotColor(for: item.type))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(dotColor(for: item.type).opacity(0.13))
                    .clipShape(Capsule())

                if item.type == "payment", let eventId = item.relatedEventId {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            dashboardVM.payForEvent(eventId)
                            showPaymentSuccess = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showPaymentSuccess = false
                            }
                        }
                    } label: {
                        Text("Pay Now")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(Theme.primaryButtonGradient)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background(Theme.elevatedSurface)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.stroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Toast

private extension ScheduleView {
    var paymentSuccessToast: some View {
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

// MARK: - Legend

private extension ScheduleView {
    var legendSection: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle("Legend")

                HStack(spacing: 14) {
                    legendDot("Training", color: Theme.blueDark)
                    legendDot("Competition", color: Theme.pinkDark)
                    legendDot("Payment", color: Theme.yellowDark)
                }
            }
        }
    }

    func legendDot(_ title: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 9, height: 9)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
    }
}

// MARK: - Helpers

private extension ScheduleView {
    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }

    func dotColor(for type: String) -> Color {
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

    func icon(for type: String) -> String {
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

    func label(for type: String) -> String {
        switch type {
        case "training":
            return "Training"
        case "competition":
            return "Competition"
        case "event":
            return "Event"
        case "payment":
            return "Payment"
        default:
            return "Item"
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
            .environmentObject(DashboardViewModel())
    }
}
