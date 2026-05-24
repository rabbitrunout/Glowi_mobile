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
    @Published var children: [Child] = []
    @Published var selectedChildId: Int = 0
    
    func updateSelectedChild(name: String, age: Int, level: String) {
        guard let index = children.firstIndex(where: { $0.id == selectedChildId }) else { return }

        children[index].name = name
        children[index].age = age
        children[index].level = level

        saveCurrentData()
    }

    var selectedChild: Child {
        children.first(where: { $0.id == selectedChildId })
        ?? children.first
        ?? Child(id: 0, name: "", age: 0, level: "", nextTraining: "")
    }

    // временная совместимость, чтобы старые экраны не сломались
    var child: Child {
        selectedChild
    }

    @Published var childPhoto: UIImage? = nil
    @Published var events: [Event] = []
    @Published var sessions: [TrainingSession] = []
    @Published var payments: [Payment] = []
    @Published var achievements: [Achievement] = []
    @Published var notifications: [GlowiNotification] = []
    @Published var suggestedCompetitions: [SuggestedCompetition] = [

        SuggestedCompetition(
            id: 1,
            childId: 1,
            title: "Koop Cup 2026",
            date: "Apr 26",
            location: "Markham Pan Am Centre",
            level: "Level 4B",
            apparatus: ["Free", "Ball", "Clubs"],
            entryFee: "$140",
            coachFee: "$60",
            deadline: "Apr 10",
            coachNote: "Good competition for consistency before Provincials.",
            status: "Suggested"
        ),

        SuggestedCompetition(
            id: 2,
            childId: 1,
            title: "Ontario Championships",
            date: "May 18",
            location: "Toronto",
            level: "National",
            apparatus: ["Hoop", "Ball", "Ribbon"],
            entryFee: "$180",
            coachFee: "$90",
            deadline: "May 1",
            coachNote: "Main event of the season.",
            status: "Suggested"
        )
    ]
    
    @Published var registeredCompetitions: [RegisteredCompetition] = []

    @Published var recentResults: [ResultItem] = [

        ResultItem(
            id: 1,
            childId: 1,
            competition: "Koop Cup 2026",
            date: "Apr 26",
            apparatus: "Free",
            place: "1st Place 🥇",
            score: "18.450",
            difficulty: "4.400",
            artistry: "7.000",
            execution: "7.050",
            deduction: "-0.00",
            coachNote: "Excellent expression and clean routine."
        ),

        ResultItem(
            id: 2,
            childId: 1,
            competition: "Provincial Qualifier",
            date: "Mar 15",
            apparatus: "Ball",
            place: "3rd Place 🥉",
            score: "16.800",
            difficulty: "3.900",
            artistry: "6.500",
            execution: "6.400",
            deduction: "-0.10",
            coachNote: "Need cleaner catches."
        )
    ]

    @Published var progressStats: [ProgressStat] = [
        ProgressStat(
            id: 1,
            title: "Trainings",
            value: "4 / 5",
            icon: "figure.gymnastics"
        ),

        ProgressStat(
            id: 2,
            title: "Goals",
            value: "3 / 4",
            icon: "flag.fill"
        ),

        ProgressStat(
            id: 3,
            title: "Awards",
            value: "12",
            icon: "trophy.fill"
        )
    ]
    @Published var state: LoadingState = .loading

    private let childPhotoFilename = "child_photo.jpg"

    init() {
        loadSavedChildPhoto()
        loadData()
    }

    func loadData() {
        state = .loading

        if let savedData = LocalDataStore.shared.load() {
            apply(appData: savedData)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            guard let appData = NetworkService.shared.loadMockData() else {
                self.state = .error("Failed to load local data.")
                return
            }

            self.apply(appData: appData)
            self.saveCurrentData()
        }
    }

    private func apply(appData: AppData) {
        children = appData.children
        selectedChildId = appData.selectedChildId
        events = appData.events
        sessions = appData.sessions
        payments = appData.payments
        achievements = appData.achievements
        notifications = appData.notifications

        state = events.isEmpty &&
            sessions.isEmpty &&
            payments.isEmpty &&
            achievements.isEmpty ? .empty : .success
    }

    func saveCurrentData() {
        let data = AppData(
            children: children,
            selectedChildId: selectedChildId,
            events: events,
            sessions: sessions,
            payments: payments,
            achievements: achievements,
            notifications: notifications
        )

        LocalDataStore.shared.save(data)
    }
    func selectChild(_ childId: Int) {
        selectedChildId = childId
        saveCurrentData()
    }
   

    func addChild(name: String, age: Int, level: String) {
        let newId = (children.map(\.id).max() ?? 0) + 1

        let newChild = Child(
            id: newId,
            name: name,
            age: age,
            level: level,
            nextTraining: "No training scheduled"
        )

        children.append(newChild)
        selectedChildId = newId

        addNotification(
            title: "Child profile added",
            message: "\(name) was added to your account.",
            type: "account"
        )

        saveCurrentData()
    }

    func registerForCompetition(_ competition: SuggestedCompetition) {
        let newPayment = Payment(
            id: (payments.map(\.id).max() ?? 0) + 1,
            month: competition.title,
            amount: competition.entryFee,
            status: "Pending",
            category: "Competition Fee",
            eventId: nil,
            dueDate: competition.deadline,
            childId: selectedChildId
        )

        payments.insert(newPayment, at: 0)

        let registered = RegisteredCompetition(
            id: Int.random(in: 1000...9999),
            childId: selectedChildId,
            title: competition.title,
            date: competition.date,
            location: competition.location,
            level: competition.level,
            apparatus: competition.apparatus,
            status: "Pending Payment"
        )

        registeredCompetitions.insert(registered, at: 0)

        addNotification(
            title: "Competition Added",
            message: "\(competition.title) registration is pending payment.",
            type: "competition"
        )

        saveCurrentData()
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

        saveCurrentData()
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

        saveCurrentData()
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
        saveCurrentData()
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
        saveCurrentData()
    }

    // MARK: - Payments

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

        saveCurrentData()
    }

    func payPayment(_ paymentId: Int) {
        guard let index = payments.firstIndex(where: { $0.id == paymentId }) else { return }

        payments[index].status = "Paid"

        addNotification(
            title: "Payment successful",
            message: "\(payments[index].month) has been paid.",
            type: "payment"
        )

        saveCurrentData()
    }

    func paymentUrgency(for payment: Payment) -> String {
        if payment.status.lowercased() == "paid" {
            return "Paid"
        }

        switch payment.dueDate {
        case "Mar 10":
            return "Overdue"
        case "Apr 15":
            return "Due soon"
        default:
            return "Pending"
        }
    }

    func paymentUrgencyColor(for urgency: String) -> Color {
        switch urgency {
        case "Paid":
            return Theme.greenDark
        case "Overdue":
            return Theme.error
        case "Due soon":
            return Theme.yellowDark
        default:
            return Theme.warning
        }
    }
    
    
    func addCompetitionResult(
        competition: String,
        date: String,
        apparatus: String,
        place: String,
        score: String,
        difficulty: String,
        artistry: String,
        execution: String,
        deduction: String,
        coachNote: String
    ) {
        let newResult = ResultItem(
            id: (recentResults.map(\.id).max() ?? 0) + 1,
            childId: selectedChildId,
            competition: competition,
            date: date,
            apparatus: apparatus,
            place: place,
            score: score,
            difficulty: difficulty,
            artistry: artistry,
            execution: execution,
            deduction: deduction,
            coachNote: coachNote
        )

        recentResults.insert(newResult, at: 0)

        addNotification(
            title: "New result added",
            message: "\(competition) — \(place) • \(apparatus)",
            type: "progress"
        )

        saveCurrentData()
    }

    // MARK: - Smart Insights

    var smartInsights: [AIInsight] {
        var insights: [AIInsight] = []

        if !sessions.isEmpty {
            insights.append(
                AIInsight(
                    title: "Training Focus",
                    message: "\(sessions.count) training sessions are planned. Keep consistency this week.",
                    type: "training"
                )
            )
        }

        if let nextEvent = events.first {
            insights.append(
                AIInsight(
                    title: "Upcoming Competition",
                    message: "\(nextEvent.title) is scheduled for \(nextEvent.date). Start preparing essentials early.",
                    type: "event"
                )
            )
        }

        if let pendingPayment = payments.first(where: { $0.status.lowercased() != "paid" }) {
            insights.append(
                AIInsight(
                    title: "Payment Reminder",
                    message: "\(pendingPayment.month) payment is pending. Due date: \(pendingPayment.dueDate).",
                    type: "payment"
                )
            )
        }

        if achievements.count > 0 {
            insights.append(
                AIInsight(
                    title: "Progress Highlight",
                    message: "\(child.name.isEmpty ? "Your gymnast" : child.name) has \(achievements.count) achievements recorded.",
                    type: "progress"
                )
            )
        }

        return insights
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
        saveCurrentData()
    }

    func markNotificationsAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }

        saveCurrentData()
    }

    var unreadNotificationsCount: Int {
        notifications.filter { !$0.isRead }.count
    }

    // MARK: - AI Checklist

    func generateCompetitionChecklist(for event: Event) -> [CompetitionChecklistItem] {

        [
            CompetitionChecklistItem(
                title: "Registration paid",
                isChecked: true
            ),

            CompetitionChecklistItem(
                title: "Music uploaded",
                isChecked: true
            ),

            CompetitionChecklistItem(
                title: "Leotard ready",
                isChecked: true
            ),

            CompetitionChecklistItem(
                title: "Apparatus confirmed",
                isChecked: true
            ),

            CompetitionChecklistItem(
                title: "Travel confirmed",
                isChecked: false
            )
        ]
    }

    private func arrivalTime(for eventTime: String) -> String {
        if eventTime.contains("09:00") {
            return "8:00 AM"
        }

        if eventTime.contains("11:30") {
            return "09:30 AM"
        }

        return "2 hours before"
    }
    
    func resetDemoData() {
        LocalDataStore.shared.clear()
        loadData()
    }
    
    func suggestCompetition(
        title: String,
        date: String,
        location: String,
        level: String,
        apparatus: [String],
        entryFee: String,
        coachFee: String,
        deadline: String,
        coachNote: String
    ) {
        let newCompetition = SuggestedCompetition(
            id: (suggestedCompetitions.map(\.id).max() ?? 0) + 1,
            childId: selectedChildId,
            title: title,
            date: date,
            location: location,
            level: level,
            apparatus: apparatus,
            entryFee: entryFee,
            coachFee: coachFee,
            deadline: deadline,
            coachNote: coachNote,
            status: "Suggested"
        )

        suggestedCompetitions.insert(newCompetition, at: 0)

        addNotification(
            title: "New competition suggested",
            message: "\(title) was recommended by coach.",
            type: "competition"
        )

        saveCurrentData()
    }
    
    func coachUpdateSelectedChildLevel(_ newLevel: String) {
        guard let index = children.firstIndex(where: { $0.id == selectedChildId }) else { return }

        children[index].level = newLevel

        addNotification(
            title: "Level updated",
            message: "\(children[index].name)'s level was updated to \(newLevel) by coach.",
            type: "progress"
        )

        saveCurrentData()
    }
}


private extension CalendarItem {
    var dateNumberOnly: String {
        let parts = date.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .filter { !$0.isEmpty }

        return parts.first ?? ""
    }
}


