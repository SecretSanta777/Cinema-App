import Foundation

class StorageManager {
    
    private var path = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
    
    //MARK: Save cover
    
    func saveCover(filmId: String, cover: Data) {
        let bookPath = path.appending(component: filmId)
        try? FileManager.default.createDirectory(at: bookPath, withIntermediateDirectories: true)
        
        let coverPath = bookPath.appending(component: "cover.jpeg")
        
        do {
            try cover.write(to: coverPath)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCover(bookId: String) -> Data? {
        let coverPath = path
            .appending(component: bookId)
            .appending(component: "cover.jpeg")
        
        do {
            let coverData = try Data(contentsOf: coverPath)
            return coverData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
