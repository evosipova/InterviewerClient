import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onNext: () -> Void

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Авторизация", onBack: onBack)

            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)

                SecureField("Пароль", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)

            Spacer()

            Button(action: {
                Task {
                    do {
                        let token = try await AuthService.shared.login(email: email, password: password)
                        TokenStorage.shared.token = token
                        errorMessage = nil
                        onNext()
                    } catch {
                        errorMessage = "Ошибка авторизации. Проверьте email и пароль."
                        print("Ошибка входа: \(error)")
                    }
                }
            }) {
                HStack {
                    Text("Далее")
                        .font(.headline)
                        .bold()
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)

        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onBack: {}, onNext: {})
    }
}

