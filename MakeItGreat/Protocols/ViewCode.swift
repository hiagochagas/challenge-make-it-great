//
//  ViewCode.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 17/11/20.
//

import Foundation

/// Assine este protocolo para implementar view code em sua controller.
/// 
/// Exemplo de uso:
/// ```
/// class HomeController: UIViewController, ViewCode
/// ```
protocol ViewCode {
    func setViewHierarchy()
    func setConstraints()
    func setup()
}

extension ViewCode {
    func setup() {
        setViewHierarchy()
        setConstraints()
    }
}
