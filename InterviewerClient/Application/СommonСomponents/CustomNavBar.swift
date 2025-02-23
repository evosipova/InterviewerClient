import SwiftUI

struct CustomNavBar: View {
    var title: String
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
            Text(title)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                if let onBack = onBack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 20)
                }
                Spacer()
            }
        }
        .frame(height: 44)
    }
}

struct CustomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBar(title: "Профиль", onBack: {})
            Spacer()
        }
    }
}
