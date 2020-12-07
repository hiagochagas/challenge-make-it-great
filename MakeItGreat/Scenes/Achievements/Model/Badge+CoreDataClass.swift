//
//  Badge+CoreDataClass.swift
//  MakeItGreat
//
//

import Foundation
import CoreData

@objc(Badge)
public class Badge: NSManagedObject {
    
    static func fetchAllBadges(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [Badge] {
        let request : NSFetchRequest<Badge> = Badge.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let badges = try? viewContext.fetch(request) else {
            return []
        }
        return badges
    }
}
