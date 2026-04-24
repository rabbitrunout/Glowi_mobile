import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var animateHero = false
    @State private var animateText = false
    @State private var animateForm = false
    @State private var floating = false
    @State private var glowPulse = false

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        topBar
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        heroSection(height: geo.size.height * 0.40)

                        headerSection
                            .padding(.top, -20)

                        formSection
                            .padding(.top, 18)
                            .padding(.horizontal, Theme.screenPadding)
                            .padding(.bottom, 30)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                withAnimation(.easeOut(duration: 0.60)) {
                    animateHero = true
                }
                withAnimation(.easeOut(duration: 0.55).delay(0.10)) {
                    animateText = true
                }
                withAnimation(.spring(response: 0.72, dampingFraction: 0.88).delay(0.16)) {
                    animateForm = true
                }

                floating = true
                glowPulse = true
            }
        }
    }
}

private extension LoginView {
    var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.82))
                        .frame(width: 42, height: 42)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
                .shadow(color: Theme.softShadow, radius: 6, x: 0, y: 3)
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }

    func heroSection(height: CGFloat) -> some View {
        ZStack {
            RadialGradient(
                colors: [
                    Theme.pinkGlow.opacity(glowPulse ? 0.32 : 0.18),
                    Theme.blueGlow.opacity(glowPulse ? 0.18 : 0.08),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 220
            )
            .blur(radius: 30)
            .scaleEffect(glowPulse ? 1.06 : 0.94)
            .animation(
                .easeInOut(duration: 2.8).repeatForever(autoreverses: true),
                value: glowPulse
            )

            Image("main_6(1)")
                .resizable()
                .scaledToFit()
                .frame(height: height)
                .offset(
                    x: 0,
                    y: animateHero
                        ? (floating ? -8 : 2)
                        : 30
                )
                .scaleEffect(
                    animateHero
                        ? (floating ? 1.012 : 0.992)
                        : 1.06
                )
                .opacity(animateHero ? 1 : 0)
                .animation(
                    .easeInOut(duration: 3.2).repeatForever(autoreverses: true),
                    value: floating
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 6)
    }

    var headerSection: some View {
        VStack(spacing: 8) {
            Text("Welcome back")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Theme.textPrimary)

            Text("Login to continue tracking training, events, payments, and progress.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(1.5)
                .padding(.horizontal, 28)
        }
        .offset(y: animateText ? 0 : 12)
        .opacity(animateText ? 1 : 0)
    }

    var formSection: some View {
        GlowiCard {
            VStack(spacing: 18) {
                emailField
                passwordField

                PremiumPrimaryButton(title: "Continue", icon: "arrow.right") {
                    auth.login(email: email, password: password)
                }

                HStack {
                    Spacer()
                    GlowiGhostButton(title: "Forgot password?") {
                    }
                }
            }
        }
        .padding(.top, 12)
        .shadow(color: Theme.softShadow.opacity(0.6), radius: 16, x: 0, y: 10)
        .offset(y: animateForm ? 0 : 20)
        .opacity(animateForm ? 1 : 0)
    }

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
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
