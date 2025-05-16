import Foundation

enum AssistantType: String, CaseIterable, Codable {
    case hr
    case technical
    case algorithms
}

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

    func sendMessageToGPT(answer: String, assistantRole: ChatView.AssistantType) async throws -> String {
        let url = mapToBackendURL(for: assistantRole)
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

    private func mapToBackendURL(for role: ChatView.AssistantType) -> URL {
        switch role {
        case .hr:
            return URL(string: "https://truculently-neat-roach.cloudpub.ru/ai/hr-interview?max_history=15")!
        case .technical:
            return URL(string: "https://truculently-neat-roach.cloudpub.ru/ai/tech-interview?max_history=15")!
        case .algorithms:
            return URL(string: "https://truculently-neat-roach.cloudpub.ru/ai/interview?max_history=15")!
        }
    }
}
