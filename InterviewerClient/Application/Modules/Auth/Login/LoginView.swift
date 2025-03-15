import SwiftUI

struct LoginView: View {
    var onBack: () -> Void
    var onNext: () -> Void

    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Авторизация", onBack: onBack)

            VStack(spacing: 15) {
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
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
                viewModel.login { success in
                    if success {
                        onNext()
                    }
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Далее")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onBack: {}, onNext: {})
    }
}
