//
//  Task+CoreDataProperties.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 23/11/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var priority: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var status: Bool
    @NSManaged public var tags: String?
    @NSManaged public var finishedAt: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var lastMovedAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var project: Project?
    @NSManaged public var list: List?

}
