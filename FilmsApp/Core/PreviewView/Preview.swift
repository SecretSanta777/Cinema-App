//
//  OnboardingView.swift
//  FilmsApp
//
//  Created by Владимир Царь on 13.11.2025.
//

import UIKit
import Lottie

class PreviewView: UIViewController {
    
    private var authService = AuthService()
    
    lazy var animationView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "TV")
        lottie.frame = view.bounds
        lottie.contentMode = .scaleAspectFill
        lottie.loopMode = .repeat(2)
        return lottie
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(animationView)
        animationView.play { [weak self] completed in
            
            guard let self = self else { return }
            
            if authService.isLogin() {
                NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager: AppRoute.tabBarView])
            } else {
                NotificationCenter.default.post(name: .windowManager, object: nil, userInfo: [String.windowManager: AppRoute.registView])
            }
        }
    }
}
