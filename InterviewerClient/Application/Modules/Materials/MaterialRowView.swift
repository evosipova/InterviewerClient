import SwiftUI

struct MaterialRowView: View {
    let item: MaterialItem
    let onTap: () -> Void
    let onLikeToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onLikeToggle) {
                Image(systemName: item.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(item.isLiked ? .red : .gray)
                    .padding(.trailing, 5)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .bold()
                Text(item.subtitle)
                    .font(.footnote)
                    .foregroundColor(.black)
            }
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
        }
    }
}

struct MaterialRowView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialRowView(
            item: .init(
                id: 1,
                title: "Название",
                subtitle: "1",
                isLiked: true,
                level: "Описание",
                content: ""
            ),
            onTap: {
            },
            onLikeToggle: {})
    }
}

