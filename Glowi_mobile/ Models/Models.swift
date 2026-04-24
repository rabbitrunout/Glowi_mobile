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
}

struct TrainingSession: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var date: String
    var time: String
    var coach: String
}

struct Payment: Identifiable, Hashable, Codable {
    let id: Int
    var month: String
    var amount: String
    var status: String
}

struct Achievement: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var date: String
    var place: String
}
