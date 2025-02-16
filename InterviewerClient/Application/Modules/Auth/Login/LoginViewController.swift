import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        let loginView = LoginView(onBack: { [weak self] in
            self?.coordinator?.goBack()
        })
        
        let hostingController = UIHostingController(rootView: loginView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
