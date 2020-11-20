//
//  TabBarCoordinator.swift
//  MakeItGreat
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator, UITabBarControllerDelegate {
    
    var rootViewController: UIViewController {
        return tabBarController
    }
    
    let tabBarController: TabBarController
    let homeCoordinator: HomeCoordinator
    let achievementsCoordinator: AchievementsCoordinator
    
    override init() {
        tabBarController = TabBarController()
        homeCoordinator = HomeCoordinator()
        achievementsCoordinator = AchievementsCoordinator()
        
        super.init()
        
        tabBarController.delegate = self
    }
}
