//
//  List+CoreDataClass.swift
//  MakeItGreat
//
//  Created by Jhennyfer Rodrigues de Oliveira on 23/11/20.
//
//

import Foundation
import CoreData

@objc(List)
public class List: NSManagedObject {
    
    static func initAllLists() {
        //lists mockup
        let inboxList = List(context: AppDelegate.viewContext)
            inboxList.name = "Inbox"
            inboxList.id = UUID()
        let waitingList = List(context: AppDelegate.viewContext)
            waitingList.name = "Waiting"
            waitingList.id = UUID()
        let nextList = List(context: AppDelegate.viewContext)
            nextList.name = "Next"
            nextList.id = UUID()
        let maybeList = List(context: AppDelegate.viewContext)
            maybeList.name = "Maybe"
            maybeList.id = UUID()
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print(error)
        }
    }
    static func fetchAllLists(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [List] {
        let request : NSFetchRequest<List> = List.fetchRequest()
        guard let Lists = try? viewContext.fetch(request) else {
            return []
        }
        return Lists
    }
}
