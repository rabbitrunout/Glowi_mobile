//
//  CoachDashboardView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachDashboardView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    coachSummaryCard
                    toolsGrid
                    latestResultsCard
                    pendingCompetitionsCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension CoachDashboardView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Coach Portal",
            subtitle: "Manage athlete progress, results, and competitions"
        )
    }

    var coachSummaryCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Coach Tools")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("Add official results, suggest competitions, update athlete readiness, and keep parents informed.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
        }
    }

    var toolsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            NavigationLink {
                CoachAddResultView()
                    .environmentObject(dashboardVM)
            } label: {
                toolCard(
                    title: "Add Result",
                    subtitle: "Scores & medals",
                    icon: "trophy.fill",
                    accent: Theme.pinkDark
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                CoachUpdateLevelView()
                    .environmentObject(dashboardVM)
            } label: {
                toolCard(
                    title: "Update Level",
                    subtitle: "Coach approval",
                    icon: "checkmark.seal.fill",
                    accent: Theme.greenDark
                )
            }
            .buttonStyle(.plain)

            toolCard(
                title: "Update Level",
                subtitle: "Coach approval",
                icon: "checkmark.seal.fill",
                accent: Theme.greenDark
            )

            toolCard(
                title: "Readiness",
                subtitle: "Music, leotard, travel",
                icon: "checklist.checked",
                accent: Theme.yellowDark
            )
        }
    }

    func toolCard(title: String, subtitle: String, icon: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(accent.opacity(0.14))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(accent)
            }

            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text(subtitle)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    var latestResultsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Latest Results", icon: "medal.fill")

                ForEach(dashboardVM.recentResults.prefix(3)) { result in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.competition)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text("\(result.apparatus) • \(result.date)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(result.score)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Theme.textPrimary)

                            Text(result.place)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.pinkDark)
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.58))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }

    var pendingCompetitionsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {
                GlowiSectionTitle(text: "Suggested Competitions", icon: "star.fill")

                ForEach(dashboardVM.suggestedCompetitions.prefix(2)) { competition in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(competition.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("\(competition.date) • \(competition.location)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.textSecondary)

                        Text(competition.level)
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
}

#Preview {
    NavigationStack {
        CoachDashboardView()
            .environmentObject(DashboardViewModel())
    }
}
