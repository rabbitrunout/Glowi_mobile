//
//  GlowiButton.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-18.
//

import SwiftUI

// MARK: - Primary Button (gradient)
struct GlowiPrimaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.primaryButtonGradient)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
            .shadow(color: Theme.pinkGlow, radius: 10, x: 0, y: 6)
        }
    }
}

// MARK: - Secondary Button (soft)
struct GlowiSecondaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }

                Text(title)
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(Theme.textPrimary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.softSurface)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusLarge)
                    .stroke(Theme.softStroke, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
        }
    }
}

// MARK: - Capsule Button (for hero / CTA)
struct GlowiPrimaryCapsuleButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Theme.primaryButtonGradient)
            .clipShape(Capsule())
            .shadow(color: Theme.pinkGlow, radius: 12, x: 0, y: 6)
        }
    }
}

// MARK: - Danger Button (logout)
struct GlowiDangerButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            Theme.error,
                            Theme.peach
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLarge))
        }
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack(spacing: 16) {
            GlowiPrimaryButton(title: "Login", icon: "arrow.right") {}
            GlowiSecondaryButton(title: "Get Started", icon: "sparkles") {}
            GlowiPrimaryCapsuleButton(title: "Open Schedule", icon: "arrow.right") {}
            GlowiDangerButton(title: "Logout") {}
        }
        .padding()
    }
}

