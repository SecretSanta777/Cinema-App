//
//  LoginViewModel.swift
//  FilmsApp
//
//  Created by Владимир Царь on 15.11.2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    var authService: AuthService = .init()
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 6
    }
    
}
