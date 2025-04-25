import SwiftUI

struct LeaderBoardView: View {
    @State private var sortByTime = false

    let currentUserName: String
    let correctAnswers: Int
    let totalTime: Int

    var body: some View {
        let userStats = [
            UserStatsModel(name: currentUserName, correctAnswers: correctAnswers, totalTime: totalTime)
        ]

        let sortedStats = sortByTime ?
        userStats.sorted { $0.totalTime > $1.totalTime } :
        userStats.sorted { $0.correctAnswers > $1.correctAnswers }

        NavigationView {
            ScrollView {
                VStack {
                    Picker("Сортировка", selection: $sortByTime) {
                        Text("По ответам").tag(false)
                        Text("По времени").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sortedStats.indices, id: \.self) { index in
                                LeaderBoardRow(
                                    index: index,
                                    user: sortedStats[index],
                                    sortByTime: sortByTime
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Таблица лидеров")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LeaderBoardView(
        currentUserName: "Лиза",
        correctAnswers: 80,
        totalTime: 7200
    )
}
