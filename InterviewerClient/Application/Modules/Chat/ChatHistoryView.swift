import SwiftUI

struct ChatHistoryView: View {
    @Binding var chats: [[String]]
    var selectChat: (Int) -> Void
    var onDeleteAll: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                if chats.isEmpty {
                    Text("Нет сохранённых чатов")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(chats.indices, id: \.self) { index in
                                ChatRowView(
                                    chatIndex: index,
                                    lastMessage: chats[index].last ?? "Нет сообщений",
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
                ["Привет, как дела?", "Я ИИ, чем могу помочь?"],
                ["Как работает SwiftUI?", "SwiftUI — это декларативный UI-фреймворк от Apple."]
            ]),
            selectChat: { _ in }, onDeleteAll: {}
        )
    }
}
