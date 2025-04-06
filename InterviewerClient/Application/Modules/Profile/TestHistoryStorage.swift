import Foundation

struct TestHistoryAnswer: Codable, Identifiable {
    var id = UUID()
    let question: String
    let userAnswer: String
    let correctAnswer: String
    let explanation: String
}

struct TestHistoryEntry: Codable, Identifiable {
    var id = UUID()
    let topic: String
    let answers: [TestHistoryAnswer]
    let correctAnswers: Int
    let incorrectAnswers: Int
    let timeTaken: String
}

class TestHistoryStorage {
    static let shared = TestHistoryStorage()
    private let key = "TestHistoryEntries"

    func save(entry: TestHistoryEntry) {
        var current = load()
        current.insert(entry, at: 0)
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> [TestHistoryEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([TestHistoryEntry].self, from: data) else {
            return []
        }
        return decoded
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
