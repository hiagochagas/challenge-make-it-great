//
//  CoreDataTest.swift
//  MakeItGreatTests
//

import XCTest
import CoreData
@testable import MakeItGreat

class HomeViewModelTest: XCTestCase {
    var sut: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        sut = HomeViewModel(container: mockPersistantContainer)
        initStubs()
    }
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func test_create_task() {
        let tasksBeforeChanges = sut.fetchAllTasks(viewContext: mockPersistantContainer.viewContext)
        _ = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext)
        let tasksAfterChanges = sut.fetchAllTasks(viewContext: mockPersistantContainer.viewContext)
        
        XCTAssertEqual(tasksBeforeChanges.count, tasksAfterChanges.count - 1)
    }
    
    func test_fetch_all_lists() {
        sut.insertTaskToList(task: sut.createTask(name: "1", viewContext: mockPersistantContainer.viewContext)!, list: .Inbox)
        sut.insertTaskToList(task: sut.createTask(name: "2", viewContext: mockPersistantContainer.viewContext)!, list: .Inbox)
        sut.insertTaskToList(task: sut.createTask(name: "3", viewContext: mockPersistantContainer.viewContext)!, list: .Next)
        sut.insertTaskToList(task: sut.createTask(name: "4", viewContext: mockPersistantContainer.viewContext)!, list: .Maybe)
        sut.insertTaskToList(task: sut.createTask(name: "5", viewContext: mockPersistantContainer.viewContext)!, list: .Waiting)
        let _ = sut.fetchAllLists(viewContext: mockPersistantContainer.viewContext)
        XCTAssertEqual(sut.inbox?.tasks?.count, 2)
        XCTAssertEqual(sut.waiting?.tasks?.count, 1)
        XCTAssertEqual(sut.next?.tasks?.count, 1)
        XCTAssertEqual(sut.maybe?.tasks?.count, 1)
    }
    
    func test_insert_task_into_list() {
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        var countBeforeChanges = sut.inbox?.tasks?.count ?? 0
        sut.insertTaskToList(task: task, list: .Inbox)
        var countAfterChanges = sut.inbox?.tasks?.count ?? 0
        XCTAssertTrue(countBeforeChanges == countAfterChanges - 1)
        countBeforeChanges = sut.next?.tasks?.count ?? 0
        sut.insertTaskToList(task: task, list: .Next)
        countAfterChanges = sut.next?.tasks?.count ?? 0
        XCTAssertTrue(countBeforeChanges == countAfterChanges - 1)
        countBeforeChanges = sut.waiting?.tasks?.count ?? 0
        sut.insertTaskToList(task: task, list: .Waiting)
        countAfterChanges = sut.waiting?.tasks?.count ?? 0
        XCTAssertTrue(countBeforeChanges == countAfterChanges - 1)
        countBeforeChanges = sut.maybe?.tasks?.count ?? 0
        sut.insertTaskToList(task: task, list: .Maybe)
        countAfterChanges = sut.maybe?.tasks?.count ?? 0
        XCTAssertTrue(countBeforeChanges == countAfterChanges - 1)
    }
    
    func test_get_list() {
        let list = sut.getList(list: .Inbox)
        XCTAssertNotNil(list)
        let list2 = sut.getList(list: .Maybe)
        XCTAssertNotNil(list2)
        let list3 = sut.getList(list: .Waiting)
        XCTAssertNotNil(list3)
        let list4 = sut.getList(list: .Next)
        XCTAssertNotNil(list4)
    }
    
    func test_remove_task_from_list() {
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToList(task: task, list: .Inbox)
        var listBeforeRemoving = sut.inbox?.tasks?.count ?? 0
        sut.removeTaskFromList(task: task, context: mockPersistantContainer.viewContext)
        var listAfterRemoving = sut.inbox?.tasks?.count ?? 0
        XCTAssertTrue(listBeforeRemoving == listAfterRemoving + 1)
        
        guard let task2 = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToList(task: task2, list: .Next)
        listBeforeRemoving = sut.next?.tasks?.count ?? 0
        sut.removeTaskFromList(task: task2, context: mockPersistantContainer.viewContext)
        listAfterRemoving = sut.next?.tasks?.count ?? 0
        XCTAssertTrue(listBeforeRemoving == listAfterRemoving + 1)
        
        guard let task3 = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToList(task: task3, list: .Maybe)
        listBeforeRemoving = sut.maybe?.tasks?.count ?? 0
        sut.removeTaskFromList(task: task3, context: mockPersistantContainer.viewContext)
        listAfterRemoving = sut.maybe?.tasks?.count ?? 0
        XCTAssertTrue(listBeforeRemoving == listAfterRemoving + 1)
        
        guard let task4 = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToList(task: task4, list: .Waiting)
        listBeforeRemoving = sut.waiting?.tasks?.count ?? 0
        sut.removeTaskFromList(task: task4, context: mockPersistantContainer.viewContext)
        listAfterRemoving = sut.waiting?.tasks?.count ?? 0
        XCTAssertTrue(listBeforeRemoving == listAfterRemoving + 1)
    }
    
    func test_update_task() {
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        let nameAfterEditing = "Task Updated"
        sut.updateTask(task: task, name: nameAfterEditing, finishedAt: Date(), lastMovedAt: Date(), priority: 3, status: false, tags: "", viewContext: mockPersistantContainer.viewContext)
        XCTAssertTrue(task.name == nameAfterEditing)
    }
    
    func test_create_project() {
        let projectsBeforeChanges = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext)
        _ = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project Created for Tests")
        let projectsAfterChanges = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext)
        XCTAssertEqual(projectsBeforeChanges.count, projectsAfterChanges.count - 1)
    }
    
    func test_fetch_projects() {
        let projectsBeforeChanges = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext).count
        _ = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "1")
        _ = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "2")
        let projectsAfterChanges = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext).count
        XCTAssertFalse(projectsAfterChanges == projectsBeforeChanges)
    }
    
    func test_update_project() {
        guard let project = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project For Tasks") else {return}
        let nameAfterEditing = "NameAfterEditing"
        sut.updateProject(viewContext: mockPersistantContainer.viewContext, project: project, name: "NameAfterEditing", status: true, movedAt: Date(), finishedAt: Date())
        XCTAssertTrue(nameAfterEditing == project.name)
    }
    
    func test_delete_project() {
        _ = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project Created for Tests")
        guard let secondProject = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project Created for Tests") else { return }
        let countBeforeDeleting = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext).count
        sut.deleteProject(viewContext: mockPersistantContainer.viewContext, project: secondProject)
        let countAfterDeleting = sut.fetchProjects(viewContext: mockPersistantContainer.viewContext).count
        XCTAssertFalse(countAfterDeleting == countBeforeDeleting)
    }
    
    func test_insert_task_into_project() {
        guard let project = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project Created for Tests") else {return}
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToProject(task: task, project: project)
        XCTAssertTrue(project.tasks?.count ?? 0 > 0)
    }
    
    func test_delete_task_from_project() {
        guard let project = sut.createProject(viewContext: mockPersistantContainer.viewContext, name: "Project Created for Tests") else {return}
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        guard let task2 = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToProject(task: task, project: project)
        sut.insertTaskToProject(task: task2, project: project)
        sut.removeTaskFromProject(viewContext: mockPersistantContainer.viewContext, taskToDelete: task2)
        XCTAssertTrue(project.tasks?.count ?? 0 == 1)
    }
    
    func test_getNumberOfCells() {
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        sut.insertTaskToList(task: task, list: .Inbox)
        var tasks = sut.inbox?.tasks?.count ?? 0
        var numberOfCells = sut.getNumberOfCells(from: .Inbox, context: mockPersistantContainer.viewContext)
        XCTAssertTrue(tasks == numberOfCells - 1)
        
        sut.insertTaskToList(task: task, list: .Next)
        tasks = sut.next?.tasks?.count ?? 0
        numberOfCells = sut.getNumberOfCells(from: .Next, context: mockPersistantContainer.viewContext)
        XCTAssertTrue(tasks == numberOfCells - 1)
        
        sut.insertTaskToList(task: task, list: .Maybe)
        tasks = sut.maybe?.tasks?.count ?? 0
        numberOfCells = sut.getNumberOfCells(from: .Maybe, context: mockPersistantContainer.viewContext)
        XCTAssertTrue(tasks == numberOfCells - 1)
        
        sut.insertTaskToList(task: task, list: .Waiting)
        tasks = sut.waiting?.tasks?.count ?? 0
        numberOfCells = sut.getNumberOfCells(from: .Waiting, context: mockPersistantContainer.viewContext)
        XCTAssertTrue(tasks == numberOfCells - 1)
    }
    
    //MARK: mock in-memory persistant store
      lazy var managedObjectModel: NSManagedObjectModel = {
          let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
          return managedObjectModel
      }()
      
      lazy var mockPersistantContainer: NSPersistentContainer = {
          
          let container = NSPersistentContainer(name: "MakeItGreatTest", managedObjectModel: self.managedObjectModel)
          let description = NSPersistentStoreDescription()
          description.type = NSInMemoryStoreType
          description.shouldAddStoreAsynchronously = false // Make it simpler in test env
          
          container.persistentStoreDescriptions = [description]
          container.loadPersistentStores { (description, error) in
              // Check if the data store is in memory
              precondition( description.type == NSInMemoryStoreType )

              // Check if creating container wrong
              if let error = error {
                  fatalError("Create an in-mem coordinator failed \(error)")
              }
          }
          return container
      }()
}

extension HomeViewModelTest {
    func initStubs() {
        func insertListItem(id: UUID = UUID(), name: String) -> List? {
            let listItem = NSEntityDescription.insertNewObject(forEntityName: "List", into: mockPersistantContainer.viewContext)
            listItem.setValue(id, forKey: "id")
            listItem.setValue(name, forKey: "name")
            //listItem.setValue([], forKey: "tasks")
            return listItem as? List
        }
        
        sut.inbox = insertListItem(name: "Inbox")
        sut.waiting = insertListItem(name: "Waiting")
        sut.maybe = insertListItem(name: "Maybe")
        sut.next = insertListItem(name: "Next")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
    }
}
