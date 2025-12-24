//
//  TextFieldExt.swift
//  FilmsApp
//
//  Created by Владимир Царь on 17.11.2025.
//

import UIKit

extension MainView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let address = textField.text, !address.isEmpty{
            viewModel.fetchData()
        }
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
}
