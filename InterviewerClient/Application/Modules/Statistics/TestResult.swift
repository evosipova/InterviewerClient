import Foundation

struct TestSession: Codable, Identifiable {
    var id = UUID()
    let correctAnswers: Int
    let incorrectAnswers: Int
    let duration: Int  
}

class TestStatisticsStorage {
    static let shared = TestStatisticsStorage()

    private let key = "TestStatistics"

    func saveSession(_ session: TestSession) {
        var sessions = loadAllSessions()
        sessions.append(session)
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadAllSessions() -> [TestSession] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let sessions = try? JSONDecoder().decode([TestSession].self, from: data) else {
            return []
        }
        return sessions
    }
}

