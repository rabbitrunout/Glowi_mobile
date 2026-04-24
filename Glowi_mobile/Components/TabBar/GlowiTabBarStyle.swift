//
//  GlowiTabBarStyle.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-18.
//

import SwiftUI

struct GlowiTabBarContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .toolbarBackground(.hidden, for: .tabBar)
    }
}

struct GlowiFloatingTabBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(Color.white.opacity(0.88))
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Theme.stroke, lineWidth: 1)
            )
            .shadow(color: Theme.shadow, radius: 16, x: 0, y: 8)
            .frame(height: 76)
    }
}

struct GlowiTabItemLabel: View {
    let title: String
    let systemImage: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .semibold))

            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(isActive ? Theme.pinkDark : Theme.textSecondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            isActive
            ? Theme.pink.opacity(0.14)
            : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()

        VStack {
            Spacer()

            ZStack {
                GlowiFloatingTabBackground()

                HStack(spacing: 8) {
                    GlowiTabItemLabel(title: "Home", systemImage: "house.fill", isActive: true)
                    GlowiTabItemLabel(title: "Schedule", systemImage: "calendar", isActive: false)
                    GlowiTabItemLabel(title: "Events", systemImage: "calendar.badge.plus", isActive: false)
                    GlowiTabItemLabel(title: "Payments", systemImage: "creditcard", isActive: false)
                    GlowiTabItemLabel(title: "Account", systemImage: "person.crop.circle", isActive: false)
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}
