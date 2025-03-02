import SwiftUICore

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
