import UIKit

class QuestionLoader {
    static func loadQuestions(for topic: String) -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let allQuestions = try? JSONDecoder().decode([Question].self, from: data) else {
            return []
        }

        return allQuestions.filter { $0.topic == topic }
    }
    
    static func loadAllQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([Question].self, from: data)
            return decodedData
        } catch {
            return []
        }
    }
}

