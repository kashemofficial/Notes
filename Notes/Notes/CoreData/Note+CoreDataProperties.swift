//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Abul Kashem on 12/2/23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var rowImage: Data?
    @NSManaged public var rowAddDate: Date?
    @NSManaged public var body: String?

}

extension Note : Identifiable {

}
