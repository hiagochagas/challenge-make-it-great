//
//  Badge+CoreDataClass.swift
//  MakeItGreat
//
//

import Foundation
import CoreData
import UIKit

@objc(Badge)
public class Badge: NSManagedObject {
    static func initBadges(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let model = AchievementsViewModel(context: viewContext)
        //10 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "10 tasks done", icon: UIImage(named: "10TasksNotDone")?.pngData() ?? Data(), name: "10 tasks badge", progress: 0, unlockValue: 10, status: false, viewContext: viewContext)
        //30 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "30 tasks done", icon: UIImage(named: "30TasksNotDone")?.pngData() ?? Data(), name: "30 tasks badge", progress: 0, unlockValue: 30, status: false, viewContext: viewContext)
        //50 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "50 tasks done", icon: UIImage(named: "50TasksNotDone")?.pngData() ?? Data(), name: "50 tasks badge", progress: 0, unlockValue: 50, status: false, viewContext: viewContext)
        //100 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "100 tasks done", icon: UIImage(named: "100TasksNotDone")?.pngData() ?? Data(), name: "100 tasks badge", progress: 0, unlockValue: 100, status: false, viewContext: viewContext)
        //300 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "300 tasks done", icon: UIImage(named: "300TasksNotDone")?.pngData() ?? Data(), name: "300 tasks badge", progress: 0, unlockValue: 300, status: false, viewContext: viewContext)
        //999 tasks badge
        _ = model.createBadge(id: UUID(), descriptionBadge: "999 tasks done", icon: UIImage(named: "999TasksNotDone")?.pngData() ?? Data(), name: "999 tasks badge", progress: 0, unlockValue: 999, status: false, viewContext: viewContext)
    }
    static func fetchAllBadges(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Badge] {
        let request : NSFetchRequest<Badge> = Badge.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let badges = try? viewContext.fetch(request) else {
            return []
        }
        return badges
    }
}
