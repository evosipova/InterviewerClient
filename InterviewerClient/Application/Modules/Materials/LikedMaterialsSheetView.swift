import SwiftUI

struct LikedMaterialsSheetView: View {
    var likedItems: [MaterialItem]
    var onToggleLike: (MaterialItem) -> Void

    @State private var selectedItem: MaterialItem?

    var body: some View {
        NavigationView {
            ZStack {
                if likedItems.isEmpty {
                    GeometryReader { geometry in
                        VStack(spacing: 12) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)

                            Text("Понравившихся материалов нет")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(likedItems) { item in
                                MaterialRowView(
                                    item: item,
                                    onTap: {
                                        selectedItem = item
                                    },
                                    onLikeToggle: {
                                        onToggleLike(item)
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationBarTitle("Понравившиеся", displayMode: .inline)
            .fullScreenCover(item: $selectedItem) { item in
                MaterialScrollDetailView(item: item, onBack: { selectedItem = nil })
            }
        }
    }
}

#Preview {
    LikedMaterialsSheetView(
        likedItems: [],
        onToggleLike: { _ in }
    )
}
