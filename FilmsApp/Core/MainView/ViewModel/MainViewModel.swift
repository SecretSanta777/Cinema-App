import Combine
import Foundation

@MainActor
class MainViewModel: ObservableObject {
    
    @Published var textField: String = ""
    @Published var result: [Movie] = []
    @Published var favorites: [String: Bool] = [:] // Словарь для избранного [imdbID: isFavorite]
    
    var networkManager: MainViewManagerProtocol
    
    init(networkManager: MainViewManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchData() {
        Task {
            let movies = try await networkManager.fetchFilms(movieTitle: textField)
            self.result = movies
        }
    }
    
    // Метод для переключения избранного (добавить/удалить)
    func toggleFavorite(movieId: String) {
        let currentlyFavorite = favorites[movieId] ?? false
        favorites[movieId] = !currentlyFavorite
        
        print("Фильм \(movieId) - \(currentlyFavorite ? "удален из" : "добавлен в") избранное")
    }
    
    // Проверка является ли фильм избранным
    func isFavorite(movieId: String) -> Bool {
        return favorites[movieId] ?? false
    }
    
    // Получить список избранных фильмов (опционально)
    var favoriteMovies: [Movie] {
        return result.filter { favorites[$0.imdbID] == true }
    }
}
