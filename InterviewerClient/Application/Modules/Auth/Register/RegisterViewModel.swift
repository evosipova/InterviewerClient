import SwiftUI
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var name: String = "hard"
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func registerAndLogin(completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        self.errorMessage = nil

        AuthService.shared.register(email: email, name: name, password: password)
            .flatMap { [weak self] _ -> AnyPublisher<LoginResponse, Error> in
                guard let self = self else {
                    return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }

                return AuthService.shared.login(email: self.email, password: self.password)
            }
            .sink { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading = false
                switch completionResult {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] loginResponse in
                guard self != nil else { return }

                UserDefaults.standard.set(loginResponse.access_token, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.token_type, forKey: "tokenType")

                completion(true)
            }
            .store(in: &cancellables)
    }
}
