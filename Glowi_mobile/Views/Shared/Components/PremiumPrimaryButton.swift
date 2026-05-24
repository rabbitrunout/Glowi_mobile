//
//  PremiumPrimaryButton.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-19.
//

import SwiftUI

struct PremiumPrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    @State private var shimmer = false
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Theme.primaryButtonGradient)

                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.16),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(18))
                        .offset(x: shimmer ? geo.size.width * 1.15 : -geo.size.width * 1.15)
                }
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .allowsHitTesting(false)

                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .semibold))

                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
            }
            .frame(height: 58)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: Theme.pinkGlow.opacity(0.9), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.985 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.82), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { isPressed = true }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .onAppear {
            shimmer = false
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                shimmer = true
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        PremiumPrimaryButton(title: "Continue", icon: "arrow.right") {
        }
        .padding()
    }
}
