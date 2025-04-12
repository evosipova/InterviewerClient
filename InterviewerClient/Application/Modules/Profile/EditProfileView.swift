import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var fullName: String
    @Binding var knowledgeLevel: String
    @Binding var profileImage: UIImage?

    let knowledgeLevels = ["Junior", "Middle", "Senior"]

    @State private var tempFullName: String
    @State private var tempKnowledgeLevel: String
    @State private var tempImage: UIImage?
    @State private var isImagePickerPresented = false

    init(fullName: Binding<String>, knowledgeLevel: Binding<String>, profileImage: Binding<UIImage?>) {
        _fullName = fullName
        _knowledgeLevel = knowledgeLevel
        _profileImage = profileImage
        _tempFullName = State(initialValue: fullName.wrappedValue)
        _tempKnowledgeLevel = State(initialValue: knowledgeLevel.wrappedValue)
        _tempImage = State(initialValue: profileImage.wrappedValue)
    }

    var body: some View {
        VStack {
            ZStack {
                Text("Редактирование профиля")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 20)

                    Spacer()

                    Button(action: {
                        fullName = tempFullName
                        knowledgeLevel = tempKnowledgeLevel
                        profileImage = tempImage
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                            .background(Color.primary.opacity(0.1))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .padding(.trailing, 20)
                }
            }
            .frame(height: 44)
            .padding(.top, 10)

            ScrollView {
                VStack(spacing: 15) {
                    Button(action: {
                        DispatchQueue.main.async {
                            isImagePickerPresented.toggle()
                        }
                    }) {
                        if let image = tempImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom, 15)
                    .fullScreenCover(isPresented: $isImagePickerPresented) {
                        ImagePicker(image: $tempImage)
                    }

                    TextField("ФИО", text: $tempFullName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2)))
                        .padding(.horizontal, 20)

                    Picker("Уровень знаний", selection: $tempKnowledgeLevel) {
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
            fullName: .constant("Лиза"),
            knowledgeLevel: .constant("Middle"),
            profileImage: .constant(nil)
        )
    }
}
