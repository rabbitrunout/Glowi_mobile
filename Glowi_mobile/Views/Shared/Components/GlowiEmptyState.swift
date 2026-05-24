//
//  GlowiEmptyState.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-21.
//

import SwiftUI

struct GlowiEmptyState: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.accentGradient.opacity(0.55))
                    .frame(width: 72, height: 72)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(Theme.pinkDark)
            }

            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1.5)
                    .padding(.horizontal, 8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusLarge, style: .continuous)
                .fill(Color.white.opacity(0.46))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusLarge, style: .continuous)
                .stroke(Theme.stroke.opacity(0.85), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        GlowiEmptyState(
            icon: "calendar",
            title: "No upcoming sessions",
            message: "New training sessions will appear here."
        )
        .padding()
    }
}
