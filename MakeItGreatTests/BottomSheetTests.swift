//
//  BottomSheetTests.swift
//  MakeItGreatTests
//
//  Created by Jhennyfer Rodrigues de Oliveira on 08/12/20.
//

import Foundation
import XCTest
import CoreData
@testable import MakeItGreat

class BottomSheetTests: XCTestCase {
    let sut = BottomSheetViewController()
    var homeModel = HomeViewModel()
    
    override func setUp() {
        super.setUp()
        homeModel = HomeViewModel(container: mockPersistantContainer)
        initStubs()
    }
    
    func test_configPriority() {
        let bottomSheet = BottomSheetView()
        
        let greenButton: UIButton = bottomSheet.greenButton
        sut.greenButton = greenButton
        
        let redButton: UIButton = bottomSheet.redButton
        sut.redButton = redButton
        
        let yellowButton: UIButton = bottomSheet.yellowButton
        sut.yellowButton = yellowButton
        
        let task1 = homeModel.createTask(name: "testTask", priority: 1, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task1
        sut.configPriority()
        XCTAssertTrue((((sut.greenButton?.isSelected)) != nil))
        
        let task2 = homeModel.createTask(name: "testTask", priority: 2, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task2
        sut.configPriority()
        XCTAssertTrue((((sut.yellowButton?.isSelected)) != nil))
        
        let task3 = homeModel.createTask(name: "testTask", priority: 3, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task3
        sut.configPriority()
        XCTAssertTrue(((((sut.redButton?.isSelected))) != nil))
    }
    
    
    func test_configTextFieldPicker() {
        
        let bottomSheet = BottomSheetView()
        let task = homeModel.createTask(name: "testTaska", viewContext: mockPersistantContainer.viewContext)
        homeModel.insertTaskToList(task: task ?? Task(), list: .Inbox, viewContext: mockPersistantContainer.viewContext)
        let textField: UITextField = bottomSheet.textFieldTaskTitle
        let textFieldPicker: UITextField = bottomSheet.textFieldPicker

        sut.pickerTextField = textFieldPicker
        sut.taskNameTextField = textField
        
        sut.task = task
        sut.configTextFieldPicker()
        XCTAssertTrue(sut.list == .Inbox)
        
        
        let task2 = homeModel.createTask(name: "testTask2", viewContext: mockPersistantContainer.viewContext)
        homeModel.insertTaskToList(task: task2 ?? Task(), list: .Next, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task2
        sut.configTextFieldPicker()
        XCTAssertTrue(sut.list == .Next)
        
        let task3 = homeModel.createTask(name: "testTask3", viewContext: mockPersistantContainer.viewContext)
        homeModel.insertTaskToList(task: task3 ?? Task(), list: .Waiting, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task3
        sut.configTextFieldPicker()
        XCTAssertTrue(sut.list == .Waiting)
        
        let task4 = homeModel.createTask(name: "testTask4", viewContext: mockPersistantContainer.viewContext)
        homeModel.insertTaskToList(task: task4 ?? Task(), list: .Projects, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task4
        sut.configTextFieldPicker()
        XCTAssertTrue(sut.list == .Projects)
        
        let task5 = homeModel.createTask(name: "testTask5", viewContext: mockPersistantContainer.viewContext)
        homeModel.insertTaskToList(task: task5 ?? Task(), list: .Maybe, viewContext: mockPersistantContainer.viewContext)
        
        sut.task = task5
        sut.configTextFieldPicker()
        XCTAssertTrue(sut.list == .Maybe)
    }
    
    func test_checkPriorityButton() {
        let bottomSheet = BottomSheetView()
        
        let greenButton: UIButton = bottomSheet.greenButton
        sut.greenButton = greenButton
        
        let redButton: UIButton = bottomSheet.redButton
        sut.redButton = redButton
        
        let yellowButton: UIButton = bottomSheet.yellowButton
        sut.yellowButton = yellowButton
        
        sut.checkPriorityButton(greenButton)
        XCTAssertTrue(sut.priority == 1)
        
        sut.checkPriorityButton(yellowButton)
        XCTAssertTrue(sut.priority == 2)
        
        sut.checkPriorityButton(redButton)
        XCTAssertTrue(sut.priority == 3)

    }
    
    func initStubs() {
        func insertListItem(id: UUID = UUID(), name: String) -> List? {
            let listItem = NSEntityDescription.insertNewObject(forEntityName: "List", into: mockPersistantContainer.viewContext)
            listItem.setValue(id, forKey: "id")
            listItem.setValue(name, forKey: "name")
            //listItem.setValue([], forKey: "tasks")
            return listItem as? List
        }
        
        homeModel.inbox = insertListItem(name: "Inbox")
        homeModel.waiting = insertListItem(name: "Waiting")
        homeModel.maybe = insertListItem(name: "Maybe")
        homeModel.next = insertListItem(name: "Next")
        homeModel.projects = insertListItem(name: "Projects")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func test_checkIsSelected() {
        let button = UIButton()
        button.isSelected = true
        var result = sut.checkIsSelected(button: button)
        XCTAssertTrue(result == false)
        
        button.isSelected = false
        result = sut.checkIsSelected(button: button)
        XCTAssertTrue(result == true)
    }
    
//    func test_saveButton() {
//        let bottomSheet = BottomSheetView()
//        let task3 = homeModel.createTask(name: "testTask3", viewContext: mockPersistantContainer.viewContext)
//        homeModel.insertTaskToList(task: task3 ?? Task(), list: .Waiting, viewContext: mockPersistantContainer.viewContext)
//        
//        let saveButton: UIButton = bottomSheet.saveButton
//        let textField: UITextField = bottomSheet.textFieldTaskTitle
//        let tagtextField: UITextField = bottomSheet.textFieldTag
//        
//        tagtextField.text = "sometag"
//        textField.text = "taskchanged"
//        
//        sut.task = task3
//        sut.tagTextField = tagtextField
//        sut.taskNameTextField?.text = textField.text
//
//        sut.saveButton(saveButton)
//        
//        let tasks = homeModel.fetchAllTasks(viewContext: mockPersistantContainer.viewContext)
//        print(tasks)
//        
//        var nameTaskAfterUpdate = ""
//        for task in tasks {
//            if task.name == sut.taskNameTextField?.text{
//                nameTaskAfterUpdate = task.name ?? ""
//            }
//        }
//        
//        XCTAssertTrue(nameTaskAfterUpdate == sut.taskNameTextField?.text)
//    }
    
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
