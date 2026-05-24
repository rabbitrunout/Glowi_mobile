//
//  CoachSuggestCompetitionView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct CoachSuggestCompetitionView: View {
    @EnvironmentObject var dashboardVM: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var date = ""
    @State private var location = ""
    @State private var level = "Level 4B"
    @State private var entryFee = ""
    @State private var coachFee = ""
    @State private var deadline = ""
    @State private var coachNote = ""

    @State private var selectedApparatus: Set<String> = ["Free"]

    @State private var showError = false
    @State private var errorMessage = ""

    private let levelOptions = [
        "Pre-Novice", "Novice", "Level 1", "Level 2A", "Level 3A",
        "Level 4B", "Level 5A", "Junior", "Senior", "National"
    ]

    private let apparatusOptions = ["Free", "Hoop", "Ball", "Clubs", "Ribbon"]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    GlowiScreenHeader(
                        title: "Suggest Competition",
                        subtitle: "Recommend an event for the selected athlete"
                    )

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

private extension CoachSuggestCompetitionView {
    var formCard: some View {
        GlowiCard {
            VStack(spacing: 16) {
                inputField("Competition Name", text: $title)
                inputField("Date", text: $date)
                inputField("Location", text: $location)

                levelPicker
                apparatusSelector

                HStack(spacing: 10) {
                    inputField("Entry Fee", text: $entryFee)
                    inputField("Coach Fee", text: $coachFee)
                }

                inputField("Deadline", text: $deadline)
                noteField
            }
        }
    }

    var levelPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Level")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            Picker("Level", selection: $level) {
                ForEach(levelOptions, id: \.self) { level in
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

    var apparatusSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Apparatus / Routines")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(apparatusOptions, id: \.self) { item in
                    Button {
                        if selectedApparatus.contains(item) {
                            selectedApparatus.remove(item)
                        } else {
                            selectedApparatus.insert(item)
                        }
                    } label: {
                        Text(item)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(
                                selectedApparatus.contains(item)
                                ? .white
                                : Theme.textSecondary
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                selectedApparatus.contains(item)
                                ? Theme.primaryButtonGradient
                                : LinearGradient(
                                    colors: [Theme.softSurface, Theme.softSurface],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
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
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    func inputField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            TextField(title, text: text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .padding(14)
                .background(Theme.softSurface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    var saveButton: some View {
        PremiumPrimaryButton(title: "Suggest Competition", icon: "star.fill") {
            validateAndSave()
        }
    }

    func validateAndSave() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Competition name is required."
            showError = true
            return
        }

        guard !date.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Date is required."
            showError = true
            return
        }

        guard !location.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Location is required."
            showError = true
            return
        }

        guard !selectedApparatus.isEmpty else {
            errorMessage = "Please select at least one apparatus."
            showError = true
            return
        }

        dashboardVM.suggestCompetition(
            title: title.trimmingCharacters(in: .whitespaces),
            date: date.trimmingCharacters(in: .whitespaces),
            location: location.trimmingCharacters(in: .whitespaces),
            level: level,
            apparatus: Array(selectedApparatus).sorted(),
            entryFee: entryFee.isEmpty ? "$0" : entryFee,
            coachFee: coachFee.isEmpty ? "$0" : coachFee,
            deadline: deadline.isEmpty ? date : deadline,
            coachNote: coachNote.isEmpty ? "Recommended by coach." : coachNote
        )

        dismiss()
    }
}

#Preview {
    NavigationStack {
        CoachSuggestCompetitionView()
            .environmentObject(DashboardViewModel())
    }
}
