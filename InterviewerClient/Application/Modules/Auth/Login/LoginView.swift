import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onNext: () -> Void

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var errorMessage: String? = nil

    @State private var emailHasError: Bool = false
    @State private var passwordHasError: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Авторизация", onBack: onBack)

            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(emailHasError ? Color.red : .clear, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    )
                    .padding(.horizontal, 20)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(passwordHasError ? Color.red : .clear, lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))

                    HStack {
                        Group {
                            if isPasswordVisible {
                                TextField("Пароль", text: $password)
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Пароль", text: $password)
                            }
                        }
                        .textContentType(.password)
                        .padding(.leading, 16)
                        .padding(.vertical, 12)

                        Spacer()

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isPasswordVisible.toggle()
                            }
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                                .contentShape(Rectangle())
                        }
                        .padding(.trailing, 16)
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)

            if let error = errorMessage {
                HStack {
                    Spacer()
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                        .lineSpacing(4)
                    Spacer()
                }
                .transition(.opacity)
            }

            Spacer()

            Button(action: {
                validateAndLogin()
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
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarHidden(true)
    }

    private func validateAndLogin() {
        emailHasError = false
        passwordHasError = false
        errorMessage = nil

        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emailHasError = true
            errorMessage = "Пожалуйста, введите email."
            return
        }

        if !isValidEmail(email) {
            emailHasError = true
            errorMessage = "Пожалуйста, введите корректный email."
            return
        }

        if password.isEmpty {
            passwordHasError = true
            errorMessage = "Пожалуйста, введите пароль."
            return
        }

        Task {
            do {
                let token = try await AuthService.shared.login(email: email, password: password)
                TokenStorage.shared.token = token
                errorMessage = nil
                onNext()
            } catch {
                withAnimation {
                    errorMessage = "Ошибка авторизации.\nПроверьте email и пароль."
                }
                print("Ошибка входа: \(error)")
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onBack: {}, onNext: {})
    }
}
