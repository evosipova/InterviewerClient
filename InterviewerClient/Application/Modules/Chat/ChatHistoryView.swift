import SwiftUI

struct ChatHistoryView: View {
    @Binding var chats: [ChatHistoryEntryModel]
    var selectChat: (Int) -> Void
    var onDeleteAll: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                if chats.isEmpty {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "ellipsis.message")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Нет сохранённых чатов")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(chats.indices, id: \.self) { index in
                                ChatRowView(
                                    chatIndex: index,
                                    lastMessage: chats[index].messages.last ?? "Нет сообщений",
                                    onTap: {
                                        selectChat(index)
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                )
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteChat(at: index)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationBarTitle("История чатов", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: deleteAllChats) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            )
        }
    }

    private func deleteChat(at index: Int) {
        chats.remove(at: index)
    }

    private func deleteAllChats() {
        chats.removeAll()
        onDeleteAll()
    }
}

struct ChatHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHistoryView(
            chats: .constant([
                ChatHistoryEntryModel(
                    messages: ["Привет! Как дела?", "Отлично, а у тебя?"],
                    assistant: .technical
                ),
                ChatHistoryEntryModel(
                    messages: ["Что такое SwiftUI?", "Это фреймворк от Apple для создания UI."],
                    assistant: .hr
                )
            ]),
            selectChat: { _ in },
            onDeleteAll: {}
        )
    }
}
