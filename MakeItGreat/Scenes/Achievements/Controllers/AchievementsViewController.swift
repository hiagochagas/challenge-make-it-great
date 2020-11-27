//
//  AchievementsViewController.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import UIKit

class AchievementsViewController: UIViewController {
    let contentView = AchievementView()
    let graphicsVC = GraphicsViewController()
    let badgesVC = BadgesViewController()
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        contentView.containerView.addSubview(badgesVC.view)
        contentView.containerView.addSubview(graphicsVC.view)
        contentView.segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
    }
    
    @objc func segmentedControlDidChange() {
        switch(contentView.segmentedControl.selectedSegmentIndex) {
        case 0:
            graphicsVC.view.isHidden = false
            badgesVC.view.isHidden = true
            break
        case 1:
            graphicsVC.view.isHidden = true
            badgesVC.view.isHidden = false
            break
        default:
            break
        }
    }
}
