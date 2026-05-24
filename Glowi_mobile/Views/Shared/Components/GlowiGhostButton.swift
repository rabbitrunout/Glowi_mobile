//
//  GlowiGhostButton.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-19.
//

import SwiftUI

struct GlowiGhostButton: View {
    let title: String
    var action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.62))
                )
                .overlay(
                    Capsule()
                        .stroke(Theme.softStroke.opacity(0.9), lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.97 : 1)
                .animation(.spring(response: 0.2, dampingFraction: 0.84), value: isPressed)
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
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        GlowiGhostButton(title: "Preview") {
        }
    }
}
