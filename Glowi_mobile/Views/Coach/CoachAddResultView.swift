//
//  CoachAddResultView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachAddResultView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var competition = ""
    @State private var date = ""
    @State private var apparatus = "Free"
    @State private var place = ""
    @State private var score = ""
    @State private var difficulty = ""
    @State private var artistry = ""
    @State private var execution = ""
    @State private var deduction = ""
    @State private var coachNote = ""

    @State private var showError = false
    @State private var errorMessage = ""

    private let apparatusOptions = ["Free", "Hoop", "Ball", "Clubs", "Ribbon"]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    formCard
                    saveButton
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 12)
                .padding(.bottom, 100)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert("Please check the form", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

// MARK: - UI
private extension CoachAddResultView {
    var headerSection: some View {
        GlowiScreenHeader(
            title: "Add Result",
            subtitle: "Coach/Admin result entry"
        )
    }

    var formCard: some View {
        GlowiCard {
            VStack(spacing: 16) {
                inputField("Competition", text: $competition)
                inputField("Date", text: $date)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Apparatus")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)

                    Picker("Apparatus", selection: $apparatus) {
                        ForEach(apparatusOptions, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                inputField("Place", text: $place)
                inputField("Score", text: $score, keyboard: .decimalPad)

                HStack(spacing: 10) {
                    inputField("D", text: $difficulty, keyboard: .decimalPad)
                    inputField("A", text: $artistry, keyboard: .decimalPad)
                }

                HStack(spacing: 10) {
                    inputField("E", text: $execution, keyboard: .decimalPad)
                    inputField("Deduction", text: $deduction, keyboard: .decimalPad)
                }

                noteField
            }
        }
    }

    var noteField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Coach Note")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            TextEditor(text: $coachNote)
                .frame(minHeight: 100)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(Theme.softSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.radiusMedium)
                        .stroke(Theme.softStroke, lineWidth: 1)
                )
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
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .padding(14)
                .background(Theme.softSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.radiusMedium)
                        .stroke(Theme.softStroke, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    var saveButton: some View {
        PremiumPrimaryButton(title: "Save Result", icon: "checkmark.circle.fill") {
            validateAndSave()
        }
    }
}

// MARK: - Logic
private extension CoachAddResultView {
    func validateAndSave() {
        let cleanCompetition = competition.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanDate = date.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPlace = place.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanScore = score.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanCompetition.isEmpty else {
            errorMessage = "Competition name is required."
            showError = true
            return
        }

        guard !cleanDate.isEmpty else {
            errorMessage = "Date is required."
            showError = true
            return
        }

        guard !cleanPlace.isEmpty else {
            errorMessage = "Place is required."
            showError = true
            return
        }

        guard !cleanScore.isEmpty else {
            errorMessage = "Score is required."
            showError = true
            return
        }

        dashboardVM.addCompetitionResult(
            competition: cleanCompetition,
            date: cleanDate,
            apparatus: apparatus,
            place: cleanPlace,
            score: cleanScore,
            difficulty: difficulty.isEmpty ? "0.000" : difficulty,
            artistry: artistry.isEmpty ? "0.000" : artistry,
            execution: execution.isEmpty ? "0.000" : execution,
            deduction: deduction.isEmpty ? "0.00" : deduction,
            coachNote: coachNote.isEmpty ? "Result added by coach." : coachNote
        )

        dismiss()
    }
}

#Preview {
    NavigationStack {
        CoachAddResultView()
            .environmentObject(DashboardViewModel())
    }
}
