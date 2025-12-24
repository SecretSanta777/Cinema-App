//
//  Builder.swift
//  FilmsApp
//
//  Created by Владимир Царь on 12.11.2025.
//

import Foundation
import UIKit

class Builder {
    @MainActor
    static func makeMainView() -> UIViewController {
        let mainViewModel = MainViewModel(networkManager: MainViewManager())
        return MainView(viewModel: mainViewModel)
    }
    
    static func makeLoginView() -> UIViewController {
        let loginViewModel = LoginViewModel()
        return LoginView(viewModel: loginViewModel)
    }
    
    static func makeRegistView() -> UIViewController {
        let registViewModel = RegistViewModel()
        return RegistView(viewModel: registViewModel)
    }
    
    static func makeMapView() -> UIViewController {
        let mapViewModel = MapViewModel()
        return MapView(viewModel: mapViewModel)
    }
}
