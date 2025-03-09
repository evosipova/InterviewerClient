import SwiftUI

struct AddNotificationPopup: View {
    @State private var selectedTime = Date()
    @State private var selectedDays: Set<String> = []
    
    private let allDays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    var onSave: (NotificationItem) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                Spacer()
                
                Text("Новое уведомление")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Button(action: { onClose() }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 10)
            
            
            HStack {
                Text("Время")
                Spacer()
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Дни")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                    ForEach(allDays, id: \.self) { day in
                        Button(action: { toggleDaySelection(day) }) {
                            Text(day)
                                .frame(width: 40, height: 40)
                                .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedDays.contains(day) ? .white : .black)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            Button(action: saveNotification) {
                Text("Добавить")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func toggleDaySelection(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }
    
    private func saveNotification() {
        guard !selectedDays.isEmpty else { return }
        
        let newNotification = NotificationItem(time: selectedTime, days: Array(selectedDays))
        onSave(newNotification)
    }
}

struct AddNotificationPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddNotificationPopup(onSave: { _ in }, onClose: {})
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
