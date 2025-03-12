import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        let loginView = LoginView(
            onBack: { [weak self] in
                self?.coordinator?.goBack()
            },
            onNext: { [weak self] in
                // Успешный логин → показываем TabBar
                self?.coordinator?.showTabBar()
            }
        )

        let hostingController = UIHostingController(rootView: loginView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
