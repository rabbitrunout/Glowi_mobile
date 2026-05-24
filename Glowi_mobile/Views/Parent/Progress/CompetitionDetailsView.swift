//
//  CompetitionDetailsView.swift.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-18.
//

import SwiftUI

struct CompetitionDetailsView: View {
    let competition: SuggestedCompetition

    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    mainCard
                    readinessCard
                    apparatusCard
                    coachNoteCard
                    actionButton
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 10)
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension CompetitionDetailsView {
    var header: some View {
        GlowiScreenHeader(
            title: "Competition",
            subtitle: "Registration details and readiness"
        )
    }

    var mainCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(competition.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("\(competition.date) • \(competition.location)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)

                HStack {
                    badge(competition.level, color: Theme.parentAccent)
                    badge(competition.entryFee, color: Theme.yellowDark)
                }
            }
        }
    }

    var readinessCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {
                GlowiSectionTitle(text: "Competition Readiness", icon: "checklist.checked")

                readinessRow("Registration paid", done: false)
                readinessRow("Music uploaded", done: true)
                readinessRow("Leotard ready", done: true)
                readinessRow("Apparatus confirmed", done: true)
                readinessRow("Travel confirmed", done: false)
            }
        }
    }

    var apparatusCard: some View {
        VStack(alignment: .leading, spacing: 18) {

            sectionTitle("Apparatus Scores")

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 18) {

                    ProgressRingView(
                        title: "Free",
                        score: 18.4,
                        color: Theme.pinkDark
                    )

                    ProgressRingView(
                        title: "Hoop",
                        score: 17.9,
                        color: Theme.blueDark
                    )

                    ProgressRingView(
                        title: "Ball",
                        score: 18.1,
                        color: Theme.greenDark
                    )

                    ProgressRingView(
                        title: "Clubs",
                        score: 17.5,
                        color: Theme.yellowDark
                    )

                    ProgressRingView(
                        title: "Ribbon",
                        score: 18.7,
                        color: Theme.parentAccent
                    )
                }
                .padding(.vertical, 4)
            }

            VStack(spacing: 10) {

                resultRow(
                    title: "Koop Cup 2026",
                    apparatus: "Ribbon",
                    place: "1st Place",
                    score: "18.700"
                )

                resultRow(
                    title: "Ontario Championships",
                    apparatus: "Ball",
                    place: "2nd Place",
                    score: "18.100"
                )
            }
        }
        .padding(18)
        .background(Theme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    func resultRow(
        title: String,
        apparatus: String,
        place: String,
        score: String
    ) -> some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(apparatus)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {

                Text(place)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.pinkDark)

                Text(score)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(14)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func apparatusItem(_ title: String, emoji: String) -> some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.system(size: 24))

            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    var coachNoteCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 10) {
                GlowiSectionTitle(text: "Coach Note", icon: "person.fill.checkmark")

                Text("Recommended for this athlete based on current level, training consistency, and preparation progress.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
        }
    }

    var actionButton: some View {
        GlowiPrimaryButton(title: "Register & Pay", icon: "creditcard.fill") {
            dashboardVM.registerForCompetition(competition)
            dismiss()
        }
    }

    func readinessRow(_ title: String, done: Bool) -> some View {
        HStack {
            Image(systemName: done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(done ? Theme.greenDark : Theme.textMuted)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textPrimary)

            Spacer()
        }
    }

    func apparatus(_ title: String, emoji: String) -> some View {
        VStack(spacing: 6) {
            Text(emoji)
                .font(.system(size: 24))

            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func badge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.14))
            .clipShape(Capsule())
    }
    
    
}

private extension CompetitionDetailsView {

    func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Theme.textPrimary)
    }
}

#Preview {
    NavigationStack {
        CompetitionDetailsView(
            competition: SuggestedCompetition(
                id: 1,
                childId: 1,
                title: "Koop Cup 2026",
                date: "Apr 26",
                location: "Markham Pan Am Centre",
                level: "Level 4B",
                apparatus: ["Free", "Ball", "Clubs"],
                entryFee: "$140",
                coachFee: "$60",
                deadline: "Apr 10",
                coachNote: "Good competition for consistency before Provincials.",
                status: "Suggested"
            )
        )
        .environmentObject(DashboardViewModel())
    }
}
