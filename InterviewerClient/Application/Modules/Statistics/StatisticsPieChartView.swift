import SwiftUI
import Charts

struct StatisticsPieChartView: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
            
            Circle()
                .trim(from: 0.0, to: 0.5) 
                .stroke(Color.blue, lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            Text("Всего тестов\n1")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 150, height: 150)
    }
}

struct StatisticsPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsPieChartView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
