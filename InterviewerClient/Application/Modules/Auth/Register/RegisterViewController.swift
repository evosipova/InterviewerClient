import UIKit
import SwiftUI

class RegisterViewController: UIViewController {
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        let registerView = RegisterView(
            onBack: { [weak self] in self?.coordinator?.goBack() },
            onNext: { [weak self] in self?.coordinator?.showProfileSetup() }
        )
        
        let hostingController = UIHostingController(rootView: registerView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
