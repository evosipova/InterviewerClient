import SwiftUI

struct OneMistakeTestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    @State private var showResults = false
    @State private var history: [(question: String, userAnswer: String, correctAnswer: String, explanation: String)] = []
    
    @State private var timeRemaining = 3600
    @State private var timerActive = true
    @State private var timeTaken = ""
    @State private var showHistorySheet = false

    @State private var selectedEntry: TestHistoryEntry? = nil
    @State private var lastEntry: TestHistoryEntry? = nil

    let questions: [Question]

    init() {
        self.questions = QuestionLoader.loadAllQuestions().shuffled()
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()

                    Text("Одна ошибка")
                        .font(.headline)
                        .bold()

                    Spacer()
                }
                .frame(height: 44)
                .padding(.top, 10)

                VStack(spacing: 5) {
                    HStack {
                        Text("Вопрос \(currentQuestionIndex + 1)")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                        
                        Text("\(timeFormatted(timeRemaining))")
                            .font(.headline)
                            .bold()
                            .foregroundColor(timeRemaining > 60 ? .green : .red)
                    }
                    .padding(.horizontal)

                    ProgressView(value: Double(timeRemaining) / 3600)
                        .progressViewStyle(LinearProgressViewStyle(tint: timeRemaining > 60 ? .green : .red))
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        if currentQuestionIndex < questions.count {
                            Text(questions[currentQuestionIndex].questionText)
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)

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
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .onAppear {
                startTimer()
            }
            .navigationDestination(isPresented: $showResults) {
                TestResultsView(
                    correctAnswers: correctAnswers,
                    incorrectAnswers: 1,
                    timeTaken: timeTaken,
                    onRestart: restartTest,
                    onContinue: goToTestsView,
                    onViewHistory: {
                        if let entry = lastEntry {
                            selectedEntry = entry
                        }
                    }
                )
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
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }

    private func handleAnswerSelection(_ answer: Answer) {
        selectedAnswer = answer.text
        
        let question = questions[currentQuestionIndex]
        if let correctAnswer = question.answers.first(where: { $0.isCorrect })?.text {
            history.append((question.questionText, answer.text, correctAnswer, question.explanation))
        }

        if answer.isCorrect {
            correctAnswers += 1
            nextQuestion()
        } else {
            completeTest()
        }
    }

    private func nextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswer = nil
            }
        }
    }

    private func startTimer() {
        timerActive = true
        timeRemaining = 3600
        DispatchQueue.global(qos: .background).async {
            while self.timerActive && self.timeRemaining > 0 {
                sleep(1)
                DispatchQueue.main.async {
                    self.timeRemaining -= 1
                    if self.timeRemaining == 0 {
                        self.completeTest()
                    }
                }
            }
        }
    }

    private func completeTest() {
        guard !showResults else { return }
        timerActive = false
        timeTaken = timeFormatted(3600 - timeRemaining)
        showResults = true

        let durationInSeconds = 3600 - timeRemaining
        let session = TestSession(
            correctAnswers: correctAnswers,
            incorrectAnswers: incorrectAnswers,
            duration: durationInSeconds
        )
        TestStatisticsStorage.shared.saveSession(session)

        let structuredAnswers = history.map {
            TestHistoryAnswer(
                question: $0.question,
                userAnswer: $0.userAnswer,
                correctAnswer: $0.correctAnswer,
                explanation: $0.explanation
            )
        }
        let entry = TestHistoryEntry(
            topic: "Одна ошибка",
            answers: structuredAnswers,
            correctAnswers: correctAnswers,
            incorrectAnswers: incorrectAnswers,
            timeTaken: timeTaken
        )
        lastEntry = entry
        TestHistoryStorage.shared.save(entry: entry)
    }

    private func restartTest() {
        currentQuestionIndex = 0
        correctAnswers = 0
        selectedAnswer = nil
        history.removeAll()
        showResults = false
        timeRemaining = 3600
        startTimer()
    }

    private func goToTestsView() {
        presentationMode.wrappedValue.dismiss()
    }

    private func timeFormatted(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
