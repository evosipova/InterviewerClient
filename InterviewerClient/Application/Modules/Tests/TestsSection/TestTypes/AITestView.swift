import SwiftUI

struct AITestView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    @State private var showResults = false
    @State private var history: [(question: String, userAnswer: String, correctAnswer: String, explanation: String)] = []

    @State private var selectedEntry: TestHistoryEntry? = nil
    @State private var lastEntry: TestHistoryEntry? = nil
    @State private var isAnswerSelected = false

    @State private var timeRemaining = 300
    @State private var timerActive = true
    @State private var timeTaken = ""

    @State private var questions: [Question] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack {
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .opacity(0.8)

                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5)

                        Text("Готовим вопросы с помощью ИИ…")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            } else if let errorMessage = errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Button("Повторить") {
                        loadQuestions()
                    }
                }
                .navigationBarHidden(true)
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 20)

                        Spacer()

                        Text("Тест от ИИ")
                            .font(.headline)
                            .bold()

                        Spacer()
                    }
                    .frame(height: 44)
                    .padding(.top, 10)

                    VStack(spacing: 5) {
                        HStack {
                            Text("Вопрос \(currentQuestionIndex + 1) из \(questions.count)")
                                .font(.headline)
                                .bold()

                            Spacer()

                            Text(timeFormatted(timeRemaining))
                                .font(.headline)
                                .bold()
                                .foregroundColor(timeRemaining > 60 ? .green : .red)
                        }
                        .padding(.horizontal)

                        ProgressView(value: Double(timeRemaining) / 300)
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
                                .padding(.horizontal, 10)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                .navigationDestination(isPresented: $showResults) {
                    TestResultsView(
                        correctAnswers: correctAnswers,
                        incorrectAnswers: incorrectAnswers,
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
                            topic: "Тест от ИИ",
                            timeTaken: item.timeTaken
                        )
                    }
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            loadQuestions()
        }
        .navigationBarHidden(true)
    }

    private func loadQuestions() {
        Task {
            isLoading = true
            do {
                let fetchedQuestions = try await QuestionService.shared.fetchAIQuestions()
                questions = Array(fetchedQuestions.prefix(10))
            } catch {
                questions = Array(QuestionLoader.loadAllQuestions().shuffled().prefix(10))
            }
            isLoading = false
            startTimer()
        }
    }

    private func handleAnswerSelection(_ answer: Answer) {
        guard !isAnswerSelected else { return }
        isAnswerSelected = true
        selectedAnswer = answer.text

        let question = questions[currentQuestionIndex]
        if let correctAnswer = question.answers.first(where: { $0.isCorrect })?.text {
            history.append((question.questionText, answer.text, correctAnswer, question.explanation))
        }

        if answer.isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if currentQuestionIndex < questions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswer = nil
                isAnswerSelected = false
            } else {
                completeTest()
            }
        }
    }

    private func startTimer() {
        timerActive = true
        timeRemaining = 300
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
        timeTaken = timeFormatted(300 - timeRemaining)
        showResults = true

        let durationInSeconds = 300 - timeRemaining
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
            topic: "Тест от ИИ",
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
        incorrectAnswers = 0
        selectedAnswer = nil
        history.removeAll()
        showResults = false
        timeRemaining = 300
        isAnswerSelected = false
        loadQuestions()
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
