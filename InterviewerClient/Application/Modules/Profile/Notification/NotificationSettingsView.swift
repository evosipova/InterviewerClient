import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var isNotificationsEnabled: Bool = false
    @State private var notifications: [NotificationItem] = []
    @State private var showAddNotificationPopup = false

    private let notificationMessages = [
        "Пора начать занятие! Поехали 💪",
        "Удели 5 минут улучшению своих навыков 🧠",
        "Время тренировки! Сделай это! 🚀",
        "Прогресс начинается с действий! 🔥",
        "Ты сможешь! Начни прямо сейчас ⏳"
    ]

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    Section {
                        Toggle("Напоминания", isOn: $isNotificationsEnabled)
                            .onChange(of: isNotificationsEnabled) { handleNotificationToggle() }
                    }

                    if isNotificationsEnabled && !notifications.isEmpty {
                        Section {
                            ForEach(notifications, id: \.id) { notification in
                                HStack {
                                    Text(notification.displayText)
                                        .font(.body)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        removeNotification(notification)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Настройки уведомлений", displayMode: .inline)
                .navigationBarItems(
                    leading: isNotificationsEnabled ? AnyView(
                        Button(action: removeAllNotifications) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    ) : AnyView(EmptyView()),

                    trailing: isNotificationsEnabled ? AnyView(
                        Button(action: { showAddNotificationPopup = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    ) : AnyView(EmptyView())
                )
                .onAppear { loadNotificationSettings() }
            }

            if isNotificationsEnabled && notifications.isEmpty {
                GeometryReader { geometry in
                    VStack(spacing: 12) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Пока тишина.\nДобавь напоминание и держи фокус!")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                }
            }

            if showAddNotificationPopup {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { showAddNotificationPopup = false }

                AddNotificationPopup { newNotification in
                    notifications.append(newNotification)
                    saveNotificationSettings()
                    scheduleNotification(newNotification)
                    showAddNotificationPopup = false
                } onClose: {
                    showAddNotificationPopup = false
                }
                .padding(10)
            }
        }
    }

    private func removeAllNotifications() {
        notifications.removeAll()
        saveNotificationSettings()
        removeScheduledNotifications()
    }

    private func handleNotificationToggle() {
        if isNotificationsEnabled {
            requestNotificationPermission()
            for notification in notifications {
                scheduleNotification(notification)
            }
        } else {
            removeScheduledNotifications()
        }
        saveNotificationSettings()
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    self.isNotificationsEnabled = false
                }
            }
        }
    }

    private func scheduleNotification(_ notification: NotificationItem) {
        for day in notification.sortedDays() {
            let content = UNMutableNotificationContent()
            content.title = "Interviewer 📢"
            content.body = notificationMessages.randomElement() ?? "Время для тренировки!"
            content.sound = .default

            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notification.time)
            dateComponents.weekday = dayToNumber(day)

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(
                identifier: "reminder_\(day)_\(notification.id)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка при добавлении уведомления: \(error)")
                }
            }
        }
    }

    private func removeScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func dayToNumber(_ day: String) -> Int {
        let mapping: [String: Int] = ["Вс": 1, "Пн": 2, "Вт": 3, "Ср": 4, "Чт": 5, "Пт": 6, "Сб": 7]
        return mapping[day] ?? 2
    }

    private func removeNotification(_ notification: NotificationItem) {
        notifications.removeAll { $0.id == notification.id }
        saveNotificationSettings()
        removeScheduledNotifications()
        for notification in notifications {
            scheduleNotification(notification)
        }
    }

    private func saveNotificationSettings() {
        UserDefaults.standard.set(isNotificationsEnabled, forKey: "notificationsEnabled")
        let encodedData = try? JSONEncoder().encode(notifications)
        UserDefaults.standard.set(encodedData, forKey: "notificationsList")
    }

    private func loadNotificationSettings() {
        isNotificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        if let savedData = UserDefaults.standard.data(forKey: "notificationsList"),
           let savedNotifications = try? JSONDecoder().decode([NotificationItem].self, from: savedData) {
            notifications = savedNotifications
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
