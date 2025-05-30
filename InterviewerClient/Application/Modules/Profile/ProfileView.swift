import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var userProfile = UserProfileModel.shared

    @AppStorage("selectedTheme") private var selectedTheme: String = "Системная"
    @State private var showHistorySheet = false
    @State private var showNotificationsSheet = false

    let themes = ["Системная", "Светлая", "Тёмная"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    VStack {
                        if let image = userProfile.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                                .padding(.top, 10)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                        }

                        VStack(spacing: 4) {
                            Text(userProfile.fullName.prefix(30))
                                .font(.title)
                                .bold()
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .center)

                            Text(userProfile.knowledgeLevel)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity)

                    Button(action: { showHistorySheet.toggle() }) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.primary)
                            Text("История тестов")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .sheet(isPresented: $showHistorySheet) {
                        TestHistoryViewProfile()
                    }

                    Button(action: { showNotificationsSheet.toggle() }) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.primary)
                            Text("Уведомления")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
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
                            .foregroundColor(.primary)

                        HStack {
                            ForEach(themes, id: \.self) { theme in
                                Button(action: {
                                    selectedTheme = theme
                                    applyTheme(theme)
                                }) {
                                    VStack {
                                        Image(systemName: theme == "Системная" ? "sun.max.fill" : (theme == "Светлая" ? "sun.max" : "moon.fill"))
                                            .font(.largeTitle)
                                            .foregroundColor(.primary)
                                        Text(theme)
                                            .font(.footnote)
                                            .bold()
                                            .fixedSize(horizontal: true, vertical: false)
                                            .minimumScaleFactor(0.8)
                                            .lineLimit(1)
                                            .foregroundColor(.primary)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                                    .padding()
                                    .background(selectedTheme == theme ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)

                    NavigationLink(
                        destination: EditProfileView(
                            fullName: $userProfile.fullName,
                            knowledgeLevel: $userProfile.knowledgeLevel,
                            profileImage: $userProfile.profileImage
                        )
                    ) {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.primary)
                            Text("Редактировать профиль")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)

                    Button(action: {
                        coordinator.logout()
                    }) {
                        Text("Выйти")
                            .font(.headline)
                            .foregroundColor(.primary)
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
