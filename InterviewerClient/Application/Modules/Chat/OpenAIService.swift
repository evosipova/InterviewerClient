import Foundation

struct OpenAIChatMessage: Codable {
    let role: String
    let content: String
}

struct InterviewRequest: Codable {
    let answer: String
}

struct InterviewResponse: Codable {
    let question: String
}

class OpenAIService: ObservableObject {
    @Published var gptResponse: String = ""

    private let url = URL(string: "https://truculently-neat-roach.cloudpub.ru/ai/interview")!

    func sendMessageToGPT(answer: String) async throws -> String {
        let body = InterviewRequest(answer: answer)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        guard httpResponse?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(InterviewResponse.self, from: data)
        return decoded.question
    }

}
