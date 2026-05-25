//
//  CoachAthletesView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachAthletesView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var showAddAthleteSheet = false

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    GlowiScreenHeader(
                        title: "Athletes",
                        subtitle: "Manage athletes and linked parent accounts"
                    )

                    addButton
                    athletesList
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showAddAthleteSheet) {
            CoachAddAthleteSheet()
                .environmentObject(dashboardVM)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension CoachAthletesView {
    var addButton: some View {
        PremiumPrimaryButton(title: "Add Athlete", icon: "person.crop.circle.badge.plus") {
            showAddAthleteSheet = true
        }
    }

    var athletesList: some View {
        VStack(spacing: 12) {
            ForEach(dashboardVM.children) { child in
                athleteRow(child)
            }
        }
    }

    func athleteRow(_ child: Child) -> some View {
        GlowiCard {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Theme.blueDark.opacity(0.14))
                        .frame(width: 52, height: 52)

                    Image(systemName: "figure.gymnastics")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Theme.blueDark)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(child.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text("\(child.age) y.o. • \(child.level)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    Text(child.parentEmail ?? "No parent linked")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textMuted)
                }

                Spacer()
            }
        }
    }
}

private struct CoachAddAthleteSheet: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var age = ""
    @State private var level = "Pending"
    @State private var parentEmail = ""

    @State private var showError = false
    @State private var errorMessage = ""

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
        NavigationStack {
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        GlowiCard {
                            VStack(spacing: 16) {
                                inputField("Athlete Name", text: $name)
                                inputField("Age", text: $age, keyboard: .numberPad)
                                levelPicker
                                inputField("Parent Email", text: $parentEmail)
                            }
                        }

                        PremiumPrimaryButton(title: "Save Athlete", icon: "checkmark.circle.fill") {
                            validateAndSave()
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("New Athlete")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
        .alert("Please check the form", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

private extension CoachAddAthleteSheet {
    var levelPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Level")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Picker("Level", selection: $level) {
                ForEach(levels, id: \.self) { item in
                    Text(item).tag(item)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Theme.softSurface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    func inputField(
        _ title: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            TextField(title, text: text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .padding(14)
                .background(Theme.softSurface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    func validateAndSave() {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = parentEmail.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else {
            errorMessage = "Athlete name is required."
            showError = true
            return
        }

        guard let ageValue = Int(age), ageValue > 0 else {
            errorMessage = "Please enter a valid age."
            showError = true
            return
        }

        guard cleanEmail.contains("@"), cleanEmail.contains(".") else {
            errorMessage = "Please enter a valid parent email."
            showError = true
            return
        }

        dashboardVM.coachAddAthlete(
            name: cleanName,
            age: ageValue,
            level: level,
            parentEmail: cleanEmail
        )

        dismiss()
    }
}

#Preview {
    NavigationStack {
        CoachAthletesView()
            .environmentObject(DashboardViewModel())
    }
}
