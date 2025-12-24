//
//  MainViewProtocol.swift
//  FilmsApp
//
//  Created by Владимир Царь on 16.11.2025.
//

import Foundation

protocol MainViewManagerProtocol {
    func fetchFilms(movieTitle: String) async throws -> [Movie]
}
