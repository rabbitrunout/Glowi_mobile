//
//  GlowiScreenHeader.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-21.
//

import SwiftUI

struct GlowiScreenHeader: View {
    let title: String
    let subtitle: String
    var trailing: AnyView? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(1.5)
            }

            Spacer(minLength: 12)

            if let trailing {
                trailing
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 2)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack {
            GlowiScreenHeader(
                title: "Hi, Irina 👋",
                subtitle: "Here’s your child’s latest overview",
                trailing: AnyView(
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 52, height: 52)
                )
            )
            .padding()
            Spacer()
        }
    }
}
