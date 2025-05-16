import SwiftUI

struct TestBlockView: View {
    var title: String
    var subtitle: String
    var color: Color
    var iconName: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 4)
    }
}

struct TestBlockView_Previews: PreviewProvider {
    static var previews: some View {
        TestBlockView(title: "Тесты по темам", subtitle: "Проверьте ваши знания", color: .purple, iconName: "book.fill")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
