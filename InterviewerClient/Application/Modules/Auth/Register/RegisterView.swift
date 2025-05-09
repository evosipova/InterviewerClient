import SwiftUI

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onNext: () -> Void

    @EnvironmentObject var userProfile: UserProfileModel

    @State private var errorMessage: String? = nil
    @State private var emailHasError: Bool = false
    @State private var passwordHasError: Bool = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                CustomNavBar(title: "Регистрация", onBack: onBack)

                VStack(spacing: 15) {
                    TextField("Email", text: $userProfile.email)
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
                                    TextField("Пароль", text: $userProfile.password)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Пароль", text: $userProfile.password)
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
                            .lineSpacing(4)
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                        Spacer()
                    }
                }

                Spacer()

                Button(action: {
                    validateAndProceed()
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
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarHidden(true)
    }

    private func validateAndProceed() {
        emailHasError = false
        passwordHasError = false
        errorMessage = nil

        if userProfile.email.trimmingCharacters(in: .whitespaces).isEmpty {
            emailHasError = true
            errorMessage = "Введите email.\nЭто обязательное поле."
            return
        }

        if !isValidEmail(userProfile.email) {
            emailHasError = true
            errorMessage = "Введите корректный email."
            return
        }

        if userProfile.password.isEmpty {
            passwordHasError = true
            errorMessage = "Введите пароль.\nЭто обязательное поле."
            return
        }

        errorMessage = nil
        onNext()
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onBack: {}, onNext: {})
    }
}
