import Foundation

struct OpenAIChatMessage: Codable {
    let role: String
    let content: String
}

struct OpenAIRequestBody: Codable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIChatMessage
}

class OpenAIService: ObservableObject {
    @Published var gptResponse: String = ""

    private let apiKey = "8e3eaa7f0e16e02b7a79bc1f74db67d963f239938b1ab86091df024a4bddee5c" 
    private let url = URL(string: "https://api.together.xyz/v1/chat/completions")!

    func sendMessageToGPT(messages: [OpenAIChatMessage]) async throws -> String {
        let body = OpenAIRequestBody(
            model: "mistralai/Mistral-7B-Instruct-v0.1",
            messages: messages
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        if httpResponse?.statusCode != 200 {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        return decodedResponse.choices.first?.message.content ?? "Ошибка: пустой ответ."
    }
}
