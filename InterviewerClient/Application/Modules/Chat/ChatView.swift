import SwiftUI
import Speech

struct ChatView: View {
    enum AssistantType: String, CaseIterable {
        case hr = "📄 HR-собеседование"
        case technical = "🛠️ Техническое интервью"
        case algorithms = "📚 Алгоритмы и кодирование"
    }

    @State private var selectedAssistant: AssistantType? = nil
    @State private var messageText = ""
    @State private var messages: [String] = []
    @State private var chatHistory: [ChatHistoryEntryModel] = []
    @State private var currentChatIndex: Int?
    @State private var showChatHistory = false
    @State private var textFieldHeight: CGFloat = 50
    @StateObject private var openAI = OpenAIService()
    @State private var hasStartedChat = false
    @State private var showShortcuts = false
    @StateObject private var speechRecognizer = SpeechRecognizer()

    private var displayedText: Binding<String> {
        Binding(
            get: {
                speechRecognizer.isRecording
                ? messageText + speechRecognizer.transcribedText
                : messageText
            },
            set: { newValue in
                messageText = newValue
            }
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if messages.isEmpty && !hasStartedChat {
                    VStack {
                        Spacer()
                        Text("Чем я могу вам помочь?")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()

                        VStack(spacing: 12) {
                            ForEach(AssistantType.allCases, id: \.self) { type in
                                Button(action: {
                                    selectedAssistant = type
                                    hasStartedChat = true
                                }) {
                                    Text(type.rawValue)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    if let selected = selectedAssistant {
                        HStack {
                            Text("Ассистент: \(selected.rawValue)")
                                .font(.caption)
                                .bold()
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        .background(.ultraThinMaterial)
                    }

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(messages.indices, id: \.self) { index in
                                    ChatBubble(message: messages[index], isUser: !messages[index].hasPrefix("🤖"))
                                        .id(index)
                                }
                            }
                            .padding()
                            .onChange(of: messages) {
                                scrollToBottom(proxy)
                            }
                            .onChange(of: textFieldHeight) {
                                scrollToBottom(proxy)
                            }
                            .onChange(of: speechRecognizer.transcribedText) { _, _ in
                                scrollToBottom(proxy)
                            }
                        }
                    }
                }

                Divider()

                HStack(alignment: .bottom, spacing: 10) {
                    ZStack(alignment: .topLeading) {
                        if messageText.isEmpty && speechRecognizer.transcribedText.isEmpty {
                            Text("Введите сообщение...")
                                .padding(.leading, 14)
                                .padding(.top, 12)
                                .foregroundColor(.gray)
                                .allowsHitTesting(false)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            TextEditor(text: displayedText)
                                .frame(minHeight: 40, maxHeight: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .opacity(1)
                                .scrollContentBackground(.hidden)
                                .onChange(of: messageText) { _, _ in
                                    withAnimation {
                                        adjustTextFieldHeight()
                                    }
                                }
                        }
                        .padding(.top, 2)
                    }
                    .frame(maxHeight: textFieldHeight)

                    Button(action: {
                        if speechRecognizer.isRecording {
                            speechRecognizer.stopRecording()
                            messageText += (messageText.isEmpty ? "" : " ") + speechRecognizer.transcribedText
                            speechRecognizer.transcribedText = ""
                        } else {
                            try? speechRecognizer.startRecording()
                        }
                    }) {
                        Image(systemName: speechRecognizer.isRecording ? "mic.fill" : "mic")
                            .font(.title2)
                            .padding(14)
                            .background(speechRecognizer.isRecording ? Color.red : Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .frame(height: textFieldHeight)
                    .animation(.easeInOut(duration: 0.2), value: speechRecognizer.isRecording)

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .padding(14)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .frame(height: textFieldHeight)
                }
                .padding()
            }
            .navigationBarTitle("Чат", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: { showChatHistory = true }) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.blue)
                    },
                trailing: HStack(spacing: 16) {
                    Button(action: {
                        withAnimation {
                            showShortcuts.toggle()
                        }
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Button(action: createNewChat) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            )
            .sheet(isPresented: $showChatHistory, onDismiss: handleChatHistoryDismiss) {
                ChatHistoryView(chats: $chatHistory, selectChat: loadChat, onDeleteAll: {})
            }
            .onTapGesture {
                hideKeyboard()
                withAnimation { showShortcuts = false }
            }
            .overlay(
                GeometryReader { geo in
                    if showShortcuts {
                        ZStack {
                            Color.black.opacity(0.001)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    showShortcuts = false
                                }

                            VStack {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .leading, spacing: 0) {
                                        Button(action: {
                                            sendShortcut("Давайте начнём интервью.")
                                        }) {
                                            Label("Начать интервью", systemImage: "play.fill")
                                                .labelStyle(ShortcutLabelStyle())
                                        }

                                        Divider()

                                        Button(action: {
                                            sendShortcut("Спасибо! На этом интервью можно закончить.")
                                        }) {
                                            Label("Завершить интервью", systemImage: "stop.fill")
                                                .labelStyle(ShortcutLabelStyle())
                                        }
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(radius: 5)
                                    )
                                    .fixedSize()
                                    .padding(.top, 8)
                                    .padding(.trailing, 8)
                                }
                                Spacer()
                            }
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .topTrailing)
                        }
                    }
                }
            )

        }
    }

    private func sendShortcut(_ text: String) {
        showShortcuts = false
        messageText = text
        sendMessage()
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        let userMessage = "🧑‍💻 " + userText

        if currentChatIndex == nil {
            chatHistory.append(ChatHistoryEntryModel(messages: [], assistant: selectedAssistant))
            currentChatIndex = chatHistory.count - 1
        }

        hasStartedChat = true
        messages.append(userMessage)
        saveChatHistory()

        messageText = ""
        textFieldHeight = 40

        Task {
            do {
                let gptReply = try await openAI.sendMessageToGPT(
                    answer: userText,
                    assistantRole: selectedAssistant ?? .technical
                )
                let trimmedReply = gptReply.trimmingCharacters(in: .whitespacesAndNewlines)

                let response = "🤖 " + trimmedReply
                messages.append(response)
                saveChatHistory()

            } catch {
                messages.append("🤖 Ошибка при получении ответа.")
                saveChatHistory()
            }
        }
    }

    private func createNewChat() {
        if let index = currentChatIndex, !messages.isEmpty {
            chatHistory[index].messages = messages
        }

        messages = []
        currentChatIndex = nil
        hasStartedChat = false
        selectedAssistant = nil
    }

    private func loadChat(index: Int) {
        currentChatIndex = index
        messages = chatHistory[index].messages
        selectedAssistant = chatHistory[index].assistant
        hasStartedChat = true
    }

    private func saveChatHistory() {
        guard let index = currentChatIndex, index >= 0, index < chatHistory.count else { return }
        chatHistory[index].messages = messages
    }

    private func handleChatHistoryDismiss() {
        if chatHistory.isEmpty {
            messages.removeAll()
            currentChatIndex = nil
        }
    }

    private func adjustTextFieldHeight() {
        let combinedText = messageText + speechRecognizer.transcribedText
        let maxHeight: CGFloat = 100
        let newHeight = min(maxHeight, combinedText.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 100,
            font: .systemFont(ofSize: 17)
        ))
        textFieldHeight = newHeight
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(messages.count - 1, anchor: .bottom)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
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
        return ceil(boundingBox.height) + 25
    }
}
