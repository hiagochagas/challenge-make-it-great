//
//  Task+CoreDataClass.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 23/11/20.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
    //fetch from Core Data
    static func fetchAllTasks(viewContext: NSManagedObjectContext = AppDelegate.viewContext, searchBarArgument: String = "") -> [Task] {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //the search bar predicate is here
        if(searchBarArgument != ""){
            request.predicate = NSPredicate(format: "name CONTAINS '\(searchBarArgument)'")
        }
        guard let Tasks = try? viewContext.fetch(request) else {
            return []
        }
        return Tasks
    }
}
