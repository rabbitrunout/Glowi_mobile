//
//  AuthViewModel.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var email: String = ""
    @Published var role: UserRole = .parent
    @Published var hasSelectedRole: Bool = false

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
        self.hasSelectedRole = false
        self.role = .parent
    }

    func register(email: String, password: String) {
        self.email = email
        self.isLoggedIn = true
        self.hasSelectedRole = false
        self.role = .parent
    }

    func selectRole(_ role: UserRole) {
        self.role = role
        self.hasSelectedRole = true
    }

    func logout() {
        self.email = ""
        self.role = .parent
        self.hasSelectedRole = false
        self.isLoggedIn = false
    }
}
