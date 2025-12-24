//
//  SceneDelegate.swift
//  FilmsApp
//
//  Created by Владимир Царь on 12.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let authService = AuthService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        window?.rootViewController = PreviewView()
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowManager), name: .windowManager, object: nil)
    }
    
    @objc
    private func windowManager(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AppRoute],
              let windows = userInfo[.windowManager] else { return }
        
        let newViewController: UIViewController
        
        switch windows {
        case .preview:
            newViewController = PreviewView()
        case .registView:
            newViewController = Builder.makeRegistView()
        case .loginView:
            newViewController = Builder.makeLoginView()
        case .onBoarding:
            print("OnBoarding")
            return
        case .mainView:
            newViewController = Builder.makeMainView()
        case .tabBarView:
            newViewController = TabBarView()
        }
        
        // Просто добавьте эти 2 строки для анимации:
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = newViewController
        })
    }
}

enum AppRoute {
    case preview
    case registView
    case loginView
    case onBoarding
    case tabBarView
    case mainView
}
