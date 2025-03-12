import SwiftUI

struct RegisterView: View {
    var onBack: () -> Void
    var onNext: () -> Void

    @ObservedObject var viewModel = RegisterViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Регистрация", onBack: onBack)

            VStack(spacing: 15) {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)

                TextField("Имя", text: $viewModel.name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)

                SecureField("Пароль", text: $viewModel.password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 30)

            Spacer()

            Button(action: {
                viewModel.registerAndLogin { success in
                    if success {
                        // Если и регистрация, и логин прошли успешно
                        onNext()
                    }
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Далее")
                            .font(.headline)
                            .bold()
                        Image(systemName: "arrow.right")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(viewModel.isLoading)
        }
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onBack: {}, onNext: {})
    }
}
