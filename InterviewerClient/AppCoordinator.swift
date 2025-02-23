import UIKit
import SwiftUI

@MainActor
class AppCoordinator: ObservableObject {
    @Published var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.coordinator = self
        navigationController.setViewControllers([onboardingVC], animated: false)
    }
    
    func showLogin() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: true)
    }
    
    func showRegister() {
        let registerVC = RegisterViewController()
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func showProfileSetup() {
        let profileSetupVC = ProfileSetupViewController()
        profileSetupVC.coordinator = self
        navigationController.pushViewController(profileSetupVC, animated: true)
    }
    
    func showKnowledgeLevel() {
        let knowledgeLevelVC = KnowledgeLevelViewController()
        knowledgeLevelVC.coordinator = self
        navigationController.pushViewController(knowledgeLevelVC, animated: true)
    }
    
    func showTabBar() {
        let tabBarVC = TabBarViewController()
        tabBarVC.coordinator = self
        navigationController.setViewControllers([tabBarVC], animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
    
    func logout() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.coordinator = self
        navigationController.setViewControllers([onboardingVC], animated: true)
    }
}
