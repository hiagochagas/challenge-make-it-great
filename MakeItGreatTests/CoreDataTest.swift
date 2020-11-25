//
//  CoreDataTest.swift
//  MakeItGreatTests
//

import XCTest
import CoreData
@testable import MakeItGreat

class CoreDataTest: XCTestCase {
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
        let _ = sut.fetchAllLists(viewContext: mockPersistantContainer.viewContext)
        XCTAssertEqual(sut.inbox?.tasks?.count, 2)
        XCTAssertEqual(sut.waiting?.tasks?.count, 1)
        XCTAssertEqual(sut.next?.tasks?.count, 1)
        XCTAssertEqual(sut.maybe?.tasks?.count, 1)
    }
    
    func test_insert_task_into_list() {
        guard let task = sut.createTask(name: "Task Created for Tests", viewContext: mockPersistantContainer.viewContext) else { return }
        let countBeforeChanges = sut.inbox?.tasks?.count ?? 0
        sut.insertTaskToList(task: task, list: .Inbox)
        let countAfterChanges = sut.inbox?.tasks?.count ?? 0
        XCTAssertTrue(countBeforeChanges == countAfterChanges - 1)
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

extension CoreDataTest {
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
        
        func insertTaskItem(id: UUID = UUID(), name: String, createdAt: Date = Date(), finishedAt: Date = Date(), lastMovedAt: Date = Date(), priority: Int64 = 0, status: Bool = false, tags: String = "") -> Task? {
            let taskItem = NSEntityDescription.insertNewObject(forEntityName: "Task", into: mockPersistantContainer.viewContext)
            taskItem.setValue(id, forKey: "id")
            taskItem.setValue(name, forKey: "name")
            taskItem.setValue(createdAt, forKey: "createdAt")
            taskItem.setValue(finishedAt, forKey: "finishedAt")
            taskItem.setValue(lastMovedAt, forKey: "lastMovedAt")
            taskItem.setValue(priority, forKey: "priority")
            taskItem.setValue(status, forKey: "status")
            taskItem.setValue(tags, forKey: "tags")
            return taskItem as? Task
        }
        
        sut.inbox?.addToTasks(insertTaskItem(name: "1", status: false)!)
        sut.maybe?.addToTasks(insertTaskItem(name: "2", status: false)!)
        sut.waiting?.addToTasks(insertTaskItem(name: "3", status: false)!)
        sut.next?.addToTasks(insertTaskItem(name: "4", status: false)!)
        sut.inbox?.addToTasks(insertTaskItem(name: "5", status: false)!)
        
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
