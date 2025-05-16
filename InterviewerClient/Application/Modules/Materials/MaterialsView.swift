import SwiftUI

struct MaterialItem: Identifiable, Hashable, Codable {
    let id: Int
    var title: String
    var subtitle: String
    var isLiked: Bool
    var level: String
    var content: String
}

struct MaterialsResponse: Codable {
    let materials: [MaterialItem]
}

struct MaterialsView: View {
    @State private var searchText: String = ""
    @State private var showLikedSheet = false
    @State private var showDetail = false
    @State private var selectedItem: MaterialItem?
    @ObservedObject var userProfile = UserProfileModel.shared

    @State private var recommendedMaterials: [MaterialItem] = []
    @State private var allMaterials: [MaterialItem] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    
                    HStack(spacing: 10) {
                        TextField("Поиск", text: $searchText)
                            .padding(10)
                            .frame(height: 44)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                        
                        Button(action: {
                            showLikedSheet = true
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    if !recommendedMaterials.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Рекомендации")
                                .font(.headline)
                                .bold()
                                .padding(.horizontal, 20)
                                .padding(.top, 10)

                            if filteredRecommendations.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("Ничего не найдено")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            } else {
                                ForEach(filteredRecommendations) { material in
                                    MaterialRowView(
                                        item: material,
                                        onTap: {
                                            selectedItem = material
                                            showDetail = true
                                        },
                                        onLikeToggle: {
                                            toggleLike(item: material)
                                        }
                                    )
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Материалы")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal, 20)
                        
                        if filteredMaterials.isEmpty {
                            HStack {
                                Spacer()
                                Text("Ничего не найдено")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        } else {
                            ForEach(filteredMaterials) { material in
                                MaterialRowView(
                                    item: material,
                                    onTap: {
                                        selectedItem = material
                                        showDetail = true
                                    },
                                    onLikeToggle: {
//                                        toggleLike(item: material, in: &allMaterials)
                                        toggleLike(item: material)
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Материалы", displayMode: .large)
            .onAppear {
                loadMaterials()
            }
            .sheet(isPresented: $showLikedSheet) {
                let likedMaterials = (allMaterials + recommendedMaterials).filter { $0.isLiked }
                LikedMaterialsSheetView(
                    likedItems: likedMaterials,
                    onToggleLike: { item in
                        if let i = allMaterials.firstIndex(where: { $0.id == item.id }) {
                            allMaterials[i].isLiked.toggle()
                        }
                        if let i = recommendedMaterials.firstIndex(where: { $0.id == item.id }) {
                            recommendedMaterials[i].isLiked.toggle()
                        }
                    }
                )
            }
            .fullScreenCover(item: $selectedItem) { item in
                MaterialScrollDetailView(item: item, onBack: { selectedItem = nil })
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private var filteredRecommendations: [MaterialItem] {
        filterItems(searchText: searchText, in: recommendedMaterials)
    }
    
    private var filteredMaterials: [MaterialItem] {
        filterItems(searchText: searchText, in: allMaterials)
    }
    
    private func filterItems(searchText: String, in array: [MaterialItem]) -> [MaterialItem] {
        if searchText.isEmpty { return array }
        let lower = searchText.lowercased()
        return array.filter { $0.title.lowercased().contains(lower) || $0.subtitle.lowercased().contains(lower) }
    }

    private func toggleLike(item: MaterialItem) {
        if let index = allMaterials.firstIndex(where: { $0.id == item.id }) {
            allMaterials[index].isLiked.toggle()
        }

        if let index = recommendedMaterials.firstIndex(where: { $0.id == item.id }) {
            recommendedMaterials[index].isLiked.toggle()
        }
    }

    private func loadMaterials() {
        guard let url = Bundle.main.url(forResource: "materials", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(MaterialsResponse.self, from: data)
            
            self.recommendedMaterials = decodedData.materials.filter { $0.level.lowercased() == userProfile.knowledgeLevel.lowercased() }
            self.allMaterials = decodedData.materials.filter { $0.level.lowercased() != userProfile.knowledgeLevel.lowercased() }
        } catch {}
    }
}

