import SwiftUI

struct EditChildView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dashboardVM: DashboardViewModel

    @State private var name: String = ""
    @State private var age: String = ""
    @State private var level: String = ""

    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSavedToast = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Theme.bgTop, Theme.bgBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    headerSection
                    formCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 90)
            }

            if showSavedToast {
                VStack {
                    Spacer()

                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Saved")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .padding(.bottom, 28)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showSavedToast)
        .onAppear {
            loadData()
        }
        .alert("Please check the form", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    validateAndSave()
                }
                .foregroundColor(Theme.pink)
                .fontWeight(.semibold)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Sections
private extension EditChildView {
    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Edit Profile")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                Text("Update athlete information")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()
        }
    }

    var formCard: some View {
        GlowiCard {
            VStack(spacing: 16) {
                inputField(title: "Name", text: $name)
                inputField(title: "Age", text: $age, keyboard: .numberPad)
                inputField(title: "Level", text: $level)

                Button(action: validateAndSave) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save Changes")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.pink)
                    .clipShape(Capsule())
                }
                .shadow(color: Theme.pink.opacity(0.4), radius: 10, x: 0, y: 4)
            }
        }
    }

    func inputField(title: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.white.opacity(0.72))
                .font(.caption)

            TextField("", text: text)
                .keyboardType(keyboard)
                .padding()
                .background(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Logic
private extension EditChildView {
    func loadData() {
        let child = dashboardVM.child
        name = child.name
        age = "\(child.age)"
        level = child.level
    }

    func validateAndSave() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLevel = level.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            errorMessage = "Name cannot be empty."
            showError = true
            return
        }

        guard let ageValue = Int(age), ageValue > 0, ageValue <= 25 else {
            errorMessage = "Please enter a valid age."
            showError = true
            return
        }

        guard !trimmedLevel.isEmpty else {
            errorMessage = "Level cannot be empty."
            showError = true
            return
        }

        dashboardVM.child.name = trimmedName
        dashboardVM.child.age = ageValue
        dashboardVM.child.level = trimmedLevel

        showSavedToast = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        EditChildView()
            .environmentObject(DashboardViewModel())
    }
}
