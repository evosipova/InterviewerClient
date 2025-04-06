import SwiftUI

struct TestHistoryCard: View {
    var title: String
    var correct: Int
    var incorrect: Int
    var time: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            HStack {
                Label("\(correct) Правильно", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Label("\(incorrect) Неправильно", systemImage: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .font(.subheadline)

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text("Время: \(time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            TestHistoryCard(title: "Основы Swift", correct: 7, incorrect: 3, time: "02:45")
            TestHistoryCard(title: "Алгоритмы", correct: 5, incorrect: 5, time: "03:20")
        }
        .padding(.horizontal, 16)
    }
}
