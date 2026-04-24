//
//  Glowi_mobileApp.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import SwiftUI

@main
struct Glowi_mobileApp: App {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var dashboardVM = DashboardViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(dashboardVM)
        }
    }
}

