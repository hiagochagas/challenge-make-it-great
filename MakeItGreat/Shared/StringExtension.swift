//
//  StringExtension.swift
//  MakeItGreat
//
//  Created by Hiago Chagas on 08/12/20.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
