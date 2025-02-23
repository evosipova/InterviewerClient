import SwiftUI

struct StatisticBlockView: View {
    var title: String
    var subtitle: String
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
                .frame(width: 30, height: 30)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
    }
}

struct StatisticBlockView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticBlockView(title: "Таблица лидеров", subtitle: "Доберитесь до вершины", iconName: "trophy.fill")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
