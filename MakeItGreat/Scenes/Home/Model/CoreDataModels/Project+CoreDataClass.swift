//
//  Project+CoreDataClass.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 23/11/20.
//
//

import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    //fetch from Core Data
    static func fetchAllProjects(viewContext: NSManagedObjectContext = AppDelegate.viewContext, searchBarArgument: String = "") -> [Project] {
        let request : NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //the search bar predicate is here
        if(searchBarArgument != ""){
            request.predicate = NSPredicate(format: "name CONTAINS '\(searchBarArgument)'")
        }
        guard let Projects = try? viewContext.fetch(request) else {
            return []
        }
        return Projects
    }
}
