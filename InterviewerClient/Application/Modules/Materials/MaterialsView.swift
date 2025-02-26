import SwiftUI

struct MaterialsView: View {
    @State private var searchText: String = ""
    @State private var showLikedSheet = false
    @State private var showDetail = false
    @State private var selectedItem: MaterialItem?
    
    @State private var courses: [MaterialItem] = [
        MaterialItem(id: 1, title: "Тема 1", subtitle: "Название курса 1", isLiked: false),
        MaterialItem(id: 2, title: "Тема 2", subtitle: "Название курса 2", isLiked: true),
        MaterialItem(id: 3, title: "Тема 3", subtitle: "Название курса 3", isLiked: false),
    ]
    
    @State private var materials: [MaterialItem] = [
        MaterialItem(id: 101, title: "Материал 1", subtitle: "Описание 1", isLiked: false),
        MaterialItem(id: 102, title: "Материал 2", subtitle: "Описание 2", isLiked: false)
    ]
    
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

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Курсы")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal, 20)
                        
                        if filteredCourses.isEmpty {
                            HStack {
                                Spacer()
                                Text("Ничего не найдено")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        } else {
                            ForEach(filteredCourses) { course in
                                MaterialRowView(
                                    item: course,
                                    onTap: {
                                        selectedItem = course
                                        showDetail = true
                                    },
                                    onLikeToggle: {
                                        toggleLike(item: course, in: &courses)
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Материалы")
                            .font(.headline)
                            .bold()
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        if filteredMaterials.isEmpty {
                            HStack {
                                Spacer()
                                Text("Ничего не найдено")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        } else {
                            ForEach(filteredMaterials) { mat in
                                MaterialRowView(
                                    item: mat,
                                    onTap: {
                                        selectedItem = mat
                                        showDetail = true
                                    },
                                    onLikeToggle: {
                                        toggleLike(item: mat, in: &materials)
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Материалы", displayMode: .large)

            .sheet(isPresented: $showLikedSheet) {
                let likedCourses = courses.filter { $0.isLiked }
                let likedMaterials = materials.filter { $0.isLiked }
                LikedMaterialsSheetView(
                    likedItems: likedCourses + likedMaterials,
                    onToggleLike: { item in
                        if let i = courses.firstIndex(where: { $0.id == item.id }) {
                            courses[i].isLiked.toggle()
                        }
                        if let i = materials.firstIndex(where: { $0.id == item.id }) {
                            materials[i].isLiked.toggle()
                        }
                    }
                )
            }
            .fullScreenCover(item: $selectedItem) { item in
                MaterialScrollDetailView(item: item, onBack: { selectedItem = nil })
            }

        }
    }
    
    private var filteredCourses: [MaterialItem] {
        filterItems(searchText: searchText, in: courses)
    }
    private var filteredMaterials: [MaterialItem] {
        filterItems(searchText: searchText, in: materials)
    }
    private func filterItems(searchText: String, in array: [MaterialItem]) -> [MaterialItem] {
        if searchText.isEmpty { return array }
        let lower = searchText.lowercased()
        return array.filter { $0.title.lowercased().contains(lower) || $0.subtitle.lowercased().contains(lower) }
    }
    
    private func toggleLike(item: MaterialItem, in array: inout [MaterialItem]) {
        if let index = array.firstIndex(where: { $0.id == item.id }) {
            array[index].isLiked.toggle()
        }
    }
}
