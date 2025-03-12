import Foundation
import Combine

class AuthService {
    static let shared = AuthService()
    private init() {}

    func login(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        guard let url = URL(string: "https://specially-hygienic-curlew.cloudpub.ru/auth/login") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getCurrentUser(token: String) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "https://specially-hygienic-curlew.cloudpub.ru/users/me") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func register(email: String, name: String, password: String) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "https://specially-hygienic-curlew.cloudpub.ru/auth/register") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let body: [String: Any] = [
            "email": email,
            "name": name,
            "password": password
        ]

        guard let data = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
