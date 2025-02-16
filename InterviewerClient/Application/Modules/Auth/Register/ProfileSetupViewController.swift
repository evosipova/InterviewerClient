import UIKit
import SwiftUI

class ProfileSetupViewController: UIViewController {
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        let profileSetupView = ProfileSetupView(
            onBack: { [weak self] in self?.coordinator?.goBack() },
            onComplete: { [weak self] in print("Регистрация завершена!") }
        )
        
        let hostingController = UIHostingController(rootView: profileSetupView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
