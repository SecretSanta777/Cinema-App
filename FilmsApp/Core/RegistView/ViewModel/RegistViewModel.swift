//
//  RegistViewModel.swift
//  FilmsApp
//
//  Created by Владимир Царь on 15.11.2025.
//

import Foundation

class RegistViewModel {
    
    let authService = AuthService()
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 6
    }
}
