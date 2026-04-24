//
//  AuthViewModel.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import Foundation
import Combine

enum UserRole {
    case parent
    case admin
}

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var email: String = ""

    // По умолчанию приложение открывается как parent
    @Published var role: UserRole = .parent

    var isAdmin: Bool {
        role == .admin
    }

    var displayName: String {
        if email.isEmpty { return "Parent Account" }
        return email.components(separatedBy: "@").first?.capitalized ?? "Parent"
    }

    func login(email: String, password: String) {
        self.email = email
        self.isLoggedIn = true

        // Временно для теста:
        // если email содержит admin — будет админ
        if email.lowercased().contains("admin") {
            self.role = .admin
        } else {
            self.role = .parent
        }
    }

    func logout() {
        self.email = ""
        self.role = .parent
        self.isLoggedIn = false
    }
}
