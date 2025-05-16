import SwiftUI

enum ContentBlock: Identifiable {
    case text([InlineTextBlock])
    case code(String)

    var id: UUID { UUID() }
}

enum InlineTextBlock: Identifiable {
    case plain(String)
    case inlineCode(String)

    var id: UUID { UUID() }
}

struct MaterialScrollDetailView: View {
    let item: MaterialItem
    var onBack: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Text(item.title)
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                }
                .frame(height: 44)
                .padding(.top, 15)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.subtitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)

                        let blocks = parseContent(item.content)

                        VStack(alignment: .leading, spacing: -15) {
                            ForEach(blocks) { block in
                                switch block {
                                case .text(let inlineParts):
                                    buildInline(inlineParts)
                                        .padding(.horizontal, 20)

                                case .code(let code):
                                    Text(code)
                                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                                        .padding(10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
        }
    }

    func buildInline(_ parts: [InlineTextBlock]) -> Text {
        var text = Text("")

        for part in parts {
            switch part {
            case .plain(let string):
                text = text + Text(string)
            case .inlineCode(let code):
                text = text + Text(code)
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
                    .foregroundColor(Color(UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 2)))
            }
        }

        return text
    }

    func parseContent(_ content: String) -> [ContentBlock] {
        var blocks: [ContentBlock] = []
        let blockPattern = "```(?:swift)?\\n([\\s\\S]*?)\\n```"
        let blockRegex = try! NSRegularExpression(pattern: blockPattern)

        var lastIndex = content.startIndex

        let matches = blockRegex.matches(in: content, range: NSRange(content.startIndex..., in: content))

        for match in matches {
            if let range = Range(match.range(at: 0), in: content),
               let codeRange = Range(match.range(at: 1), in: content) {

                let textBefore = String(content[lastIndex..<range.lowerBound])
                if !textBefore.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let inlineParsed = parseInline(textBefore)
                    blocks.append(.text(inlineParsed))
                }

                let code = String(content[codeRange])
                blocks.append(.code(code))

                lastIndex = range.upperBound
            }
        }

        let remaining = String(content[lastIndex...])
        if !remaining.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let inlineParsed = parseInline(remaining)
            blocks.append(.text(inlineParsed))
        }

        return blocks
    }

    func parseInline(_ text: String) -> [InlineTextBlock] {
        var result: [InlineTextBlock] = []
        let pattern = "`(.*?)`"
        let regex = try! NSRegularExpression(pattern: pattern)

        var lastIndex = text.startIndex
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

        for match in matches {
            if let range = Range(match.range(at: 0), in: text),
               let codeRange = Range(match.range(at: 1), in: text) {
                let before = text[lastIndex..<range.lowerBound]
                if !before.isEmpty {
                    result.append(.plain(String(before)))
                }
                result.append(.inlineCode(String(text[codeRange])))
                lastIndex = range.upperBound
            }
        }

        let remaining = text[lastIndex...]
        if !remaining.isEmpty {
            result.append(.plain(String(remaining)))
        }

        return result
    }

}
