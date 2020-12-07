//
//  HomeViewModel+Facade.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 27/11/20.
//

import UIKit
import CoreData

enum GhostCellResponse {
    case projectGhost
    case subtaskGhost
}

extension HomeViewModel {
    func getNumberOfCells(from list: EnumLists, context: NSManagedObjectContext = context) -> Int {
        fetchAllLists(viewContext: context)
        var numberOfCells = 0
        switch list {
        case .Inbox:
            numberOfCells = sortedInbox?.count ?? 0
        case .Maybe:
            numberOfCells = sortedMaybe?.count ?? 0
        case .Next:
            numberOfCells = sortedNext?.count ?? 0
        case .Waiting:
            numberOfCells = sortedWaiting?.count ?? 0
        case .Projects:
            numberOfCells = sortedProjects?.count ?? 0
        }
        // returns one extra cell for presenting the ghost cell
        return numberOfCells + 1
    }
    
    func isGhostCell(list: EnumLists, at index: Int) -> Bool {
        switch list {
        case .Inbox:
            return index == (sortedInbox?.count ?? 0)
        case .Maybe:
            return index == (sortedMaybe?.count ?? 0)
        case .Next:
            return index == (sortedNext?.count ?? 0)
        case .Waiting:
            return index == (sortedWaiting?.count ?? 0)
        case .Projects:
            return index == (sortedProjects?.count ?? 0)
        }
    }
    
    func getTaskList(list: EnumLists) -> [Task] {
        switch list {
        case .Inbox:
            return sortedInbox ?? []
        case .Maybe:
            return sortedMaybe ?? []
        case .Next:
            return sortedNext ?? []
        case .Waiting:
            return sortedWaiting ?? []
        case .Projects:
            return sortedProjects ?? []
        }
    }
    
    func toggleTaskById(id: UUID, context: NSManagedObjectContext = context) {
        let taskList = fetchAllTasks(viewContext: context)
        let task = taskList.filter({ $0.id == id }).first
        toggleTask(task: task!, context: context)
    }
    
    func toggleTask(task: Task, context: NSManagedObjectContext = context) {
        let name = task.name ?? ""
        task.status.toggle()
        let finishedAt = task.status ? Date() : task.finishedAt
        let lastMovedAt = task.lastMovedAt
        let priority = task.priority
        let status = task.status
        updateTask(task: task, name: name, finishedAt: finishedAt!, lastMovedAt: lastMovedAt!, priority: priority, status: status, viewContext: context)
    }
    
    func getLastCellIndexPath(list: EnumLists) -> IndexPath {
        switch list {
        case .Inbox:
            return IndexPath(row: sortedInbox?.count ?? 0, section: 0)
        case .Maybe:
            return IndexPath(row: sortedMaybe?.count ?? 0, section: 0)
        case .Next:
            return IndexPath(row: sortedNext?.count ?? 0, section: 0)
        case .Waiting:
            return IndexPath(row: sortedWaiting?.count ?? 0, section: 0)
        case .Projects:
            return IndexPath(row: sortedProjects?.count ?? 0, section: 0)
        }
    }
    
    func addNewTask(name: String, to list: EnumLists, context: NSManagedObjectContext = context) {
        guard let task = createTask(name: name, viewContext: context) else { return }
        insertTaskToList(task: task, list: list)
        save(context: context)
    }
    
    func deleteTask(at index: Int, from list: EnumLists, context: NSManagedObjectContext = context) {
        switch list {
        case .Inbox:
            guard let task = sortedInbox?[index] else { return }
            removeTaskFromList(task: task, context: context)
        case .Maybe:
            guard let task = sortedMaybe?[index] else { return }
            removeTaskFromList(task: task, context: context)
        case .Next:
            guard let task = sortedNext?[index] else { return }
            removeTaskFromList(task: task, context: context)
        case .Waiting:
            guard let task = sortedWaiting?[index] else { return }
            removeTaskFromList(task: task, context: context)
        case .Projects:
            guard let task = sortedProjects?[index] else { return }
            removeTaskFromList(task: task, context: context)
        }
    }
    
}
