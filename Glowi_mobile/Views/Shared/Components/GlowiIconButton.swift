//
//  GlowiIconButton.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-19.
//

import SwiftUI

struct GlowiIconButton: View {
    let systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 36, height: 36)

                Image(systemName: systemImage)
                    .foregroundColor(Theme.textPrimary)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        GlowiIconButton(systemImage: "ellipsis") {
        }
    }
}
