import Foundation
import UIKit

struct UserStatsModel: Identifiable {
    let id = UUID()
    let name: String
    let correctAnswers: Int
    let totalTime: Int
    let profileImage: UIImage? 
}
