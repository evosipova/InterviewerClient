import SwiftUI

struct TestHistoryViewProfile: View {
    @State private var entries: [TestHistoryEntry] = []
    @State private var selectedEntry: TestHistoryEntry?

    var body: some View {
        NavigationView {
            Group {
                if entries.isEmpty {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "doc.plaintext")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Пока здесь пусто.\n Проверьте себя в первом тесте!")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(entries) { entry in
                                Button(action: {
                                    selectedEntry = entry
                                }) {
                                    TestHistoryCard(
                                        title: entry.topic,
                                        correct: entry.correctAnswers,
                                        incorrect: entry.incorrectAnswers,
                                        time: entry.timeTaken
                                    )
                                }
                                .sheet(item: $selectedEntry) { item in
                                    TestHistoryView(
                                        history: item.answers,
                                        correctAnswers: item.correctAnswers,
                                        incorrectAnswers: item.incorrectAnswers,
                                        topic: item.topic,
                                        timeTaken: item.timeTaken
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("История тестов")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    TestHistoryStorage.shared.clear()
                    entries = []
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            )
            .onAppear {
                entries = TestHistoryStorage.shared.load()
            }
        }
    }
}
