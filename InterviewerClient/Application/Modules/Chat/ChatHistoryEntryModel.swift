import Foundation

struct ChatHistoryEntryModel: Identifiable {
    let id = UUID()
    var messages: [String]
    var assistant: ChatView.AssistantType?
}
