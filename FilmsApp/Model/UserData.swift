//
//  UserData.swift
//  FilmsApp
//
//  Created by Владимир Царь on 14.11.2025.
//

import Foundation

struct UserData: Identifiable {
    var id: String = UUID().uuidString
    let email: String
    let password: String
    var name: String?
}
