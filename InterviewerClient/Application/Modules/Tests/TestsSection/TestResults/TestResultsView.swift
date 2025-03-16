import SwiftUICore
import SwiftUI

struct TestResultsView: View {
    let correctAnswers: Int
    let incorrectAnswers: Int
    let timeTaken: String
    let onRestart: () -> Void
    let onContinue: () -> Void
    let onViewHistory: () -> Void
    
    private var totalQuestions: Int {
        correctAnswers + incorrectAnswers
    }
    
    private var accuracy: Double {
        totalQuestions > 0 ? (Double(correctAnswers) / Double(totalQuestions)) * 100 : 0
    }
    
    private var progressColor: Color {
        switch accuracy {
        case 80...100:
            return .green
        case 50..<80:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("Тест завершён")
                    .font(.title)
                    .bold()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(accuracy / 100))
                        .stroke(
                            progressColor,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(String(format: "%.1f", accuracy))%")
                        .font(.title)
                        .bold()
                }
                .frame(width: 150, height: 150)
                
                Text("Время прохождения: \(timeTaken)")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Text(accuracy > 70 ? "Отличный результат! 🎉" : "Не помешает ещё немного практики!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(progressColor.opacity(0.2))
                    .foregroundColor(progressColor)
                    .cornerRadius(10)
                
                
                HStack(spacing: 20) {
                    ResultBlockView(title: "Правильных", value: "\(correctAnswers)")
                    ResultBlockView(title: "Ошибок", value: "\(incorrectAnswers)")
                }
                
                VStack(spacing: 20) {
                    HStack {
                        Button(action: onViewHistory) {
                            Image(systemName: "doc.text")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                        
                        Button(action: onContinue) {
                            Text("Продолжить")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    
                    Button(action: onRestart) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Пройти ещё раз")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView(
            correctAnswers: 8,
            incorrectAnswers: 2,
            timeTaken: "04:30",
            onRestart: {},
            onContinue: {},
            onViewHistory: {}
        )
    }
}
