import Foundation
import UIKit

class UserProfileModel: ObservableObject {
    @Published var email: String
    @Published var password: String
    @Published var fullName: String
    @Published var profileImage: UIImage?
    @Published var knowledgeLevel: String

    init(
        email: String = "",
        password: String = "",
        fullName: String = "",
        profileImage: UIImage? = nil,
        knowledgeLevel: String = "Junior"
    ) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.profileImage = profileImage
        self.knowledgeLevel = knowledgeLevel
    }

    static let shared = UserProfileModel()
}
