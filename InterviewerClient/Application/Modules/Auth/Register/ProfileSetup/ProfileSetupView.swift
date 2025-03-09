import SwiftUI

struct ProfileSetupView: View {
    var onBack: () -> Void
    var onComplete: () -> Void
    
    @State private var fullName: String = ""
    @State private var birthdate = Date()
    @State private var selectedGender = "Мужской"
    let genders = ["Мужской", "Женский", "Другой"]
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Заполните данные", onBack: onBack)
            
            VStack(spacing: 15) {
                TextField("ФИО", text: $fullName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("Дата рождения")
                        .font(.title3)
                    Spacer()
                    DatePicker("", selection: $birthdate, displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal, 20)
                
                Picker("Выберите пол", selection: $selectedGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)
            
            Spacer()
            
            Button(action: onComplete) {
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

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(onBack: {}, onComplete: {})
    }
}
