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

        // 1) Сначала регистрируемся
        AuthService.shared.register(email: email, name: name, password: password)
        // 2) Если регистрация успехна, "подцепляем" login
            .flatMap { [weak self] _ -> AnyPublisher<LoginResponse, Error> in
                guard let self = self else {
                    // Если self уже нет, вернём пустой Fail
                    return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
                // Теперь вызываем /auth/login
                return AuthService.shared.login(email: self.email, password: self.password)
            }
        // 3) Подписываемся на поток
            .sink { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading = false
                switch completionResult {
                case .failure(let error):
                    // Если на каком-то этапе ошибка (регистрация или логин), покажем её
                    self.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] loginResponse in
                // Сюда мы попадаем ТОЛЬКО если и register, и login прошли без ошибок
                guard let self = self else { return }

                // Сохраним токен (или в Keychain)
                UserDefaults.standard.set(loginResponse.access_token, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.token_type, forKey: "tokenType")

                // Считаем успех
                completion(true)
            }
            .store(in: &cancellables)
    }
}
