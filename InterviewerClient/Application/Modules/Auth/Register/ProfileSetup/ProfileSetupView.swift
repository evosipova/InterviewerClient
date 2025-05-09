import SwiftUI
import PhotosUI
import Combine

struct ProfileSetupView: View {
    @EnvironmentObject var userProfile: UserProfileModel
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onComplete: () -> Void

    @State private var isImagePickerPresented = false
    @State private var fullNameHasError = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Заполните данные", onBack: onBack)

            VStack(alignment: .leading, spacing: 20) {
                VStack {
                    if let image = userProfile.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 2))
                    } else {
                        ZStack {
                            Circle().fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 120)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture {
                    isImagePickerPresented = true
                }

                Text("Как к вам обращаться?")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)

                TextField("ФИО", text: $userProfile.fullName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(fullNameHasError ? Color.red : .clear, lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    )
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)

            if let error = errorMessage {
                HStack {
                    Spacer()
                    Text(error)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                        .lineSpacing(4)
                    Spacer()
                }
            }

            Spacer()

            Button(action: validateAndProceed) {
                HStack {
                    Text("Далее").font(.headline).bold()
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .fullScreenCover(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $userProfile.profileImage)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationBarHidden(true)
    }

    private func validateAndProceed() {
        fullNameHasError = false
        errorMessage = nil

        if userProfile.fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            fullNameHasError = true
            errorMessage = "Пожалуйста, укажите ваше имя.\nЭто обязательное поле."
            return
        }

        onComplete()
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(onBack: {}, onComplete: {})
    }
}
