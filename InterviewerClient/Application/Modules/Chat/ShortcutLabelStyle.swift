import Foundation
import SwiftUI

struct ShortcutLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            configuration.icon
                .foregroundColor(.blue)
            configuration.title
                .foregroundColor(.blue)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
    }
}
