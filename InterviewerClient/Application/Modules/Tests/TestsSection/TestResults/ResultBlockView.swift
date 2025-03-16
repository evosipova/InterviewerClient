import SwiftUICore

struct ResultBlockView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.largeTitle)
                .bold()
            Text(title)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}
