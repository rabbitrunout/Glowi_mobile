//
//  AdminDashboardView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var showResetAlert = false
    @State private var showResetToast = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    overviewGrid
                    systemToolsCard
                    paymentsCard
                    competitionsCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }

            if showResetToast {
                resetToast
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Reset demo data?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }

            Button("Reset", role: .destructive) {
                dashboardVM.resetDemoData()

                withAnimation {
                    showResetToast = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showResetToast = false
                    }
                }
            }
        } message: {
            Text("This will restore original demo data for the app.")
        }
    }
}

// MARK: - Sections
private extension AdminDashboardView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Admin Dashboard",
            subtitle: "System overview and demo management"
        )
    }

    var overviewGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            statCard(title: "Children", value: "\(dashboardVM.children.count)", icon: "person.2.fill", accent: Theme.pinkDark)
            statCard(title: "Payments", value: "\(pendingPaymentsCount)", icon: "creditcard.fill", accent: Theme.yellowDark)
            statCard(title: "Competitions", value: "\(dashboardVM.suggestedCompetitions.count)", icon: "star.fill", accent: Theme.blueDark)
            statCard(title: "Unread", value: "\(dashboardVM.unreadNotificationsCount)", icon: "bell.fill", accent: Theme.greenDark)
        }
    }

    func statCard(title: String, value: String, icon: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(accent.opacity(0.14))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .foregroundColor(accent)
            }

            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 138, alignment: .leading)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }

    var systemToolsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "System Tools", icon: "gearshape.fill")

                Button {
                    showResetAlert = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Theme.error)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reset Demo Data")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text("Restore all mock data for testing")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(14)
                    .background(Theme.error.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }

    var paymentsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Pending Payments", icon: "creditcard.fill")

                ForEach(dashboardVM.payments.filter { $0.status.lowercased() != "paid" }.prefix(3)) { payment in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(payment.month)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text("Due: \(payment.dueDate)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer()

                        Text(payment.amount)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.yellowDark)
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.58))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }

    var competitionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Suggested Competitions", icon: "star.fill")

                ForEach(dashboardVM.suggestedCompetitions.prefix(3)) { competition in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(competition.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("\(competition.date) • \(competition.level)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textSecondary)

                        Text(competition.status)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Theme.blueDark)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.58))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }

    var resetToast: some View {
        VStack {
            Spacer()

            Text("Demo data restored")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Theme.elevatedSurface)
                .clipShape(Capsule())
                .padding(.bottom, 110)
        }
    }

    var pendingPaymentsCount: Int {
        dashboardVM.payments.filter { $0.status.lowercased() != "paid" }.count
    }
}

#Preview {
    NavigationStack {
        AdminDashboardView()
            .environmentObject(DashboardViewModel())
    }
}
