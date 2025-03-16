import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        StatisticBlockView(title: "Таблица лидеров", subtitle: "Доберитесь до вершины", iconName: "trophy.fill")
                        StatisticBlockView(title: "Показать ранг", subtitle: "Проходите больше тестов", iconName: "triangle.fill")
                        
                        Text("Ваши знания растут")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                        
                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: "2", description: "Правильных ответов", iconName: "checkmark.circle.fill")
                            StatisticSmallBlockView(value: "1", description: "Неправильны отвтеов", iconName: "multiply.circle.fill")
                        }
                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: "01:08", description: "Общее время обучения", iconName: "clock.fill")
                            StatisticSmallBlockView(value: "1", description: "Всего тестов", iconName: "doc.fill")
                        }
                        
                        StatisticsPieChartView()
                            .frame(height: 200)
                            .padding(.top, 20)
                        
                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: "01:08", description: "Самый долгий тест", iconName: "tortoise.fill")
                            StatisticSmallBlockView(value: "00:15", description: "Самый быстрый тест", iconName: "hare.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .navigationBarTitle("Статистика", displayMode: .large)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
