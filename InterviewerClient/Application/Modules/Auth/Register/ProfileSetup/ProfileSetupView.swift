import SwiftUI
import PhotosUI

struct ProfileSetupView: View {
    var onBack: () -> Void
    var onComplete: () -> Void
    
    @State private var fullName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Заполните данные", onBack: onBack)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            )
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Как к вам обращаться?")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                
                TextField("ФИО", text: $fullName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
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
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .navigationBarHidden(true)
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView(onBack: {}, onComplete: {})
    }
}
