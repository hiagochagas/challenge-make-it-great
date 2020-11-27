//
//  Badge+CoreDataProperties.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 26/11/20.
//
//

import Foundation
import CoreData


extension Badge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Badge> {
        return NSFetchRequest<Badge>(entityName: "Badge")
    }

    @NSManaged public var descriptionBadge: String?
    @NSManaged public var icon: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var progress: Int64

}
