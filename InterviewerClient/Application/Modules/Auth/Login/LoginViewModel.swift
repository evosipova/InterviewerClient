import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(completion: @escaping (Bool) -> Void) {
        errorMessage = nil
        isLoading = true
        
        AuthService.shared.login(email: email, password: password)
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
                let token = loginResponse.access_token
                UserDefaults.standard.set(token, forKey: "accessToken")
                UserDefaults.standard.set(loginResponse.token_type, forKey: "tokenType")
                
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            completion(nil)
            return
        }
        
        AuthService.shared.getCurrentUser(token: token)
            .sink { completionResult in
                switch completionResult {
                case .failure(let error):
                    print("Ошибка получения пользователя:", error.localizedDescription)
                    completion(nil)
                case .finished:
                    break
                }
            } receiveValue: { user in
                completion(user)
            }
            .store(in: &cancellables)
    }
}
