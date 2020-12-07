//
//  HomeViewModel.swift
//  MakeItGreat
//
enum EnumLists {
    case Inbox
    case Waiting
    case Next
    case Maybe
    case Projects
}

import Foundation
import UIKit
import CoreData

class ProjectViewModel {
    var project: Project
    var tasks: [Task] {
        project.getTasks()
    }
    var tasksRows: [Int] = []
    var projectRow: Int
    var totalCells: Int {
        return 1 + tasks.count
    }
    
    init(project: Project, projectRow: Int) {
        self.project = project
        self.projectRow = projectRow
    }
}

class HomeViewModel {
    //lists
    var inbox: List? {
        didSet {
            sortedInbox = inbox?.tasks?.allObjects as? [Task]
            sortedInbox = sortedInbox?.sorted(by: { ( $0.createdAt ?? Date() < $1.createdAt ?? Date() ) })
            sortedInbox = sortedInbox?.filter({ $0.status != true })
        }
    }
    var waiting: List? {
        didSet {
            sortedWaiting = waiting?.tasks?.allObjects as? [Task]
            sortedWaiting = sortedWaiting?.sorted(by: { ( $0.createdAt ?? Date() < $1.createdAt ?? Date() ) })
            sortedWaiting = sortedWaiting?.filter({ $0.status != true })
        }
    }
    var next: List? {
        didSet {
            sortedNext = next?.tasks?.allObjects as? [Task]
            sortedNext = sortedNext?.sorted(by: { ( $0.createdAt ?? Date() < $1.createdAt ?? Date() ) })
            sortedNext = sortedNext?.filter({ $0.status != true })
        }
    }
    var projects: List? {
        didSet {
            sortedProjects = projects?.tasks?.allObjects as? [Task]
            sortedProjects = sortedProjects?.sorted(by: { ( $0.createdAt ?? Date() < $1.createdAt ?? Date() ) })
            sortedProjects = sortedProjects?.filter({ $0.status != true })
        }
    }
    var maybe: List? {
        didSet {
            sortedMaybe = maybe?.tasks?.allObjects as? [Task]
            sortedMaybe = sortedMaybe?.sorted(by: { ( $0.createdAt ?? Date() < $1.createdAt ?? Date() ) })
            sortedMaybe = sortedMaybe?.filter({ $0.status != true })
        }
    }
    
    
    //sorted lists
    var sortedInbox: [Task]?
    var sortedWaiting: [Task]?
    var sortedNext: [Task]?
    var sortedProjects: [Task]?
    var sortedMaybe: [Task]?
    
    //context
    static let context: NSManagedObjectContext = AppDelegate.viewContext
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer = AppDelegate.persistentContainer) {
        fetchAllLists(viewContext: container.viewContext)
        _ = fetchProjects(viewContext: container.viewContext)
    }
    
    func save(context: NSManagedObjectContext = context) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    //MARK:- Task Functions - Core Data
    func fetchAllTasks(viewContext: NSManagedObjectContext = context) -> [Task] {
        return Task.fetchAllTasks(viewContext: viewContext)
    }
    
    func createTask(id: UUID = UUID(), name: String, createdAt: Date = Date(), finishedAt: Date = Date(), lastMovedAt: Date = Date(), priority: Int64 = 0, status: Bool = false, tags: String = "", viewContext: NSManagedObjectContext = context) -> Task? {
        guard let taskItem = NSEntityDescription.insertNewObject(forEntityName: "Task", into: viewContext) as? Task else { return nil }
                taskItem.id = id
                taskItem.name = name
                taskItem.createdAt = createdAt
                taskItem.finishedAt = finishedAt
                taskItem.lastMovedAt = lastMovedAt
                taskItem.priority = priority
                taskItem.status = status
                taskItem.tags = tags
            save(context: viewContext)
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
        case .Projects:
            projects?.addToTasks(task)
        }
    }
    
    func insertTaskToProject(task: Task, project: Project) {
        project.addToTasks(task)
    }
    
    func removeTaskFromList(task taskToDelete: Task, context: NSManagedObjectContext = context) {
        let list = getListFromName(task: taskToDelete)
        guard let listOfTasks = list?.tasks else {return}
        for task in listOfTasks {
            if task as! NSObject == taskToDelete {
                list?.removeFromTasks(taskToDelete)
                context.delete(taskToDelete)
                save(context: context)
            }
        }
    }
    
    func removeTaskFromProject(viewContext: NSManagedObjectContext = context, taskToDelete: Task) {
        let project = taskToDelete.project
        guard let listOfTasks = project?.tasks else {return}
        for task in listOfTasks {
            if task as! NSObject == taskToDelete {
                project?.removeFromTasks(taskToDelete)
                viewContext.delete(taskToDelete)
                save(context: viewContext)
            }
        }
    }
    
    func updateTask(task: Task, name: String, finishedAt: Date, lastMovedAt: Date, priority: Int64, status: Bool, tags: String = "", viewContext: NSManagedObjectContext = context) {
        task.finishedAt = finishedAt
        task.lastMovedAt = lastMovedAt
        task.priority = priority
        task.status = status
        task.tags = tags
        task.name = name
        save(context: viewContext)
    }
    
    //MARK:- List Function - Core Data
    func fetchAllLists(viewContext: NSManagedObjectContext = context) {
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
            case "Projects":
                projects = list
            default:
                print("Nada acontece")
            
            }
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
        case .Projects:
            return self.projects
        }
    }
    
    private func getListFromName(task: Task) -> List? {
        let listName = task.list?.name
        switch listName {
        case "Inbox":
            return getList(list: .Inbox)
        case "Maybe":
            return getList(list: .Maybe)
        case "Next":
            return getList(list: .Next)
        case "Waiting":
            return getList(list: .Waiting)
        case "Projects":
            return getList(list: .Projects)
        default:
            return nil
        }
    }
    //MARK:- Project Functions - Core Data
    
    func createProject(viewContext: NSManagedObjectContext = context, name: String, status: Bool = false) -> Project?{
        guard let projectItem = NSEntityDescription.insertNewObject(forEntityName: "Project", into: viewContext) as? Project else { return nil }
        projectItem.id = UUID()
        projectItem.name = name
        projectItem.createdAt = Date()
        projectItem.movedAt = Date()
        //self.projects?.append(projectItem)
        save(context: viewContext)
        return projectItem
    }
    
    func fetchProjects(viewContext: NSManagedObjectContext = context) -> [Project] {
        let fetchResults = Project.fetchAllProjects(viewContext: viewContext)
        //self.projects = fetchResults
        return fetchResults
    }
    
    func updateProject(viewContext: NSManagedObjectContext = context, project: Project, name: String, status: Bool, movedAt: Date, finishedAt: Date) {
        project.name = name
        project.status = status
        project.movedAt = movedAt
        project.finishedAt = finishedAt
        save(context: viewContext)
    }
    
    func deleteProject(viewContext: NSManagedObjectContext = context, project: Project) {
        project.tasks?.forEach{ viewContext.delete($0 as! NSManagedObject) }
        viewContext.delete(project)
        _ = fetchProjects(viewContext: viewContext)
    }
    
}


    

 
