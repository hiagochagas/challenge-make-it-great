//
//  AchievementsViewModel.swift
//  MakeItGreat
//
//

import Foundation
import CoreData
import UIKit

class AchievementsViewModel {
    
    var badges: [Badge]?
    
    init(context: NSManagedObjectContext){
        badges = fetchBadges(context: context)
    }
    
    func createBadge(id: UUID = UUID(), descriptionBadge: String, icon: Data, name: String, progress: Int64, unlockValue: Int64, status: Bool, viewContext: NSManagedObjectContext) -> Badge? {
        guard let badge = NSEntityDescription.insertNewObject(forEntityName: "Badge", into: viewContext) as? Badge else {return nil}
        badge.id = id
        badge.name = name
        badge.icon = icon
        badge.progress = progress
        badge.descriptionBadge = descriptionBadge
        badge.status = status
        badge.unlockValue = unlockValue
        save(context: viewContext)
        
        return badge
    }
    
    func updateBadge(badge: Badge, name: String, icon: Data, descriptionBadge: String, progress: Int64, status: Bool, unlockValue: Int64, viewContext: NSManagedObjectContext) -> Badge? {
        guard let badge = NSEntityDescription.insertNewObject(forEntityName: "Badge", into: viewContext) as? Badge else {return nil}
        badge.progress = progress
        badge.icon = icon
        badge.descriptionBadge = descriptionBadge
        badge.name = name
        badge.status = status
        badge.unlockValue = unlockValue
        save(context: viewContext)
        return badge
    }
    
    func updateBadgeProgress(badge: Badge, progress: Int64, viewContext: NSManagedObjectContext) -> Badge? {
        guard let badge = NSEntityDescription.insertNewObject(forEntityName: "Badge", into: viewContext) as? Badge else {return nil}
        badge.progress = progress
        save(context: viewContext)
        return badge
    }
    
    func fetchBadges(context: NSManagedObjectContext) -> [Badge]{
        let badges = Badge.fetchAllBadges(viewContext: context)
        return badges
    }
    
    func deleteBadge(badge: Badge, context: NSManagedObjectContext){
        context.delete(badge)
        self.badges = fetchBadges(context: context)
        save(context: context)
    }
    
    func unlockBadge(badge: Badge, context: NSManagedObjectContext) {
        if(badge.progress >= badge.unlockValue) {
            badge.status = true
        }
        save(context: context)
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
