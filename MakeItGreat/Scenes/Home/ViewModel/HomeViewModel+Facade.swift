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
        }
        // returns one extra cell for presenting the ghost cell
        return numberOfCells + 1
    }
    
    func getNumberOfCellsFromProjects(context: NSManagedObjectContext = context) -> Int {
        _ = fetchProjects(viewContext: context)
        guard let projects = sortedProjects else { return 1 }
        var cells = 1
        for item in projects {
            cells += 1
            for _ in item.project.getTasks() {
                cells += 1
            }
            cells += 1
        }
        return cells
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
        }
    }
    
    func isGhostCellInProject(at index: Int) -> (Bool, Bool) {
        // Primeiro Bool -> é Ghost?
        // Segundo Bool -> é ghost de projeto?                
        // caso de ser antes de um projeto, então é de task
        if arrayOfProjectsIndexes.contains(index + 1) {
            return (true, false)
        }
        
        // caso de vazio, retorna só uma de projeto
        if arrayOfProjectsIndexes.count == 0 {
            return (true, true)
        }
        
        if arrayOfProjectsIndexes.count == 1 && arrayOfProjectsIndexes[0] == index - 1 {
            return (true, false)
        }
        
        // caso do último da lista, retorna uma de projeto
        if index == arrayOfProjectsIndexes.last! + 2 {
            return (true, true)
        }
        
        if index == arrayOfProjectsIndexes.last! + 1 {
            return (true, false)
        }
        
        return (false, false)
    }
    
    func getTaskInfoFromProject(at index: Int) -> Task? {
        _ = fetchProjects()
        let projectIndex = arrayOfProjectsIndexes.filter({ $0 < index }).last
        let position = arrayOfProjectsIndexes.firstIndex(of: projectIndex!)
        let task = sortedProjects?[position!].project.getTasks()[index - projectIndex! - 1]
        
        return task
    }
    
    func getProjectFromIndex(_ index: Int) -> Project? {
        let projectIndex = arrayOfProjectsIndexes.firstIndex(of: index)
        return sortedProjects?[projectIndex!].project
    }
    
    func getRelatedProjectFromGhostCell(at index: Int) -> Project? {
        
        let projectsIndexes = arrayOfProjectsIndexes

        if index != 0 {
            for i in 0..<projectsIndexes.count {
                if projectsIndexes[i] > index {
                    return sortedProjects?[i-1].project
                }
            }
        }
        
        return nil
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
        }
    }
    
}
