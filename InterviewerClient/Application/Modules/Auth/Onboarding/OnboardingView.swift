import SwiftUI

struct OnboardingView: View {
    var onLogin: () -> Void
    var onRegister: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.black)
                .padding(.bottom, 20)

            Text("Привет!")
                .font(.title)
                .bold()
                .padding(.bottom, 30)

            Spacer()

            VStack(spacing: 15) {
                Button(action: onLogin) {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }

                Button(action: onRegister) {
                    Text("Зарегистрироваться")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onLogin: {}, onRegister: {})
    }
}
