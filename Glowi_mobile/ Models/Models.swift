import Foundation

struct Child: Identifiable, Hashable, Codable {
    let id: Int
    var name: String
    var age: Int
    var level: String
    var nextTraining: String
}

struct Event: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var date: String
    var time: String
    var location: String
    var type: String
    var childId: Int? = nil
}

struct TrainingSession: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var date: String
    var time: String
    var coach: String
    var childId: Int? = nil
}

struct Payment: Identifiable, Hashable, Codable {
    let id: Int
    var month: String
    var amount: String
    var status: String
    var category: String
    var eventId: Int?
    var dueDate: String
    var childId: Int? = nil
}

struct Achievement: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var date: String
    var place: String
    var childId: Int? = nil
}

struct GlowiNotification: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var message: String
    var date: String
    var type: String
    var isRead: Bool
}

struct AIInsight: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var message: String
    var type: String
}

struct CompetitionChecklistItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isChecked: Bool = false
}

struct CalendarItem: Identifiable, Hashable {
    let id: String
    var title: String
    var date: String
    var time: String
    var subtitle: String
    var type: String
    var relatedEventId: Int?
}
