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

            if self.events.isEmpty &&
                self.sessions.isEmpty &&
                self.payments.isEmpty &&
                self.achievements.isEmpty {
                self.state = .empty
            } else {
                self.state = .success
            }
        }
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

        let url = childPhotoURL()

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save child photo: \(error.localizedDescription)")
        }
    }

    private func loadSavedChildPhoto() {
        let url = childPhotoURL()

        guard FileManager.default.fileExists(atPath: url.path) else { return }
        guard let data = try? Data(contentsOf: url),
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
    }

    func addPayment() {
        let newId = (payments.map(\.id).max() ?? 0) + 1
        let newPayment = Payment(
            id: newId,
            month: "April",
            amount: "$190",
            status: "Pending"
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
}
