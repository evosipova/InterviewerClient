import SwiftUI

struct TestTopicsView: View {
    @Environment(\.presentationMode) var presentationMode

    let topics = [
        "Основы Swift",
        "Многопоточность",
        "Память",
        "Алгоритмы",
        "Архитектуры",
        "Код",
        "Swift Concurrency"
    ]

    var body: some View {
        VStack {
            ZStack {
                Text("Тесты по темам")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
            }
            .frame(height: 44)
            .padding(.top, 10)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(topics, id: \.self) { topic in
                        NavigationLink(destination: TestQuestionView(topic: topic)) {
                            HStack {
                                Text(topic)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

struct TestTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        TestTopicsView()
    }
}
