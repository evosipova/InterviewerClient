import SwiftUI

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
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 20)

                        Spacer()
                    }
                }
                .frame(height: 44)
                .padding(.top, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(item.subtitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)

                        Text("Здесь может быть подробное описание...")
                            .padding(.horizontal, 20)

                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MaterialScrollDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialScrollDetailView(
            item: MaterialItem(id: 1, title: "Тема", subtitle: "Описание", isLiked: false),
            onBack: {}
        )
    }
}
