//
//  AchievementsView.swift
//  MakeItGreat
//

import UIKit

class AchievementView: UIView, ViewCode {
    
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Calendar", "Milestones"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .blueSecondaryColor
        segmentedControl.selectedSegmentTintColor = .blueActionColor
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blueActionColor]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        return segmentedControl
    }()
    
    let containerView:UIView = {
        let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setViewHierarchy() {
        addSubview(segmentedControl)
        addSubview(containerView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            segmentedControl.widthAnchor.constraint(equalToConstant: 216),
            containerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 24)

        ])
        
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewCode()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
