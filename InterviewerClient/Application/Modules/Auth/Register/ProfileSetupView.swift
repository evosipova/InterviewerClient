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
            Text("Заполните данные о себе")
                .font(.title)
                .bold()
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
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
                Text("Завершить регистрацию")
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

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(onBack: {}, onComplete: {})
    }
}

