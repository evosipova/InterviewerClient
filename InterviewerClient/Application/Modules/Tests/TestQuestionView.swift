import SwiftUI

struct TestQuestionView: View {
    var topic: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var timerValue = 300 // 5 минут
    @State private var selectedAnswer: String? = nil
    @State private var showExitAlert = false
    
    var body: some View {
        VStack {
            ZStack {
                Text(topic)
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: { showExitAlert = true }) {
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
                Text("Как называется переменная, значение которой нельзя изменить?")
                    .font(.title3)
                    .padding()

                VStack(spacing: 10) {
                    ForEach(["let", "var", "const", "final"], id: \.self) { answer in
                        Button(action: { selectedAnswer = answer }) {
                            Text(answer)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedAnswer == answer
                                            ? (answer == "let" ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                                            : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .alert(isPresented: $showExitAlert) {
            Alert(
                title: Text("Внимание"),
                message: Text("Вы уверены, что хотите выйти? Прогресс будет потерян."),
                primaryButton: .destructive(Text("Да, выйти"), action: {
  
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        NotificationCenter.default.post(name: .navigateToTestsView, object: nil)
                    }
                }),
                secondaryButton: .cancel(Text("Отмена"))
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timerValue > 0 {
                    timerValue -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}

extension Notification.Name {
    static let navigateToTestsView = Notification.Name("navigateToTestsView")
}

struct TestQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        TestQuestionView(topic: "Основы Swift")
    }
}
