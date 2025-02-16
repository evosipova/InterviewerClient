import SwiftUI

struct LoginView: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("С возвращением! 👋")
                .font(.title)
                .bold()
                .padding(.leading, 20)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text("Введите свои учетные данные, чтобы войти в систему.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 15) {
                TextField("Email", text: .constant(""))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
                
                SecureField("Пароль", text: .constant(""))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            Button("Войти") { }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onBack: {})
    }
}
