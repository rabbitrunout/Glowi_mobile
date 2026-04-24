//
//  LoginFormView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-19.
//

import SwiftUI

struct LoginFormView: View {
    @EnvironmentObject var auth: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Welcome back")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Theme.textPrimary)

                        Text("Login to continue tracking training, events, payments, and progress.")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 24)

                    GlowiCard {
                        VStack(spacing: 18) {
                            emailField
                            passwordField

                            GlowiPrimaryButton(title: "Continue", icon: "arrow.right") {
                                auth.login(email: email, password: password)
                            }

                            HStack {
                                Spacer()
                                GlowiGhostButton(title: "Forgot password?") {
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, 30)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension LoginFormView {
    var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Email")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: "envelope")
                    .foregroundColor(Theme.textMuted)

                TextField("Enter your email", text: $email)
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

    var passwordField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Password")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .foregroundColor(Theme.textMuted)

                Group {
                    if isPasswordHidden {
                        SecureField("Enter your password", text: $password)
                    } else {
                        TextField("Enter your password", text: $password)
                    }
                }
                .foregroundColor(Theme.textPrimary)

                Button {
                    isPasswordHidden.toggle()
                } label: {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
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
}

#Preview {
    NavigationStack {
        LoginFormView()
            .environmentObject(AuthViewModel())
    }
}
