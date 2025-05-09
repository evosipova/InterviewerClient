import UIKit
import SwiftUI

class KnowledgeLevelViewController: UIViewController {
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        let knowledgeLevelView = KnowledgeLevelView(
            onBack: { [weak self] in self?.coordinator?.goBack() },
            onNext: { [weak self] in self?.coordinator?.showTabBar() }
        )

        let hostingController = UIHostingController(
            rootView: knowledgeLevelView.environmentObject(UserProfileModel.shared)
        )

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}
