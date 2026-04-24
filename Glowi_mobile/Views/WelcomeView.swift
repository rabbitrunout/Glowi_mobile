import SwiftUI

struct WelcomeView: View {
    @State private var animateHero = false
    @State private var animateText = false
    @State private var animateButtons = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    heroImage(height: geo.size.height * 0.58)
                    contentBlock
                    Spacer(minLength: 14)
                    buttons
                        .padding(.bottom, 28)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                withAnimation(.easeOut(duration: 0.80)) {
                    animateHero = true
                }
                withAnimation(.easeOut(duration: 0.65).delay(0.14)) {
                    animateText = true
                }
                withAnimation(.spring(response: 0.70, dampingFraction: 0.86).delay(0.24)) {
                    animateButtons = true
                }
            }
        }
    }
}

private extension WelcomeView {
    func heroImage(height: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            Image("main_11(1)")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .offset(y: animateHero ? 20 : 54)
                .scaleEffect(animateHero ? 1.0 : 1.05)
                .opacity(animateHero ? 1 : 0)
                .clipped()

            LinearGradient(
                colors: [
                    Color.clear,
                    Theme.bgTop.opacity(0.10),
                    Theme.bgTop.opacity(0.42),
                    Theme.bgTop
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    var contentBlock: some View {
        VStack(spacing: 12) {
            Text("Whether You’re a Parent of a Young Beginner or a Future Olympian")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(1.5)
                .padding(.horizontal, 26)

            Text("Everything You Need Starts Here")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, -18)
        .offset(y: animateText ? 0 : 16)
        .opacity(animateText ? 1 : 0)
    }

    var buttons: some View {
        VStack(spacing: 12) {
            NavigationLink {
                LoginView()
            } label: {
                Text("Login")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Theme.primaryButtonGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Theme.pinkGlow, radius: 10, x: 0, y: 6)
            }
            .buttonStyle(.plain)

            NavigationLink {
                LoginView()
            } label: {
                Text("Create an account")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(Color.white.opacity(0.80))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Theme.softStroke, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: Theme.softShadow, radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .offset(y: animateButtons ? 0 : 24)
        .opacity(animateButtons ? 1 : 0)
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
