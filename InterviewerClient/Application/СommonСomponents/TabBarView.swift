import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @ObservedObject var coordinator: AppCoordinator 

    var body: some View {
        TabView(selection: $selectedTab) {
            MaterialsView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Материалы")
                }
                .tag(0)

            TestsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Тесты")
                }
                .tag(1)

            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Чат")
                }
                .tag(2)

            StatisticsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Статистика")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Профиль")
                }
                .tag(4)
                .environmentObject(coordinator)
        }
        .background(Color(.systemBackground))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(coordinator: AppCoordinator(navigationController: UINavigationController()))
    }
}
