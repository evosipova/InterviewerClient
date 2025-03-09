import SwiftUI

struct LoginView: View {
    var onBack: () -> Void
    var onNext: () -> Void
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Авторизация", onBack: onBack)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
                
                SecureField("Пароль", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
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
                .background(Color.black)
                .foregroundColor(.white)
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
