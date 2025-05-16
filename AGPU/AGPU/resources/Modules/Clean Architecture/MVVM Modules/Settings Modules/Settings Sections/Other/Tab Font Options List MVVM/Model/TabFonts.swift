//
//  TabFonts.swift
//  AGPU
//
//  Created by Марк Киричко on 16.12.2024.
//

import UIKit

enum TabFonts: String, CaseIterable, Codable {
    case impact = "Impact"
    case сaptureIt = "Capture it"
    case plup = "Plup"
    case monoCraft = "Monocraft"
    case toyz = "TOYZ"
    case none = "Без шрифта"
    
    var font: UIFont {
        if self != .none {
            return UIFont(name: self.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
        } else {
            return UIFont.systemFont(ofSize: 16)
        }
    }
}
