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
    var notifications: [GlowiNotification]

    enum CodingKeys: String, CodingKey {
        case child
        case events
        case sessions
        case payments
        case achievements
        case notifications
    }

    init(
        child: Child,
        events: [Event],
        sessions: [TrainingSession],
        payments: [Payment],
        achievements: [Achievement],
        notifications: [GlowiNotification] = []
    ) {
        self.child = child
        self.events = events
        self.sessions = sessions
        self.payments = payments
        self.achievements = achievements
        self.notifications = notifications
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        child = try container.decode(Child.self, forKey: .child)
        events = try container.decode([Event].self, forKey: .events)
        sessions = try container.decode([TrainingSession].self, forKey: .sessions)
        payments = try container.decode([Payment].self, forKey: .payments)
        achievements = try container.decode([Achievement].self, forKey: .achievements)

        // безопасно — если нет в JSON
        notifications = try container.decodeIfPresent([GlowiNotification].self, forKey: .notifications) ?? []
    }
}
