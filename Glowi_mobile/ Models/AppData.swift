//
//  AppData.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import Foundation

struct AppData: Codable {
    var child: Child
    var events: [Event]
    var sessions: [TrainingSession]
    var payments: [Payment]
    var achievements: [Achievement]
}
