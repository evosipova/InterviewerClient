import SwiftUI

struct ChatBubble: View {
    var message: String
    var isUser: Bool

    @State private var showCopiedConfirmation = false

    var body: some View {
        HStack(alignment: .bottom, spacing: isUser ? 0 : 4) {
            if isUser {
                Spacer()
                Text(message.replacingOccurrences(of: "🧑‍💻 ", with: ""))
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
            } else {
                Text(message.replacingOccurrences(of: "🤖 ", with: ""))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .alignmentGuide(.bottom) { d in d[.bottom] }

                Button(action: {
                    let cleanMessage = message.replacingOccurrences(of: "🤖 ", with: "")
                    UIPasteboard.general.string = cleanMessage
                    withAnimation {
                        showCopiedConfirmation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showCopiedConfirmation = false
                        }
                    }
                }) {
                    Image(systemName: showCopiedConfirmation ? "checkmark" : "doc.on.doc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(.gray)
                }
                .alignmentGuide(.bottom) { d in d[.bottom] }
                .padding(.leading, 2)
            }

            if !isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
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
