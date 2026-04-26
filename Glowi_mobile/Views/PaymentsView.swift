import SwiftUI

struct PaymentsView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var animatedBalance: Double = 0
    @State private var selectedPayment: Payment?
    @State private var showSuccessToast = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    balanceCard
                    trainingSection
                    competitionSection
                    downloadInvoicesButton
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
        .onAppear {
            animateBalance()
        }
        .sheet(item: $selectedPayment) { payment in
            ConfirmPaymentSheet(payment: payment) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    dashboardVM.payPayment(payment.id)
                    selectedPayment = nil
                    showSuccessToast = true
                    animateBalance()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showSuccessToast = false
                    }
                }
            }
        }
    }
}

// MARK: - Header
private extension PaymentsView {
    var headerSection: some View {
        Text("Payments")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }
}

// MARK: - Balance
private extension PaymentsView {
    var balanceCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Total Payments")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))

                Text("$\(Int(animatedBalance))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("\(pendingPayments.count)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text("Pending")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.82))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .frame(height: 112)
        .background(Theme.primaryButtonGradient)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Theme.pinkGlow.opacity(0.7), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Training
private extension PaymentsView {
    var trainingSection: some View {
        paymentSection(
            title: "Training Payments",
            payments: trainingPayments,
            emptyTitle: "No training payments",
            emptyMessage: "Monthly payments will appear here."
        )
    }

    var competitionSection: some View {
        paymentSection(
            title: "Competition Fees",
            payments: competitionPayments,
            emptyTitle: "No competition fees",
            emptyMessage: "Competition payment requests will appear here."
        )
    }

    func paymentSection(
        title: String,
        payments: [Payment],
        emptyTitle: String,
        emptyMessage: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(title)

            if payments.isEmpty {
                GlowiEmptyState(
                    icon: "creditcard",
                    title: emptyTitle,
                    message: emptyMessage
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(payments) { payment in
                        paymentRow(payment)
                    }
                }
            }
        }
    }
}

// MARK: - Rows
private extension PaymentsView {
    func paymentRow(_ payment: Payment) -> some View {
        let urgency = dashboardVM.paymentUrgency(for: payment)
        let urgencyColor = dashboardVM.paymentUrgencyColor(for: urgency)

        return HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(urgencyColor.opacity(0.16))
                    .frame(width: 46, height: 46)

                Image(systemName: paymentIcon(for: payment))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(urgencyColor)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(payment.month)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(payment.category == "competition" ? "Competition fee" : "Monthly training")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                Text("Due: \(payment.dueDate)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Theme.textMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(payment.amount)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(urgency)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(urgencyColor)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(urgencyColor.opacity(0.13))
                    .clipShape(Capsule())

                if payment.status.lowercased() != "paid" {
                    Button {
                        selectedPayment = payment
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
        .background(rowBackground(for: urgency))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.65), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Download
private extension PaymentsView {
    var downloadInvoicesButton: some View {
        Button { } label: {
            HStack(spacing: 10) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 17, weight: .semibold))

                Text("Download Invoices")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Theme.accentGradient)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Theme.blueGlow.opacity(0.8), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
        .padding(.top, 6)
    }

    var successToast: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Theme.greenDark)

            VStack(alignment: .leading, spacing: 2) {
                Text("Payment completed")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("Your payment is now marked as paid.")
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
private extension PaymentsView {
    var trainingPayments: [Payment] {
        dashboardVM.payments.filter { $0.category == "training" }
    }

    var competitionPayments: [Payment] {
        dashboardVM.payments.filter { $0.category == "competition" }
    }

    var pendingPayments: [Payment] {
        dashboardVM.payments.filter { $0.status.lowercased() != "paid" }
    }

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }

    func paymentIcon(for payment: Payment) -> String {
        payment.category == "competition" ? "star.fill" : "calendar"
    }

    func rowBackground(for urgency: String) -> Color {
        switch urgency {
        case "Paid":
            return Theme.green.opacity(0.34)
        case "Overdue":
            return Theme.error.opacity(0.26)
        case "Due soon":
            return Theme.yellow.opacity(0.28)
        default:
            return Theme.pink.opacity(0.22)
        }
    }

    func animateBalance() {
        let total = dashboardVM.payments.compactMap {
            Double($0.amount.replacingOccurrences(of: "$", with: ""))
        }.reduce(0, +)

        animatedBalance = 0

        withAnimation(.easeOut(duration: 1.0)) {
            animatedBalance = total
        }
    }
}



    func checkoutRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
    }

#Preview {
    NavigationStack {
        PaymentsView()
            .environmentObject(DashboardViewModel())
    }
}
