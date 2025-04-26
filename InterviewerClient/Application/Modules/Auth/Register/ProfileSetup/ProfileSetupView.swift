import SwiftUI
import PhotosUI

import SwiftUI
import Combine

class UserProfile: ObservableObject {
    static let shared = UserProfile()
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var knowledgeLevel: String = "Junior"

    private init() {}
}

struct ProfileSetupView: View {

    @EnvironmentObject var userProfile: UserProfile
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onComplete: () -> Void

    @State private var isImagePickerPresented = false

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
                            .overlay(
                                Circle().stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            )
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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 30)

            Spacer()

            Button(action: onComplete) {
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
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(onBack: {}, onComplete: {})
    }
}
