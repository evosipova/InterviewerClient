import SwiftUI

struct TestsView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: TestTopicsView()) {
                            TestBlockView(title: "Тесты по темам", subtitle: "Проверьте ваши знания", color: .purple, iconName: "books.vertical.fill")
                        }
                        NavigationLink(destination: SpeedTestView()) {
                            TestBlockView(title: "Борьба со временем", subtitle: "Ответьте как можно больше", color: .green, iconName: "clock.fill")
                        }
                        NavigationLink(destination: OneMistakeTestView()) {
                            TestBlockView(title: "Одна ошибка", subtitle: "И ты ошибся", color: .orange, iconName: "exclamationmark.triangle.fill")
                        }
                        NavigationLink(destination: AITestView()) {
                            TestBlockView(title: "Тест от ИИ", subtitle: "Новый опыт с GPT", color: .blue, iconName: "brain.head.profile")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                Spacer()
            }
            .navigationBarTitle("Тесты", displayMode: .large)
        }
    }
}

struct TestsView_Previews: PreviewProvider {
    static var previews: some View {
        TestsView()
    }
}
