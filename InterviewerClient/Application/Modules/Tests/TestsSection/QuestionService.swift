import Foundation

class QuestionService {
    static let shared = QuestionService()

    private let generateTestURL = URL(string: "https://truculently-neat-roach.cloudpub.ru/ai/generate-test")!

    func fetchAIQuestions() async throws -> [Question] {
        var request = URLRequest(url: generateTestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        guard httpResponse?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let rawJSONString = try JSONDecoder().decode(String.self, from: data)

        guard let jsonData = rawJSONString.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }

        let decodedQuestions = try JSONDecoder().decode([Question].self, from: jsonData)
        return decodedQuestions
    }
}
