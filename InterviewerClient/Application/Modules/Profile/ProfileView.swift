import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    @AppStorage("selectedTheme") private var selectedTheme: String = "Системная"
    
    @State private var fullName: String = "annaliza2011"
    @State private var birthdate = Date()
    @State private var selectedGender = "Не указывать"
    @State private var knowledgeLevel = "Средний"
    @State private var showHistorySheet = false
    @State private var showNotificationsSheet = false  
    
    let themes = ["Системная", "Светлая", "Тёмная"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        
                        HStack {
                            Text(fullName)
                                .font(.title2)
                                .bold()
                            NavigationLink(destination: EditProfileView(fullName: $fullName, birthdate: $birthdate, selectedGender: $selectedGender, knowledgeLevel: $knowledgeLevel)) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: { showHistorySheet.toggle() }) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("История тестов")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .sheet(isPresented: $showHistorySheet) {
                        TestHistoryViewProfile()
                    }
                    
                    Button(action: { showNotificationsSheet.toggle() }) {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Уведомления")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $showNotificationsSheet) {
                        NotificationSettingsView()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Тема оформления")
                            .font(.headline)
                        
                        HStack {
                            ForEach(themes, id: \.self) { theme in
                                Button(action: {
                                    selectedTheme = theme
                                    applyTheme(theme)
                                }) {
                                    VStack {
                                        Image(systemName: theme == "Системная" ? "sun.max.fill" : (theme == "Светлая" ? "sun.max" : "moon.fill"))
                                            .font(.largeTitle)
                                        Text(theme)
                                            .font(.footnote)
                                            .bold()
                                            .fixedSize(horizontal: true, vertical: false)
                                            .minimumScaleFactor(0.8)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                                    .padding()
                                    .background(selectedTheme == theme ? Color.pink.opacity(0.3) : Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        coordinator.logout()
                    }) {
                        Text("Выйти")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
            .navigationBarTitle("Профиль", displayMode: .large)
            .background(Color(.systemBackground))
        }
    }
    
    private func applyTheme(_ theme: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        switch theme {
        case "Светлая":
            window.overrideUserInterfaceStyle = .light
        case "Тёмная":
            window.overrideUserInterfaceStyle = .dark
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AppCoordinator(navigationController: UINavigationController()))
    }
}
