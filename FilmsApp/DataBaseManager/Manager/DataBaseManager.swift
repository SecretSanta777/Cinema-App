import Foundation
import CoreData

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    private init() { }
    
    var films: [Film] = []
    private let storageManager = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension DataBaseManager {
    //CRUD
    //MARK: Create Book
    func createFilm(year: String, title: String, type: String, image: String) {
        let bookID = UUID().uuidString
        let _: Film = {
            $0.id = bookID
            $0.year = year
            $0.title = title
            $0.type = type
            $0.image = image
            return $0
        }(Film(context: persistentContainer.viewContext))
        
        fetchFilms()
        
        saveContext()
        //storageManager.saveCover(bookId: bookID, cover: cover)
    }
    
    func fetchFilms() {
        let request = Film.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            let films = try persistentContainer.viewContext.fetch(request)
            
            self.films = films
        } catch {
            print(error.localizedDescription)
        }
    }
}
