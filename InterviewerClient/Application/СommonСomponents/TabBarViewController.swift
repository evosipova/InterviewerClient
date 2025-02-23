import UIKit
import SwiftUI

class TabBarViewController: UIViewController {
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        guard let coordinator = coordinator else {
            return
        }

        let tabBarView = TabBarView(coordinator: coordinator)
        let hostingController = UIHostingController(rootView: tabBarView.environmentObject(coordinator))

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
