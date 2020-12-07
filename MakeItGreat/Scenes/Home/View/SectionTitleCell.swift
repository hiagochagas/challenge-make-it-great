//
//  SectionTitleCell.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import Foundation
import UIKit

class ListCollectionViewCell: UICollectionViewCell, ViewCode {
    
    
    let listButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .blueActionColor
        return button
    }()
    
    let listLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Varta-Regular", size: 15)
        
        return label
    }()
    
    var isButtonSelected: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.roundCorners(view: self, corners: [.topLeft, .topRight], radius: 10)
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func markListButton() {
        
        listButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        self.backgroundColor = .white
    }
    
    public func unmarkListButton() {
        
        listButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        self.backgroundColor = .grayBackground
    }
    
    public func changeListButtonState() {
        
        let selected = isButtonSelected ?? false
        selected ? markListButton() : unmarkListButton()
    }
    
    public func selectCell() {
        
        self.isButtonSelected = true
        changeListButtonState()
    }
    
    public func deselectCell() {
        
        self.isButtonSelected = false
        changeListButtonState()
    }
    
    public func setListNameLabel(_ title: String) {
        
        listLabel.text = title
    }
    
    func setViewHierarchy() {
        
        contentView.addSubview(listButton)
        contentView.addSubview(listLabel)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            listButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            listButton.heightAnchor.constraint(equalToConstant: 20),
            listButton.widthAnchor.constraint(equalTo: listButton.heightAnchor),
            listButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            
            listLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            listLabel.topAnchor.constraint(equalTo: listButton.bottomAnchor, constant: 5),
            listLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}

extension UIView {
    
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        
    }
    
}
