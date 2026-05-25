//
//  CompetitionInvitationsView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CompetitionInvitationsView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    GlowiScreenHeader(
                        title: "Competition Invitations",
                        subtitle: "Coach-recommended competitions for your gymnast"
                    )

                    invitationsList
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }

            if showToast {
                toast
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension CompetitionInvitationsView {
    var invitationsList: some View {
        VStack(spacing: 14) {
            ForEach(dashboardVM.suggestedCompetitions) { competition in
                invitationCard(competition)
            }
        }
    }

    func invitationCard(_ competition: SuggestedCompetition) -> some View {
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

                    Text(competition.level)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.pinkDark)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Theme.pink.opacity(0.14))
                        .clipShape(Capsule())
                }

                apparatusBadges(competition.apparatus)

                VStack(spacing: 8) {
                    feeRow("Entry Fee", competition.entryFee)
                    feeRow("Coach Fee", competition.coachFee)
                    feeRow("Deadline", competition.deadline)
                }
                .padding(12)
                .background(Color.white.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text(competition.coachNote)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(3)

                HStack(spacing: 10) {
                    Button {
                        declineCompetition(competition)
                    } label: {
                        Text("Decline")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Color.white.opacity(0.55))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)

                    Button {
                        acceptCompetition(competition)
                    } label: {
                        Text("Approve & Add Fee")                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(Theme.primaryButtonGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
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

    func feeRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Theme.textPrimary)
        }
    }

    func acceptCompetition(_ competition: SuggestedCompetition) {
        dashboardVM.registerForCompetition(competition)
        toastMessage = "\(competition.title) accepted"
        showTemporaryToast()
    }

    func declineCompetition(_ competition: SuggestedCompetition) {
        dashboardVM.addNotification(
            title: "Competition declined",
            message: "\(competition.title) was declined by parent.",
            type: "competition"
        )

        toastMessage = "\(competition.title) declined"
        showTemporaryToast()
    }

    func showTemporaryToast() {
        withAnimation {
            showToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }

    var toast: some View {
        VStack {
            Spacer()

            Text(toastMessage)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Theme.elevatedSurface)
                .clipShape(Capsule())
                .padding(.bottom, 110)
        }
    }
}

#Preview {
    NavigationStack {
        CompetitionInvitationsView()
            .environmentObject(DashboardViewModel())
    }
}
