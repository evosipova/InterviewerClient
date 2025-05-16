import SwiftUI
import Kingfisher

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    var onLogin: () -> Void
    var onRegister: () -> Void

    let gifURL = "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExbW1hN2dzb25kN3RqMXF3YjV2dTNjc3lvbHUzenZuaWs0OW9kOGJvcCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9cw/s99VUdNNp2kzYJDq4B/giphy.gif"
    
    var body: some View {
        VStack {
            Spacer()
            
            KFAnimatedImage(URL(string: gifURL))
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
                .padding(.bottom, 20)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: onLogin) {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                
                Button(action: onRegister) {
                    Text("Зарегистрироваться")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
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
