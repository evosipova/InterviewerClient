import Foundation

struct NotificationItem: Identifiable, Codable {
    var id = UUID()
    let time: Date
    let days: [String]

    func sortedDays() -> [String] {
        let orderedDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        return days.sorted { orderedDays.firstIndex(of: $0)! < orderedDays.firstIndex(of: $1)! }
    }

    var displayText: String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeString = timeFormatter.string(from: time)
        let daysString = sortedDays().joined(separator: ", ")
        return "\(timeString) - \(daysString)"
    }
}
