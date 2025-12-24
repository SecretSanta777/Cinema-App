//
//  NetworkError.swift
//  FilmsApp
//
//  Created by Владимир Царь on 16.11.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case movieNotFound
    case decodingError
}
