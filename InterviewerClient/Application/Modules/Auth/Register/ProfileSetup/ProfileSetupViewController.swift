import UIKit
import SwiftUI

class ProfileSetupViewController: UIViewController {
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        let profileSetupView = ProfileSetupView(
            onBack: { [weak self] in self?.coordinator?.goBack() },
            onComplete: { [weak self] in self?.coordinator?.showKnowledgeLevel() }
        )

        let hostingController = UIHostingController(
            rootView: profileSetupView.environmentObject(UserProfileModel.shared)
        )

        addChild(hostingController)
        view.addSubview(hostingController.view) 
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}
