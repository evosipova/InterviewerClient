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
                    Text("Нет сохранённых чатов")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, -50)
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
