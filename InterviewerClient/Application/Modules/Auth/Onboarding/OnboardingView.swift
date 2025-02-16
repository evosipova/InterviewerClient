import SwiftUI

struct OnboardingView: View {
    var onLogin: () -> Void
    var onRegister: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.black)
            
            Text("Привет!")
                .font(.title)
                .bold()
            
            VStack {
                Button(action: onLogin) {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal, 20)
                
                Button(action: onRegister) {
                    Text("Регистрация")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onLogin: {}, onRegister: {})
    }
}

