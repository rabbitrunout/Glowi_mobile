//
//  CoachReadinessView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachReadinessView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var items: [ReadinessItem] = [
        ReadinessItem(title: "Registration paid", isReady: true),
        ReadinessItem(title: "Music uploaded", isReady: true),
        ReadinessItem(title: "Leotard ready", isReady: true),
        ReadinessItem(title: "Apparatus confirmed", isReady: true),
        ReadinessItem(title: "Travel confirmed", isReady: false),
        ReadinessItem(title: "Hair & makeup plan", isReady: false),
        ReadinessItem(title: "Waiver signed", isReady: false)
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    GlowiScreenHeader(
                        title: "Readiness",
                        subtitle: "Coach checklist for competition preparation"
                    )

                    summaryCard
                    checklistCard
                    saveButton
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension CoachReadinessView {
    var summaryCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(readyCount)/\(items.count) Ready")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                ProgressView(value: Double(readyCount), total: Double(items.count))
                    .tint(Theme.greenDark)

                Text(readinessMessage)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }

    var checklistCard: some View {
        GlowiCard {
            VStack(spacing: 10) {
                ForEach($items) { $item in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                            item.isReady.toggle()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: item.isReady ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(item.isReady ? Theme.greenDark : Theme.textMuted)

                            Text(item.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)

                            Spacer()
                        }
                        .padding(14)
                        .background(item.isReady ? Theme.green.opacity(0.12) : Color.white.opacity(0.55))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    var saveButton: some View {
        PremiumPrimaryButton(title: "Save Readiness", icon: "checkmark.circle.fill") {
            dashboardVM.addNotification(
                title: "Readiness updated",
                message: "\(readyCount)/\(items.count) competition items are ready.",
                type: "progress"
            )

            dismiss()
        }
    }

    var readyCount: Int {
        items.filter { $0.isReady }.count
    }

    var readinessMessage: String {
        readyCount == items.count
        ? "Competition ready 🎉"
        : "Some preparation items still need attention."
    }
}

struct ReadinessItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isReady: Bool
}

#Preview {
    NavigationStack {
        CoachReadinessView()
            .environmentObject(DashboardViewModel())
    }
}
