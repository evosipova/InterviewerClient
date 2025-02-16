import SwiftUI

struct RegisterView: View {
    var onBack: () -> Void
    var onNext: () -> Void
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Добро пожаловать! 👋")
                .font(.title)
                .bold()
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Введите ваш email и пароль для регистрации.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                Text("Далее")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onBack: {}, onNext: {})
    }
}
