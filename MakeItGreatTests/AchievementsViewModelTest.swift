//
//  File.swift
//  MakeItGreatTests
//
//  Created by Jhennyfer Rodrigues de Oliveira on 26/11/20.
//

import Foundation
import CoreData
import XCTest
@testable import MakeItGreat

class AchievementsViewModelTest: XCTestCase {
    var sut: AchievementsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = AchievementsViewModel(context: mockPersistantContainer.viewContext)
    }

    func test_create_badge() {
        let badgesBeforeAdding = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        _ = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "badge1", progress: 10, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext)
        let badgesAfterAdding = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        
        XCTAssertTrue(badgesBeforeAdding.count == badgesAfterAdding.count - 1 )
    }
    
    func test_update_badge_progress() {
        let progressBeforeUpdate: Int64 = 3
        guard var badge = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "badge1", progress: progressBeforeUpdate, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext) else { return }
        badge = sut.updateBadgeProgress(badge: badge, progress: 5, viewContext: mockPersistantContainer.viewContext) ?? Badge()
        XCTAssertFalse(progressBeforeUpdate == badge.progress)
    }
    
    func test_update_badge() {
        guard let badge = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "badge1", progress: 5, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext) else {return}
        let badgeAfterUpdate = sut.updateBadge(badge: badge, name: "5 tasks", icon: Data(), descriptionBadge: "badge", progress: 3, status: false, unlockValue: 10, viewContext: mockPersistantContainer.viewContext)
       XCTAssertFalse(badge == badgeAfterUpdate)
    }
    
    func test_delete_badge() {
        guard let badge = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "badge1", progress: 5, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext) else {return}
        let listBeforeDeleting = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        sut.deleteBadge(badge: badge, context: mockPersistantContainer.viewContext)
        let listAfterDeleting = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        XCTAssertFalse(listBeforeDeleting.count == listAfterDeleting.count)
    }
    
    func test_fetch_badge() {
        let listBeforeCreating = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        guard let _ = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "badge1", progress: 5, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext) else {return}
        let listAfterCreating = sut.fetchBadges(context: mockPersistantContainer.viewContext)
        XCTAssertTrue(listBeforeCreating.count == listAfterCreating.count - 1)
    }
    
    func test_unlock_badge() {
        guard let badge = sut.createBadge(descriptionBadge: "10 tasks", icon: Data(), name: "10", progress: 11, unlockValue: 10, status: false, viewContext: mockPersistantContainer.viewContext) else {return}
        sut.unlockBadge(badge: badge, context: mockPersistantContainer.viewContext)
        XCTAssertTrue(badge.status)
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
