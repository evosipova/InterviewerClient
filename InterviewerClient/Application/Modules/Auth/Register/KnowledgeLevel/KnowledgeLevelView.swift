import SwiftUI

struct KnowledgeLevelView: View {
    @EnvironmentObject var userProfile: UserProfileModel
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var onBack: () -> Void
    var onNext: () -> Void

    let levels = ["Junior", "Middle", "Senior"]

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Выберите уровень", onBack: onBack)

            VStack(spacing: 15) {
                ForEach(levels, id: \.self) { level in
                    HStack {
                        Text(level)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Circle()
                            .fill(userProfile.knowledgeLevel == level ? Color.green.opacity(0.8) : Color.gray.opacity(0.2))
                            .frame(width: 30, height: 30)
                            .overlay(
                                userProfile.knowledgeLevel == level ? Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold)) : nil
                            )
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .onTapGesture {
                        userProfile.knowledgeLevel = level
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                Task {
                    isLoading = true
                    errorMessage = nil

                    let profile = userProfile
                    let email = profile.email
                    let password = profile.password
                    let name = profile.fullName

                    do {
                        try await AuthService.shared.register(email: email, password: password, name: name)
                        let token = try await AuthService.shared.login(email: email, password: password)
                        TokenStorage.shared.token = token
                        onNext()
                    } catch {
                        errorMessage = "Ошибка: \(error.localizedDescription)"
                    }

                    isLoading = false
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Далее").font(.headline).bold()
                        Image(systemName: "arrow.right")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal, 20)
            }

        }
        .navigationBarHidden(true)
    }
}

struct KnowledgeLevelView_Previews: PreviewProvider {
    static var previews: some View {
        KnowledgeLevelView(onBack: {}, onNext: {})
    }
}
