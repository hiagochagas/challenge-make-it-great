//
//  List+CoreDataProperties.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 23/11/20.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension List {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
