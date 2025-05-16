import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let access_token: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

class AuthService {
    static let shared = AuthService()

    private let loginURL = URL(string: "https://confusedly-free-bloodhound.cloudpub.ru/auth/login")!

    func login(email: String, password: String) async throws -> String {
        let body = LoginRequest(email: email, password: password)

        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        guard httpResponse?.statusCode == 200 else {
            throw URLError(.userAuthenticationRequired)
        }

        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
        return decoded.access_token
    }


    func register(email: String, password: String, name: String) async throws {
        let body = RegisterRequest(email: email, password: password, name: name)
        var request = URLRequest(url: URL(string: "https://confusedly-free-bloodhound.cloudpub.ru/auth/register")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (_, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

class TokenStorage {
    static let shared = TokenStorage()

    private let key = "access_token"

    var token: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
