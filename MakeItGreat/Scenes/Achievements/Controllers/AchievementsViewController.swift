//
//  AchievementsViewController.swift
//  MakeItGreat
//

import UIKit
import FSCalendar

class AchievementsViewController: UIViewController {
    let contentView = AchievementView()
    let graphicsVC = GraphicsViewController()
    let badgesVC = BadgesViewController()
    
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        add(asChildViewController: graphicsVC)
        add(asChildViewController: badgesVC)
        contentView.segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        graphicsVC.contentView.calendar.delegate = self
        graphicsVC.contentView.calendar.dataSource = self

        setupView()
//        contentView.containerView.backgroundColor = .red
    }
    
    func setupView() {
        updateView()
    }
    
    @objc func segmentedControlDidChange() {
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        contentView.containerView.addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = contentView.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    private func updateView() {
        if contentView.segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: badgesVC)
            add(asChildViewController: graphicsVC)
        } else {
            remove(asChildViewController: graphicsVC)
            add(asChildViewController: badgesVC)
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }

}

extension AchievementsViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}
