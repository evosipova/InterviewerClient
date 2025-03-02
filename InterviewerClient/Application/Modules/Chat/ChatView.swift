import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [String] = []
    @State private var chatHistory: [[String]] = []
    @State private var currentChatIndex: Int?
    @State private var showChatHistory = false
    
    @State private var textFieldHeight: CGFloat = 50
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages, id: \.self) { message in
                            ChatBubble(message: message, isUser: !message.hasPrefix("🤖"))
                        }
                    }
                    .padding()
                }
                
                HStack(alignment: .bottom, spacing: 10) {
                    ZStack(alignment: .leading) {
                        if messageText.isEmpty {
                            Text("Введите сообщение...")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                                .padding(.vertical, 8)
                        }
                        
                        TextEditor(text: $messageText)
                            .frame(minHeight: 40, maxHeight: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .opacity(messageText.isEmpty ? 0.6 : 1)
                            .scrollContentBackground(.hidden)
                            .onChange(of: messageText) { _ in
                                withAnimation {
                                    adjustTextFieldHeight()
                                }
                            }
                    }
                    .frame(maxHeight: textFieldHeight)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .padding(14)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .frame(height: textFieldHeight)
                    .animation(.easeInOut, value: textFieldHeight)
                }
                .padding()
            }
            .navigationBarTitle("Чат", displayMode: .inline)
            .navigationBarItems(
                leading: HStack {
                    Button(action: { showChatHistory = true }) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                },
                trailing: Button(action: createNewChat) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showChatHistory, onDismiss: handleChatHistoryDismiss) {
                ChatHistoryView(chats: $chatHistory, selectChat: loadChat, onDeleteAll: {})
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = "🧑‍💻 " + messageText
        
        if currentChatIndex == nil {
            createNewChat()
        }
        
        messages.append(userMessage)
        saveChatHistory()
        
        messageText = ""
        withAnimation {
            textFieldHeight = 40
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = "🤖 Это ответ ИИ 💡"
            messages.append(response)
            saveChatHistory()
        }
    }
    
    private func createNewChat() {
        chatHistory.append([])
        currentChatIndex = chatHistory.count - 1
        messages = []
    }
    
    private func loadChat(index: Int) {
        currentChatIndex = index
        messages = chatHistory[index]
    }
    
    private func saveChatHistory() {
        guard let index = currentChatIndex, index >= 0, index < chatHistory.count else {
            return
        }
        
        chatHistory[index] = messages
    }
    
    private func handleChatHistoryDismiss() {
        if chatHistory.isEmpty {
            messages.removeAll()
            currentChatIndex = nil
        }
    }
    
    private func adjustTextFieldHeight() {
        let maxHeight: CGFloat = 100
        let newHeight = min(maxHeight, messageText.height(withConstrainedWidth: UIScreen.main.bounds.width - 100, font: .systemFont(ofSize: 17)))
        textFieldHeight = newHeight
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height) + 20
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
