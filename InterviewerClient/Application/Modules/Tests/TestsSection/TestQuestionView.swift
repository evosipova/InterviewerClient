import SwiftUI

struct TestQuestionView: View {
    let topic: String
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    @State private var showResults = false
    @State private var history: [(question: String, userAnswer: String, correctAnswer: String, explanation: String)] = []
    
    let questions: [Question]
    
    init(topic: String) {
        self.topic = topic
        self.questions = QuestionLoader.loadQuestions(for: topic)
    }
    
    var body: some View {
        if showResults {
            TestResultsView(
                correctAnswers: correctAnswers,
                incorrectAnswers: incorrectAnswers,
                onRestart: restartTest,
                onContinue: goToTestsView,
                onViewHistory: showHistory
            )
        } else {
            VStack {
                ZStack {
                    Text(topic)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Button(action: { showExitAlert() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                }
                .frame(height: 44)
                .padding(.top, 10)
                
                VStack {
                    if currentQuestionIndex < questions.count {
                        Text(questions[currentQuestionIndex].questionText)
                            .font(.title3)
                            .padding()
                        
                        VStack(spacing: 10) {
                            ForEach(questions[currentQuestionIndex].answers, id: \.text) { answer in
                                Button(action: {
                                    handleAnswerSelection(answer)
                                }) {
                                    Text(answer.text)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedAnswer == answer.text
                                                    ? (answer.isCorrect ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                                                    : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    } else {
                        Spacer()
                        Text("Нет доступных вопросов.")
                            .foregroundColor(.gray)
                            .font(.title2)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func handleAnswerSelection(_ answer: Answer) {
        selectedAnswer = answer.text
        
        let question = questions[currentQuestionIndex]
        history.append((question.questionText, answer.text, question.correctAnswer, question.explanation))
        if answer.isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswer = nil
            } else {
                showResults = true
            }
        }
    }
    
    private func restartTest() {
        currentQuestionIndex = 0
        correctAnswers = 0
        incorrectAnswers = 0
        selectedAnswer = nil
        history.removeAll()
        showResults = false
    }
    
    private func goToTestsView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func showHistory() {
        print("Открываем историю ответов") 
    }
    
    private func showExitAlert() {
        let alert = UIAlertController(title: "Внимание",
                                      message: "Вы уверены, что хотите выйти? Прогресс будет потерян.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да, выйти", style: .destructive) { _ in
            presentationMode.wrappedValue.dismiss()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}
