//
//  RegisterView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-05.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var isPasswordHidden = true
    @State private var isConfirmHidden = true

    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    headerSection

                    GlowiCard {
                        VStack(spacing: 18) {
                            emailField
                            passwordField
                            confirmPasswordField

                            PremiumPrimaryButton(title: "Create Account", icon: "sparkles") {
                                validateAndRegister()
                            }

                            Button {
                                dismiss()
                            } label: {
                                Text("Already have an account? Log in")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.pinkDark)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
        }
        .alert("Please check the form", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

private extension RegisterView {
    var headerSection: some View {
        VStack(spacing: 8) {
            Text("Create account")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text("Set up your parent profile to manage training, events, payments, and progress.")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }

    var emailField: some View {
        inputField(
            title: "Email",
            icon: "envelope",
            placeholder: "Enter your email",
            text: $email
        )
    }

    var passwordField: some View {
        secureInputField(
            title: "Password",
            placeholder: "Create password",
            text: $password,
            isHidden: $isPasswordHidden
        )
    }

    var confirmPasswordField: some View {
        secureInputField(
            title: "Confirm Password",
            placeholder: "Repeat password",
            text: $confirmPassword,
            isHidden: $isConfirmHidden
        )
    }

    func inputField(
        title: String,
        icon: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(Theme.textMuted)

                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(Theme.textPrimary)
            }
            .padding()
            .background(Theme.softSurface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusMedium)
                    .stroke(Theme.softStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    func secureInputField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isHidden: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundColor(Theme.textMuted)

                Group {
                    if isHidden.wrappedValue {
                        SecureField(placeholder, text: text)
                    } else {
                        TextField(placeholder, text: text)
                    }
                }
                .foregroundColor(Theme.textPrimary)

                Button {
                    isHidden.wrappedValue.toggle()
                } label: {
                    Image(systemName: isHidden.wrappedValue ? "eye.slash" : "eye")
                        .foregroundColor(Theme.textMuted)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Theme.softSurface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusMedium)
                    .stroke(Theme.softStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMedium))
        }
    }

    func validateAndRegister() {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard cleanEmail.contains("@"), cleanEmail.contains(".") else {
            errorMessage = "Please enter a valid email."
            showError = true
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password should be at least 6 characters."
            showError = true
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return
        }

        auth.register(email: cleanEmail, password: password)
        dismiss()
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
