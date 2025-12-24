//
//  TextFieldExtAnyPublisher.swift
//  FilmsApp
//
//  Created by Владимир Царь on 12.11.2025.
//

//import UIKit
//import Combine
//
//extension UITextField {
//    func textPublisher() -> AnyPublisher<String, Never> {
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: self)
//            .map { ($0.object as? UITextField)?.text ?? "" }
//            .eraseToAnyPublisher()
//    }
//}
