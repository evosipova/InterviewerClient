import SwiftUI

struct TestResultsView: View {
    var correctAnswers: Int
    var totalQuestions: Int

    var body: some View {
        VStack {
            Text("Тест завершен")
                .font(.title)
                .bold()
                .padding(.top, 20)

            Text("\(correctAnswers)/\(totalQuestions) верно")
                .font(.largeTitle)
                .bold()
                .foregroundColor(correctAnswers > 5 ? .green : .red)
                .padding(.top, 10)

            Text(recommendationText)
                .font(.headline)
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal, 20)

            Spacer()

            Button("Посмотреть ответы") {}
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)

            Button("Пройти ещё раз") {}
                .foregroundColor(.blue)
                .padding(.top, 10)
        }
    }

    var recommendationText: String {
        switch correctAnswers {
        case 0...4: return "Вам нужно больше тренироваться."
        case 5...8: return "Есть понимание, но требуется практика."
        default: return "Отличный результат!"
        }
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView(correctAnswers: 1, totalQuestions: 3)
    }
}
