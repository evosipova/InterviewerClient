import SwiftUI

struct LeaderBoardRow: View {
    let index: Int
    let user: UserStatsModel
    let sortByTime: Bool

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if index == 0 {
                    Text("🥇")
                } else if index == 1 {
                    Text("🥈")
                } else if index == 2 {
                    Text("🥉")
                } else {
                    Spacer().frame(width: 20)
                }
            }
            .frame(width: 24)

            Text("\(index + 1)")
                .bold()
                .frame(width: 12, alignment: .leading)

            Image(uiImage: user.profileImage ?? UIImage(systemName: "person.crop.circle.fill")!)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))

            Text(user.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(sortByTime ? formatTime(user.totalTime) : "\(user.correctAnswers)")
                .bold()
                .frame(width: 80, alignment: .trailing)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.vertical, 4)
    }

    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    VStack(spacing: 8) {
        LeaderBoardRow(
            index: 0,
            user: UserStatsModel(
                name: "Лиза",
                correctAnswers: 80,
                totalTime: 7200,
                profileImage: UIImage(systemName: "person.crop.circle")
            ),
            sortByTime: false
        )

        LeaderBoardRow(
            index: 1,
            user: UserStatsModel(
                name: "Денис",
                correctAnswers: 70,
                totalTime: 6500,
                profileImage: nil
            ),
            sortByTime: false
        )
    }
    .padding()
}
