import SwiftUI

struct ChatRowView: View {
    let chatIndex: Int
    let lastMessage: String
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "message.fill")
                .foregroundColor(.blue)

            VStack(alignment: .leading) {
                Text("Чат \(chatIndex + 1)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .bold()
                Text(lastMessage)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
        }
    }
}


struct ChatRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRowView(
            chatIndex: 0,
            lastMessage: "Последнее сообщение в чате...",
            onTap: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
