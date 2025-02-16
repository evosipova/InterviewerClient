import UIKit
import SwiftUI

class OnboardingViewController: UIViewController {
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        let onboardingView = OnboardingView(onLogin: { [weak self] in
            self?.coordinator?.showLogin()
        }, onRegister: { [weak self] in
            self?.coordinator?.showRegister()
        })
        
        let hostingController = UIHostingController(rootView: onboardingView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}

