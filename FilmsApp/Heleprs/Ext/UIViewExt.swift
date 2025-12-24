//
//  UIViewExt.swift
//  FilmsApp
//
//  Created by Владимир Царь on 12.11.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
