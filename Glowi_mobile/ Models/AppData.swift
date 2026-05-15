//
//  AppData.swift
//  Glowi_mobile
//
//  Created by Irina Saf on 2026-04-02.
//

import Foundation

struct AppData: Codable {
    var children: [Child]
    var selectedChildId: Int
    var events: [Event]
    var sessions: [TrainingSession]
    var payments: [Payment]
    var achievements: [Achievement]
    var notifications: [GlowiNotification]

    enum CodingKeys: String, CodingKey {
        case child
        case children
        case selectedChildId
        case events
        case sessions
        case payments
        case achievements
        case notifications
    }

    init(
        children: [Child],
        selectedChildId: Int,
        events: [Event],
        sessions: [TrainingSession],
        payments: [Payment],
        achievements: [Achievement],
        notifications: [GlowiNotification] = []
    ) {
        self.children = children
        self.selectedChildId = selectedChildId
        self.events = events
        self.sessions = sessions
        self.payments = payments
        self.achievements = achievements
        self.notifications = notifications
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 👶 поддержка старого формата (child) и нового (children)
        if let decodedChildren = try container.decodeIfPresent([Child].self, forKey: .children) {
            children = decodedChildren
        } else if let legacyChild = try container.decodeIfPresent(Child.self, forKey: .child) {
            children = [legacyChild]
        } else {
            children = []
        }

        selectedChildId = try container.decodeIfPresent(Int.self, forKey: .selectedChildId)
            ?? children.first?.id
            ?? 0

        events = try container.decodeIfPresent([Event].self, forKey: .events) ?? []
        sessions = try container.decodeIfPresent([TrainingSession].self, forKey: .sessions) ?? []
        payments = try container.decodeIfPresent([Payment].self, forKey: .payments) ?? []
        achievements = try container.decodeIfPresent([Achievement].self, forKey: .achievements) ?? []
        notifications = try container.decodeIfPresent([GlowiNotification].self, forKey: .notifications) ?? []
    }

    // ✅ ОБЯЗАТЕЛЬНО для Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(children, forKey: .children)
        try container.encode(selectedChildId, forKey: .selectedChildId)
        try container.encode(events, forKey: .events)
        try container.encode(sessions, forKey: .sessions)
        try container.encode(payments, forKey: .payments)
        try container.encode(achievements, forKey: .achievements)
        try container.encode(notifications, forKey: .notifications)
    }
}
