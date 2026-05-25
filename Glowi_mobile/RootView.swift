//
//  RootView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if !auth.isLoggedIn {
                WelcomeView()
            } else if !auth.hasSelectedRole {
                RoleSelectionView()
            } else {
                switch auth.role {

                case .parent:
                    MainTabView()

                case .coach:
                    CoachMainView()

                case .athlete:
                    AthleteMainView()

                case .admin:
                    AdminMainView()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
        .environmentObject(DashboardViewModel())
}
