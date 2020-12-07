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
        homeCoordinator.tabBarCoordinator = self
        tabBarController.delegate = self
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBarController.tabBar.tintColor = .blueActionColor
        homeCoordinator.homeViewController = setupVc(viewController: homeCoordinator.homeViewController, image: UIImage(systemName: "list.bullet.rectangle")!, title: "Lists") as! HomeViewController
        achievementsCoordinator.achievementsViewController = setupVc(viewController: achievementsCoordinator.achievementsViewController, image: UIImage(systemName: "calendar")!, title: "Progress") as! AchievementsViewController
        
        achievementsCoordinator.achievementsViewController.title = "Progress"
        tabBarController.viewControllers = [homeCoordinator.homeViewController, achievementsCoordinator.achievementsViewController]
        tabBarController.tabBar.isHidden = false
    }
    
    func setupVc(viewController: UIViewController, image: UIImage, title: String) -> UIViewController {
            viewController.tabBarItem.image = image
            viewController.tabBarItem.selectedImage = image
            viewController.tabBarItem.image?.withRenderingMode(.alwaysOriginal)
            viewController.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            viewController.title = title
        return viewController
    }
    
    func reloadCalendar() {
        achievementsCoordinator.reloadCalendar()
    }
}
