import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let topic: String
    let questionText: String
    let explanation: String
    let answers: [Answer]
    
    var correctAnswer: String {
        return answers.first { $0.isCorrect }?.text ?? "Нет правильного ответа"
    }
}

struct Answer: Codable, Equatable {
    let text: String
    let isCorrect: Bool
}
