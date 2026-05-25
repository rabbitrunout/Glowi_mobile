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

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    headerSection
                    rolesGrid
                    footerNote
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 36)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension RoleSelectionView {
    var headerSection: some View {
        VStack(spacing: 10) {
            Text("Choose your experience")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)

            Text("Glowi adapts for parents, athletes, coaches, and admins.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
    }

    var rolesGrid: some View {
        VStack(spacing: 14) {
            roleCard(
                title: "Parent App",
                subtitle: "Schedule, payments, competitions, and updates",
                icon: "person.2.fill",
                accent: Theme.pinkDark
            ) {
                auth.selectRole(.parent)
            }

            roleCard(
                title: "Athlete View",
                subtitle: "Progress, awards, routines, and goals",
                icon: "figure.gymnastics",
                accent: Theme.athleteAccent
            ) {
                auth.selectRole(.athlete)
            }

            roleCard(
                title: "Coach Portal",
                subtitle: "Add results, suggest competitions, approve levels",
                icon: "person.badge.key.fill",
                accent: Theme.blueDark
            ) {
                auth.selectRole(.coach)
            }

            roleCard(
                title: "Admin Dashboard",
                subtitle: "Manage users, payments, events, and reports",
                icon: "shield.fill",
                accent: Theme.greenDark
            ) {
                auth.selectRole(.admin)
            }
        }
    }

    func roleCard(
        title: String,
        subtitle: String,
        icon: String,
        accent: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(accent.opacity(0.15))
                        .frame(width: 58, height: 58)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(accent)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Theme.textMuted)
            }
            .padding(18)
            .background(Theme.elevatedSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    var footerNote: some View {
        Text("Demo mode lets you explore all platform roles.")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Theme.textMuted)
            .multilineTextAlignment(.center)
            .padding(.top, 4)
    }
}

#Preview {
    RoleSelectionView()
        .environmentObject(AuthViewModel())
}
