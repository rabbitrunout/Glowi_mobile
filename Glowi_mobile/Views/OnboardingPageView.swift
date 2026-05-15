//
//  OnboardingPageView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-05.
//

import SwiftUI

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    @State private var animate = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(page.image)
                .resizable()
                .scaledToFit()
                .frame(height: 320)
                .scaleEffect(animate ? 1 : 0.95)
                .opacity(animate ? 1 : 0)
                .animation(.easeOut(duration: 0.6), value: animate)

            VStack(spacing: 10) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : 10)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: animate)

            Spacer()
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    OnboardingPageView(
        page: OnboardingPage(
            image: "main_11(1)",
            title: "Track Every Training",
            subtitle: "Stay on top of sessions, events, and progress."
        )
    )
}
