//
//  RoleSelectionView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-05-24.
//

import SwiftUI

struct RoleSelectionView: View {

    @EnvironmentObject var auth: AuthViewModel

    var body: some View {

        ZStack {

            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Spacer()

                Text("Choose Your Role")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Theme.textPrimary)

                Text("Different experiences for parents, athletes, coaches, and admins.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                VStack(spacing: 16) {

                    roleButton(
                        title: "Parent App",
                        subtitle: "Manage schedules, payments, results",
                        icon: "person.2.fill",
                        color: Theme.pinkDark
                    ) {
                        auth.selectRole(.parent)
                    }

                    roleButton(
                        title: "Athlete View",
                        subtitle: "Progress, awards, achievements",
                        icon: "figure.gymnastics",
                        color: Theme.lavender
                    ) {
                        auth.selectRole(.athlete)
                    }

                    roleButton(
                        title: "Coach Portal",
                        subtitle: "Manage athletes & competitions",
                        icon: "person.badge.key.fill",
                        color: Theme.blueDark
                    ) {
                        auth.selectRole(.coach)
                    }

                    roleButton(
                        title: "Admin Dashboard",
                        subtitle: "System management",
                        icon: "shield.fill",
                        color: Theme.greenDark
                    ) {
                        auth.selectRole(.admin)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    func roleButton(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {

        Button(action: action) {

            HStack(spacing: 16) {

                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(color.opacity(0.15))
                        .frame(width: 58, height: 58)

                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {

                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()
            }
            .padding(18)
            .background(Theme.elevatedSurface)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RoleSelectionView()
        .environmentObject(AuthViewModel())
}
