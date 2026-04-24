import SwiftUI

struct PaymentsView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @State private var animatedBalance: Double = 0

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    balanceCard
                    historySection
                    downloadInvoicesButton
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            animateBalance()
        }
    }
}

// MARK: - Header
private extension PaymentsView {
    var headerSection: some View {
        HStack {
            Button { } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.72))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Payments")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Spacer()

            Button { } label: {
                Image(systemName: "doc.text")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.blueDark)
                    .frame(width: 42, height: 42)
                    .background(Color.white.opacity(0.72))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, 4)
    }
}

// MARK: - Balance
private extension PaymentsView {
    var balanceCard: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Balance")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.88))

                Text("$\(Int(animatedBalance))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }

            Spacer()

            Button { } label: {
                Text("Top up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.92))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Theme.stroke, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .frame(height: 112)
        .background(Theme.primaryButtonGradient)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Theme.pinkGlow.opacity(0.7), radius: 12, x: 0, y: 6)
    }
}

// MARK: - History
private extension PaymentsView {
    var historySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("History")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .padding(.top, 2)

            if dashboardVM.payments.isEmpty {
                GlowiEmptyState(
                    icon: "creditcard",
                    title: "No payments yet",
                    message: "Payment history will appear here."
                )
            } else {
                VStack(spacing: 10) {
                    ForEach(dashboardVM.payments) { payment in
                        paymentRow(payment)
                    }
                }
            }
        }
    }

    func paymentRow(_ payment: Payment) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text(payment.month)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                Text(paymentTitle(for: payment))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(paymentSubtitle(for: payment))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                Text(amountText(for: payment))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(statusColor(for: payment.status))

                Text(payment.status.capitalized)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(statusColor(for: payment.status))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(rowBackground(for: payment.status))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.65), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    func paymentTitle(for payment: Payment) -> String {
        payment.status.lowercased() == "paid" ? "Monthly Training" : "Competition Fee"
    }

    func paymentSubtitle(for payment: Payment) -> String {
        payment.status.lowercased() == "paid" ? "Payment received" : "Waiting for payment"
    }

    func amountText(for payment: Payment) -> String {
        let clean = payment.amount.replacingOccurrences(of: "$", with: "")
        let prefix = payment.status.lowercased() == "paid" ? "+ " : "- "
        return "\(prefix)$\(clean)"
    }

    func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "paid":
            return Theme.greenDark
        case "pending":
            return Theme.pinkDark
        default:
            return Theme.textPrimary
        }
    }

    func rowBackground(for status: String) -> Color {
        switch status.lowercased() {
        case "paid":
            return Theme.green.opacity(0.42)
        case "pending":
            return Theme.pink.opacity(0.28)
        default:
            return Theme.softSurface
        }
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
}

// MARK: - Helpers
private extension PaymentsView {
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

#Preview {
    NavigationStack {
        PaymentsView()
            .environmentObject(DashboardViewModel())
    }
}
