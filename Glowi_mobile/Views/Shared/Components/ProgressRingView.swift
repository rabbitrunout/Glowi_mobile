//
//  ProgressRingView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-18.
//

import SwiftUI

struct ProgressRingView: View {

    var title: String
    var score: Double
    var color: Color

    private var progress: Double {
        min(score / 20.0, 1.0)
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.16), lineWidth: 12)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.2), value: progress)

                VStack(spacing: 2) {
                    Text(String(format: "%.1f", score))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text("/ 20")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            .frame(width: 92, height: 92)

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

#Preview {
    ProgressRingView(
        title: "Ribbon",
        score: 18.4,
        color: Theme.pinkDark
    )
}
