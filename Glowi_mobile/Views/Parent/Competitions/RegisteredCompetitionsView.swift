//
//  RegisteredCompetitionsView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct RegisteredCompetitionsView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    GlowiScreenHeader(
                        title: "Registered Competitions",
                        subtitle: "Approved competitions and payment status"
                    )

                    if dashboardVM.registeredCompetitions.isEmpty {
                        GlowiEmptyState(
                            icon: "star",
                            title: "No registrations yet",
                            message: "Accepted competitions will appear here."
                        )
                    } else {
                        competitionsList
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension RegisteredCompetitionsView {
    var competitionsList: some View {
        VStack(spacing: 14) {
            ForEach(dashboardVM.registeredCompetitions) { competition in
                registeredCard(competition)
            }
        }
    }

    func registeredCard(_ competition: RegisteredCompetition) -> some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(competition.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("\(competition.date) • \(competition.location)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                    }

                    Spacer()

                    statusBadge(competition.status)
                }

                Text(competition.level)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)

                apparatusBadges(competition.apparatus)
            }
        }
    }

    func statusBadge(_ status: String) -> some View {
        Text(status)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(status.lowercased().contains("paid") ? Theme.greenDark : Theme.yellowDark)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                status.lowercased().contains("paid")
                ? Theme.green.opacity(0.14)
                : Theme.yellow.opacity(0.18)
            )
            .clipShape(Capsule())
    }

    func apparatusBadges(_ apparatus: [String]) -> some View {
        HStack(spacing: 8) {
            ForEach(apparatus, id: \.self) { item in
                Text(item)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Theme.blueDark)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(Theme.blueDark.opacity(0.10))
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    NavigationStack {
        RegisteredCompetitionsView()
            .environmentObject(DashboardViewModel())
    }
}
