//
//  CoachUpdateLevelView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachUpdateLevelView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedLevel = "Level 4B"

    private let levels = [
        "Pending",
        "Pre-Novice",
        "Novice",
        "Level 2A",
        "Level 2B",
        "Level 2C",
        "Level 3A",
        "Level 3B",
        "Level 3C",
        "Level 4A",
        "Level 4B",
        "Level 4C",
        "Level 5A",
        "Level 5B",
        "Level 6A",
        "Junior HP",
        "Junior Open",
        "Senior",
        "National",
        "IC 2A",
        "IC 2B",
        "IC 3A",
        "IC 3B",
        "IC 4A",
        "IC 4B",
        "IC 5A",
        "IC 5B",
        "IC 6A",
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                GlowiScreenHeader(
                    title: "Update Level",
                    subtitle: "Coach approval for athlete level"
                )

                GlowiCard {
                    VStack(alignment: .leading, spacing: 18) {
                        athleteBlock
                        levelPicker
                        saveButton
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 12)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            selectedLevel = dashboardVM.child.level.isEmpty ? "Pending" : dashboardVM.child.level
        }
    }
}

private extension CoachUpdateLevelView {
    var athleteBlock: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.pink.opacity(0.16))
                    .frame(width: 54, height: 54)

                Image(systemName: "figure.gymnastics")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Theme.pinkDark)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(dashboardVM.child.name.isEmpty ? "Selected Athlete" : dashboardVM.child.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("Current level: \(dashboardVM.child.level.isEmpty ? "Pending" : dashboardVM.child.level)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
        }
    }

    var levelPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("New Level")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Picker("Level", selection: $selectedLevel) {
                ForEach(levels, id: \.self) { level in
                    Text(level).tag(level)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Theme.softSurface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    var saveButton: some View {
        PremiumPrimaryButton(title: "Approve Level", icon: "checkmark.seal.fill") {
            dashboardVM.coachUpdateSelectedChildLevel(selectedLevel)
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CoachUpdateLevelView()
            .environmentObject(DashboardViewModel())
    }
}
