import SwiftUI

struct StatisticSmallBlockView: View {
    var value: String
    var description: String
    var iconName: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            Text(value)
                .font(.title)
                .bold()
                .foregroundColor(.white)

            Text(description)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150) 
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }
}

struct StatisticSmallBlockView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 15) {
            StatisticSmallBlockView(value: "01:08", description: "Самый долгий тест", iconName: "tortoise.fill")
            StatisticSmallBlockView(value: "00:15", description: "Самый быстрый тест", iconName: "hare.fill")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
