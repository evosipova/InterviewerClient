import SwiftUI

struct RegisterView: View {
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onNext: () -> Void

    @EnvironmentObject var userProfile: UserProfile

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Регистрация", onBack: onBack)

            VStack(spacing: 15) {
                TextField("Email", text: $userProfile.email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)

                SecureField("Пароль", text: $userProfile.password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)

            Spacer()

            Button(action: onNext) {
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
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onBack: {}, onNext: {})
    }
}
