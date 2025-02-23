import SwiftUI

struct TestHistoryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("История тестов")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding()

            ScrollView {
                VStack {
                    TestHistoryCard(title: "Код", correct: 2, incorrect: 3, time: "01:08")
                }
            }
        }
        .padding()
    }
}

struct TestHistoryCard: View {
    var title: String
    var correct: Int
    var incorrect: Int
    var time: String

    var body: some View {
        VStack {
            Text(title)
            Text("\(correct) Правильно • \(incorrect) Неправильно")
            Text("Время: \(time)")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
