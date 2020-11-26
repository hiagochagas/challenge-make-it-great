//
//  SectionTitleCell.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 20/11/20.
//

import Foundation
import UIKit

class ListCollectionViewCell: UICollectionViewCell, ViewCode {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setViewHierarchy() {
    }
    
    func setConstraints() {
    }
}
