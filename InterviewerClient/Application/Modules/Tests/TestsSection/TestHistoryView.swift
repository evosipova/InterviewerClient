import SwiftUI

struct TestHistoryView: View {
    let history: [TestHistoryAnswer]
    let correctAnswers: Int
    let incorrectAnswers: Int
    let topic: String
    let timeTaken: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(topic)
                            .font(.title2)
                            .bold()

                        ZStack(alignment: .leading) {
                            ProgressView(value: 1.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                .opacity(0.3)

                            ProgressView(value: Double(correctAnswers) / Double(correctAnswers + incorrectAnswers))
                                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        }
                        .padding(.vertical, 5)

                        Text("\(correctAnswers) Правильно • \(incorrectAnswers) Неправильно")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Время прохождения: \(timeTaken)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(12)

                    ForEach(history.indices, id: \.self) { index in
                        let entry = history[index]
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Вопрос \(index + 1)")
                                .font(.headline)
                                .bold()

                            Text(entry.question)
                                .font(.body)

                            Text("Ваш ответ")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(entry.userAnswer == entry.correctAnswer ? .green : .red)

                            Text(entry.userAnswer)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(entry.userAnswer == entry.correctAnswer ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                .cornerRadius(8)

                            Text("Правильный ответ")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.green)

                            Text(entry.correctAnswer)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)

                            Text("Объяснение")
                                .font(.subheadline)
                                .bold()

                            Text(entry.explanation)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationBarTitle("История ответов", displayMode: .inline)
        }
    }
}
