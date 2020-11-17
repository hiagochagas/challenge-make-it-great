//
//  ViewCode.swift
//  MakeItGreat
//
//  Created by Tales Conrado on 17/11/20.
//

import Foundation

/// Assine este protocolo para implementar view code em sua view.
/// 
/// Exemplo de uso:
/// ```
/// class HomeView: UIView, ViewCode
/// ```
protocol ViewCode {
    /// Use esse método para adicionar subviews.
    func setViewHierarchy()
    /// Use esse método para organizar suas constraints. Separe em subfunções se necessário.
    func setConstraints()
    /// Função que chama os outros métodos do protocolo. Chame-a no seu init, por exemplo.
    func setup()
}

extension ViewCode {
    func setup() {
        setViewHierarchy()
        setConstraints()
    }
}
