//
//  ConfirmPaymentSheet.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-25.
//

import SwiftUI

struct ConfirmPaymentSheet: View {
    let payment: Payment
    let onConfirm: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Confirm Payment")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text(payment.month)
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
                            .background(Color.white.opacity(0.72))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 14) {
                    checkoutRow(title: "Amount", value: payment.amount)
                    checkoutRow(title: "Due Date", value: payment.dueDate)
                    checkoutRow(
                        title: "Type",
                        value: payment.category == "competition" ? "Competition Fee" : "Monthly Training"
                    )
                    checkoutRow(title: "Method", value: "Visa •••• 4242")
                }
                .padding(18)
                .background(Theme.elevatedSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.stroke, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                Button {
                    onConfirm()
                    dismiss()
                } label: {
                    Text("Confirm Payment")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Theme.primaryButtonGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)

                Text("Mock checkout flow for demo purposes.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textMuted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(24)
        }
        .presentationDetents([.medium])
    }

    private func checkoutRow(title: String, value: String) -> some View {
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
}

#Preview {
    ConfirmPaymentSheet(
        payment: Payment(
            id: 1,
            month: "Koop Cup 2026",
            amount: "$85",
            status: "Pending",
            category: "competition",
            eventId: 1,
            dueDate: "Apr 15"
        )
    ) {
    }
}
