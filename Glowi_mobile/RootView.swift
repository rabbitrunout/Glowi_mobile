//
//  RootView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            if auth.isLoggedIn {
                MainTabView()
            } else if hasSeenOnboarding {
                WelcomeView()
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
        .environmentObject(DashboardViewModel())
}
