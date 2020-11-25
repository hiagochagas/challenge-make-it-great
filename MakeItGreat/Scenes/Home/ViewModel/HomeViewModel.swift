//
//  HomeViewModel.swift
//  MakeItGreat
//
enum EnumLists {
    case Inbox
    case Waiting
    case Next
    case Maybe
}

import Foundation
import UIKit
import CoreData

class HomeViewModel {
    //lists
    var inbox: List?
    var waiting: List?
    var next: List?
    var projects: [Project]?
    var maybe: List?
    
    let persistentContainer: NSPersistentContainer!

    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        fetchAllLists(viewContext: container.viewContext) 
    }

    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
        fetchAllLists(viewContext: persistentContainer.viewContext)
    }
    
    func fetchAllLists(viewContext: NSManagedObjectContext) {
        let fetchResults = List.fetchAllLists(viewContext: viewContext)
        for list in fetchResults {
            switch(list.name) {
            case "Inbox":
                inbox = list
            case "Waiting":
                waiting = list
            case "Next":
                next = list
            case "Maybe":
                maybe = list
            default:
                print("Nada acontece")
            
            }
        }
    }
    func fetchAllTasks(viewContext: NSManagedObjectContext) -> [Task] {
        return Task.fetchAllTasks(viewContext: viewContext)
    }
    
    func createTask(id: UUID = UUID(), name: String, createdAt: Date = Date(), finishedAt: Date = Date(), lastMovedAt: Date = Date(), priority: Int64 = 0, status: Bool = false, tags: String = "", viewContext: NSManagedObjectContext) -> Task? {
        guard let taskItem = NSEntityDescription.insertNewObject(forEntityName: "Task", into: viewContext) as? Task else { return nil }
                taskItem.id = id
                taskItem.name = name
                taskItem.createdAt = createdAt
                taskItem.finishedAt = finishedAt
                taskItem.lastMovedAt = lastMovedAt
                taskItem.priority = priority
                taskItem.status = status
                taskItem.tags = tags
            return taskItem
    }
    //After creating the task, please, insert it into its respective List
    func insertTaskToList(task: Task, list: EnumLists) {
        switch list {
        case .Inbox:
            inbox?.addToTasks(task)
        case .Maybe:
            maybe?.addToTasks(task)
        case .Next:
            next?.addToTasks(task)
        case .Waiting:
            waiting?.addToTasks(task)
        }
    }
    
    func getList(list: EnumLists) -> List? {
        switch list {
        case .Inbox:
            return self.inbox
        case .Maybe:
            return self.maybe
        case .Next:
            return self.next
        case .Waiting:
            return self.waiting
        }
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
}
 
