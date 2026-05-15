//
//  OnboardingView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-05.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentIndex = 0

    let pages: [OnboardingPage] = [
        .init(
            image: "main_11(1)",
            title: "Track Every Training",
            subtitle: "Stay on top of sessions, events, and progress."
        ),
        .init(
            image: "main_6(1)",
            title: "Never Miss a Payment",
            subtitle: "Manage fees and deadlines effortlessly."
        ),
        .init(
            image: "main_11(1)",
            title: "Support Your Gymnast",
            subtitle: "Everything you need in one place."
        )
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(pages.indices, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                indicators

                button
                    .padding(.horizontal, 28)
                    .padding(.bottom, 30)
            }
        }
    }
}

private extension OnboardingView {
    var indicators: some View {
        HStack(spacing: 8) {
            ForEach(pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Theme.pinkDark : Theme.softStroke)
                    .frame(width: index == currentIndex ? 20 : 8, height: 8)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
        .padding(.vertical, 12)
    }

    var button: some View {
        Button {
            if currentIndex < pages.count - 1 {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    currentIndex += 1
                }
            } else {
                hasSeenOnboarding = true
            }
        } label: {
            Text(currentIndex == pages.count - 1 ? "Get Started" : "Continue")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(Theme.primaryButtonGradient)
                .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView()
}
