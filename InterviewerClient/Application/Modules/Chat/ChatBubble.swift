import SwiftUI

struct ChatBubble: View {
    var message: String
    var isUser: Bool
    
    var body: some View {
        HStack {
            if isUser {
                Spacer()
                Text(message.replacingOccurrences(of: "🧑‍💻 ", with: ""))
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.replacingOccurrences(of: "🤖 ", with: ""))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ChatBubble(message: "🧑‍💻 Привет! Как дела?", isUser: true)
            ChatBubble(message: "🤖 Привет! Всё отлично, спасибо!", isUser: false)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
