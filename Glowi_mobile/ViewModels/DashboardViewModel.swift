import Foundation
import Combine
import SwiftUI
import UIKit

enum LoadingState {
    case loading
    case success
    case empty
    case error(String)
}

final class DashboardViewModel: ObservableObject {
    @Published var child = Child(
        id: 0,
        name: "",
        age: 0,
        level: "",
        nextTraining: ""
    )

    @Published var childPhoto: UIImage? = nil
    @Published var events: [Event] = []
    @Published var sessions: [TrainingSession] = []
    @Published var payments: [Payment] = []
    @Published var achievements: [Achievement] = []
    @Published var notifications: [GlowiNotification] = []
    @Published var state: LoadingState = .loading

    private let childPhotoFilename = "child_photo.jpg"

    init() {
        loadSavedChildPhoto()
        loadData()
    }

    func loadData() {
        state = .loading

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            guard let appData = NetworkService.shared.loadMockData() else {
                self.state = .error("Failed to load local data.")
                return
            }

            self.child = appData.child
            self.events = appData.events
            self.sessions = appData.sessions
            self.payments = appData.payments
            self.achievements = appData.achievements
            self.notifications = appData.notifications

            self.state = self.events.isEmpty &&
                self.sessions.isEmpty &&
                self.payments.isEmpty &&
                self.achievements.isEmpty ? .empty : .success
        }
    }

    // MARK: - Calendar

    var calendarItems: [CalendarItem] {
        let trainingItems = sessions.map {
            CalendarItem(
                id: "session-\($0.id)",
                title: $0.title,
                date: $0.date,
                time: $0.time,
                subtitle: $0.coach,
                type: "training",
                relatedEventId: nil
            )
        }

        let eventItems = events.map {
            CalendarItem(
                id: "event-\($0.id)",
                title: $0.title,
                date: $0.date,
                time: $0.time,
                subtitle: $0.location,
                type: $0.type.lowercased().contains("competition") ? "competition" : "event",
                relatedEventId: $0.id
            )
        }

        let paymentItems = payments
            .filter { $0.status.lowercased() != "paid" }
            .map {
                CalendarItem(
                    id: "payment-\($0.id)",
                    title: "\($0.month) payment due",
                    date: $0.dueDate,
                    time: "",
                    subtitle: "\($0.amount) • \($0.status)",
                    type: "payment",
                    relatedEventId: $0.eventId
                )
            }

        return trainingItems + eventItems + paymentItems
    }

    func calendarItems(for day: String) -> [CalendarItem] {
        calendarItems.filter { $0.dateNumberOnly == day }
    }

    // MARK: - Photo Persistence

    func updateChildPhoto(_ image: UIImage) {
        childPhoto = image
        saveChildPhoto(image)
    }

    func removeChildPhoto() {
        childPhoto = nil

        let url = childPhotoURL()
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    private func saveChildPhoto(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }

        do {
            try data.write(to: childPhotoURL(), options: .atomic)
        } catch {
            print("Failed to save child photo: \(error.localizedDescription)")
        }
    }

    private func loadSavedChildPhoto() {
        let url = childPhotoURL()

        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return }

        childPhoto = image
    }

    private func childPhotoURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(childPhotoFilename)
    }

    // MARK: - Demo Actions

    func addEvent() {
        let newId = (events.map(\.id).max() ?? 0) + 1

        let newEvent = Event(
            id: newId,
            title: "New Club Event",
            date: "Jun 15",
            time: "10:00 AM",
            location: "Mississauga Gym Center",
            type: "Club Event"
        )

        events.insert(newEvent, at: 0)

        addNotification(
            title: "New event added",
            message: "\(newEvent.title) was added for \(newEvent.date).",
            type: "event"
        )
    }

    func addSession() {
        let newId = (sessions.map(\.id).max() ?? 0) + 1

        let newSession = TrainingSession(
            id: newId,
            title: "Stretching Session",
            date: "Jun 12",
            time: "5:30 PM",
            coach: "Coach Elena"
        )

        sessions.insert(newSession, at: 0)

        addNotification(
            title: "New training added",
            message: "\(newSession.title) was added for \(newSession.date) at \(newSession.time).",
            type: "session"
        )
    }

    func addPayment() {
        let newId = (payments.map(\.id).max() ?? 0) + 1

        let newPayment = Payment(
            id: newId,
            month: "April",
            amount: "$190",
            status: "Pending",
            category: "training",
            eventId: nil,
            dueDate: "Apr 10"
        )

        payments.insert(newPayment, at: 0)
    }

    func addAchievement() {
        let newId = (achievements.map(\.id).max() ?? 0) + 1

        let newAchievement = Achievement(
            id: newId,
            title: "Summer Cup",
            date: "2026-06-20",
            place: "1st Place"
        )

        achievements.insert(newAchievement, at: 0)
    }

    // MARK: - Event Payments

    func paymentForEvent(_ eventId: Int) -> Payment? {
        payments.first {
            $0.category.lowercased() == "competition" && $0.eventId == eventId
        }
    }

    func payForEvent(_ eventId: Int) {
        guard let index = payments.firstIndex(where: {
            $0.category.lowercased() == "competition" && $0.eventId == eventId
        }) else { return }

        payments[index].status = "Paid"

        addNotification(
            title: "Payment successful",
            message: "\(payments[index].month) fee has been paid.",
            type: "payment"
        )
    }

    // MARK: - Notifications

    func addNotification(title: String, message: String, type: String) {
        let new = GlowiNotification(
            id: (notifications.map(\.id).max() ?? 0) + 1,
            title: title,
            message: message,
            date: "Today",
            type: type,
            isRead: false
        )

        notifications.insert(new, at: 0)
    }

    func markNotificationsAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
    
    var unreadNotificationsCount: Int {
        notifications.filter { !$0.isRead }.count
    }
}



private extension CalendarItem {
    var dateNumberOnly: String {
        let parts = date.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }

        return parts.first ?? ""
    }
}
