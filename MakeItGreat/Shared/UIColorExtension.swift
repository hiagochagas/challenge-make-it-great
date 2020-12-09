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
    
    static var blueSecondaryColor: UIColor = {
        return UIColor(displayP3Red: 122/255, green: 188/255, blue: 201/255, alpha: 7/100)
    }()
    
    static var grayBackground: UIColor = {
        return UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    }()
    
    static var infoActionBackground: UIColor = {
        return UIColor(displayP3Red: 146/255, green: 141/255, blue: 171/255, alpha: 1)
    }()
    
    static var deleteActionBackground: UIColor = {
        return UIColor(displayP3Red: 255/255, green: 0/255, blue: 50/255, alpha: 1)
    }()
    
    static var oneTaskInDateColor: UIColor = {
        return UIColor(displayP3Red: 117/255, green: 196/255, blue: 206/255, alpha: 1)
    }()
    
    static var twoTaskInDateColor: UIColor = {
        return UIColor(displayP3Red: 51/255, green: 187/255, blue: 209/255, alpha: 1)
    }()
    
    static var threeTaskInDateColor: UIColor = {
        return UIColor(displayP3Red: 0/255, green: 191/255, blue: 251/255, alpha: 1)
    }()
    
    static var fourPlusTaskInDateColor: UIColor = {
        return UIColor(displayP3Red: 0/255, green: 219/255, blue: 255/255, alpha: 1)
    }()
}
