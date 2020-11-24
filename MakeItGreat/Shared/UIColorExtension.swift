//
//  UIColorExtension.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 24/11/20.
//

import UIKit

extension UIColor {
    static var greenPriority: UIColor = {
        return UIColor(displayP3Red: 69/255, green: 216/255, blue: 173/255, alpha: 1)
    }()
    
    static var redPriority: UIColor = {
        return UIColor(displayP3Red: 255/255, green: 102/255, blue: 152/255, alpha: 1)
    }()
    
    static var yellowPriority: UIColor = {
        return UIColor(displayP3Red: 255/255, green: 197/255, blue: 107/255, alpha: 1)
    }()
    
    static var blueActionColor: UIColor = {
        return UIColor(displayP3Red: 105/255, green: 180/255, blue: 194/255, alpha: 1)
    }()
    
    static var grayBackground: UIColor = {
        return UIColor(displayP3Red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    }()
    
}
