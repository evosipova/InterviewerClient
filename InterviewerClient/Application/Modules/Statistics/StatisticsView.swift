import SwiftUI

struct StatisticsView: View {
    @State private var sessions: [TestSession] = []
    @State private var showLeaderboard = false
    @ObservedObject var userProfile = UserProfile.shared

    var totalCorrect: Int {
        sessions.reduce(0) { $0 + $1.correctAnswers }
    }
    var totalIncorrect: Int {
        sessions.reduce(0) { $0 + $1.incorrectAnswers }
    }
    var totalTime: Int {
        sessions.reduce(0) { $0 + $1.duration }
    }
    var totalTests: Int {
        sessions.count
    }
    var longestTest: Int {
        sessions.map { $0.duration }.max() ?? 0
    }
    var shortestTest: Int {
        sessions.map { $0.duration }.min() ?? 0
    }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Button(action: {
                            showLeaderboard.toggle()
                        }) {
                            StatisticBlockView(title: "Таблица лидеров", subtitle: "Доберитесь до вершины", iconName: "trophy.fill")
                        }
                        .sheet(isPresented: $showLeaderboard) {
                            LeaderBoardView(
                                currentUserName: userProfile.fullName,
                                correctAnswers: totalCorrect,
                                totalTime: totalTime
                            )
                        }


                        Text("Ваши знания растут")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)

                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: "\(totalCorrect)", description: "Правильных ответов", iconName: "checkmark.circle.fill")
                            StatisticSmallBlockView(value: "\(totalIncorrect)", description: "Неправильных ответов", iconName: "multiply.circle.fill")
                        }
                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: formatTime(totalTime), description: "Общее время обучения", iconName: "clock.fill")
                            StatisticSmallBlockView(value: "\(totalTests)", description: "Всего тестов", iconName: "doc.fill")
                        }

                        HStack(spacing: 15) {
                            StatisticSmallBlockView(value: formatTime(longestTest), description: "Самый долгий тест", iconName: "tortoise.fill")
                            StatisticSmallBlockView(value: formatTime(shortestTest), description: "Самый быстрый тест", iconName: "hare.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }

                Spacer()
            }
            .navigationBarTitle("Статистика", displayMode: .large)
            .onAppear {
                sessions = TestStatisticsStorage.shared.loadAllSessions()
            }
        }
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
