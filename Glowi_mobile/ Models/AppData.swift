import Foundation

struct AppData: Codable {
    var children: [Child]
    var selectedChildId: Int
    var events: [Event]
    var sessions: [TrainingSession]
    var payments: [Payment]
    var achievements: [Achievement]
    var notifications: [GlowiNotification]
    var suggestedCompetitions: [SuggestedCompetition]
    var recentResults: [ResultItem]
    var progressStats: [ProgressStat]
    var registeredCompetitions: [RegisteredCompetition]

    enum CodingKeys: String, CodingKey {
        case child
        case children
        case selectedChildId
        case events
        case sessions
        case payments
        case achievements
        case notifications
        case suggestedCompetitions
        case recentResults
        case progressStats
        case registeredCompetitions
    }

    init(
        children: [Child],
        selectedChildId: Int,
        events: [Event],
        sessions: [TrainingSession],
        payments: [Payment],
        achievements: [Achievement],
        notifications: [GlowiNotification] = [],
        suggestedCompetitions: [SuggestedCompetition] = [],
        recentResults: [ResultItem] = [],
        progressStats: [ProgressStat] = [],
        registeredCompetitions: [RegisteredCompetition] = []
    ) {
        self.children = children
        self.selectedChildId = selectedChildId
        self.events = events
        self.sessions = sessions
        self.payments = payments
        self.achievements = achievements
        self.notifications = notifications
        self.suggestedCompetitions = suggestedCompetitions
        self.recentResults = recentResults
        self.progressStats = progressStats
        self.registeredCompetitions = registeredCompetitions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

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

        suggestedCompetitions = try container.decodeIfPresent([SuggestedCompetition].self, forKey: .suggestedCompetitions) ?? []
        recentResults = try container.decodeIfPresent([ResultItem].self, forKey: .recentResults) ?? []
        progressStats = try container.decodeIfPresent([ProgressStat].self, forKey: .progressStats) ?? []
        registeredCompetitions = try container.decodeIfPresent([RegisteredCompetition].self, forKey: .registeredCompetitions) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(children, forKey: .children)
        try container.encode(selectedChildId, forKey: .selectedChildId)
        try container.encode(events, forKey: .events)
        try container.encode(sessions, forKey: .sessions)
        try container.encode(payments, forKey: .payments)
        try container.encode(achievements, forKey: .achievements)
        try container.encode(notifications, forKey: .notifications)

        try container.encode(suggestedCompetitions, forKey: .suggestedCompetitions)
        try container.encode(recentResults, forKey: .recentResults)
        try container.encode(progressStats, forKey: .progressStats)
        try container.encode(registeredCompetitions, forKey: .registeredCompetitions)
    }
}
