import SwiftUI

struct LikedMaterialsSheetView: View {
    var likedItems: [MaterialItem]
    var onToggleLike: (MaterialItem) -> Void
    
    @State private var selectedItem: MaterialItem?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if likedItems.isEmpty {
                        Text("Понравившихся материалов нет")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 20)
                    } else {
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
                }
                .padding(.top, 10)
            }
            .navigationBarTitle("Понравившиеся", displayMode: .inline)
            .fullScreenCover(item: $selectedItem) { item in
                MaterialScrollDetailView(item: item, onBack: { selectedItem = nil })
            }

        }
    }
}


