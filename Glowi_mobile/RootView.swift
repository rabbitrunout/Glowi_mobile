//
//  RootView.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        if auth.isLoggedIn {
            MainTabView()
        } else {
            NavigationStack {
                WelcomeView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
        .environmentObject(DashboardViewModel())
}
