//
//  Film+CoreDataClass.swift
//  FilmsApp
//
//  Created by Владимир Царь on 21.11.2025.
//
//

import Foundation
import CoreData

@objc(Film)
public class Film: NSManagedObject {

}

extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var id: String?
    @NSManaged public var year: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var image: String?

}

extension Film : Identifiable {
    func deleteFilm() {
        managedObjectContext?.delete(self)
        try? managedObjectContext?.save()
    }
}
