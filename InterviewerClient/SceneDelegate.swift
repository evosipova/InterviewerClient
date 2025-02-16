import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        applyCustomBackButtonStyle()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func applyCustomBackButtonStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(
            UIImage(systemName: "chevron.backward")?
                .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)),
            transitionMaskImage: UIImage(systemName: "chevron.backward")
        )
        
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
