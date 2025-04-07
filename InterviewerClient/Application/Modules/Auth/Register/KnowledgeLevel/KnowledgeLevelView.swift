import SwiftUI

struct KnowledgeLevelView: View {
    @Environment(\.colorScheme) var colorScheme
    var onBack: () -> Void
    var onNext: () -> Void
    
    @State private var selectedLevel: String = "Junior"
    let levels = ["Junior", "Middle", "Senior"]
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavBar(title: "Выберите уровень", onBack: onBack)
            
            VStack(spacing: 15) {
                ForEach(levels, id: \.self) { level in
                    HStack {
                        Text(level)
                            .font(.title2)
                            .bold()
                        Spacer()
                        Circle()
                            .fill(selectedLevel == level ? Color.green.opacity(0.8) : Color.gray.opacity(0.2))
                            .frame(width: 30, height: 30)
                            .overlay(
                                selectedLevel == level ? Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold)) : nil
                            )
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .onTapGesture {
                        selectedLevel = level
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: onNext) {
                HStack {
                    Text("Далее")
                        .font(.headline)
                        .bold()
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
    }
}

struct KnowledgeLevelView_Previews: PreviewProvider {
    static var previews: some View {
        KnowledgeLevelView(onBack: {}, onNext: {})
    }
}
