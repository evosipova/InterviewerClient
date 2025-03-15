import SwiftUI

struct TestHistoryViewProfile: View {
    var body: some View {
        VStack {
            HStack {
                Text("История тестов")
                    .font(.headline)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding()

            ScrollView {
                VStack {
                    TestHistoryCard(title: "Код", correct: 2, incorrect: 3, time: "01:08")
                }
            }
        }
        .padding()
    }
}
