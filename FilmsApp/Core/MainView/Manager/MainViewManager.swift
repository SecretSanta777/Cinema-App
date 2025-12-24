//  MainViewManager.swift
//  FilmsApp
//
//  Created by Владимир Царь on 16.11.2025.
//

import Foundation

class MainViewManager: MainViewManagerProtocol {
    
    private let apiKey = "14d95684"
    
    func fetchFilms(movieTitle: String) async throws -> [Movie] {
        // Кодируем название для URL и используем ПРАВИЛЬНЫЕ параметры
        let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? movieTitle
        
        // ИСПРАВЛЕННЫЙ URL: используем "s" для поиска, а не "t"
        guard let url = URL(string: "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(encodedTitle)") else {
            throw NetworkError.invalidURL
        }
        
        print("Запрос к URL: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let responseString = String(data: data, encoding: .utf8) ?? "Не удалось декодировать ответ"
        print("Ответ от сервера: \(responseString)")
        
        do {
            // Декодируем в SearchResponse, а не в [Movie]
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            
            if searchResponse.response == "True", let movies = searchResponse.search {
                print("Успешно найдено фильмов: \(movies.count)")
                return movies
            } else {
                print("Ошибка API: \(searchResponse.error ?? "Unknown error")")
                throw NetworkError.movieNotFound
            }
        } catch {
            print("Ошибка декодирования: \(error)")
            throw NetworkError.decodingError
        }
    }
}
