import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var fullName: String
    @Binding var birthdate: Date
    @Binding var selectedGender: String
    @Binding var knowledgeLevel: String

    let genders = ["Мужской", "Женский", "Не указывать"]
    let knowledgeLevels = ["Новичок", "Средний", "Продвинутый"]

    var body: some View {
        VStack {
            ZStack {
                Text("Редактирование профиля")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                            .background(Color.black.opacity(0.1))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 20)
                }
            }
            .frame(height: 44)
            .padding(.top, 10)

            ScrollView {
                VStack(spacing: 15) {
                    TextField("ФИО", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 20)

                    Picker("Пол", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)

                    DatePicker("Дата рождения", selection: $birthdate, displayedComponents: .date)
                        .padding(.horizontal, 20)

                    Picker("Уровень знаний", selection: $knowledgeLevel) {
                        ForEach(knowledgeLevels, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }

            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(
            fullName: .constant("annaliza2011"),
            birthdate: .constant(Date()),
            selectedGender: .constant("Не указывать"),
            knowledgeLevel: .constant("Средний")
        )
    }
}
