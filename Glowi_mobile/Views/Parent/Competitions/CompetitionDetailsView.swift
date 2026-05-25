//
//  CompetitionDetailsView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CompetitionDetailsView: View {

    let competition: SuggestedCompetition

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    GlowiScreenHeader(
                        title: competition.title,
                        subtitle: "\(competition.date) • \(competition.location)"
                    )

                    detailsCard
                    apparatusCard
                    feesCard
                    coachNoteCard
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension CompetitionDetailsView {

    var detailsCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 10) {

                detailRow("Level", competition.level)
                detailRow("Deadline", competition.deadline)
                detailRow("Status", competition.status)

            }
        }
    }

    var apparatusCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 14) {

                GlowiSectionTitle(
                    text: "Apparatus",
                    icon: "figure.gymnastics"
                )

                HStack(spacing: 8) {

                    ForEach(competition.apparatus, id: \.self) { item in
                        Text(item)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.blueDark)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(Theme.blueDark.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    var feesCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {

                GlowiSectionTitle(
                    text: "Fees",
                    icon: "creditcard.fill"
                )

                detailRow("Entry Fee", competition.entryFee)
                detailRow("Coach Fee", competition.coachFee)

            }
        }
    }

    var coachNoteCard: some View {
        GlowiCard {
            VStack(alignment: .leading, spacing: 12) {

                GlowiSectionTitle(
                    text: "Coach Note",
                    icon: "text.bubble.fill"
                )

                Text(competition.coachNote)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)
            }
        }
    }

    func detailRow(_ title: String, _ value: String) -> some View {

        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.textPrimary)
        }
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
                location: "Toronto",
                level: "Level 4B",
                apparatus: ["Free", "Ball", "Clubs"],
                entryFee: "$140",
                coachFee: "$60",
                deadline: "Apr 10",
                coachNote: "Good preparation event before Provincials.",
                status: "Suggested"
            )
        )
    }
}
