//
//  Colors.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import UIKit

enum Colors: CaseIterable, Codable {
    
    case system
    case exam
    case prac
    case aspu
    
    var title: String {
        switch self {
        case .system:
            return "Системный"
        case .exam:
            return "Экзамен"
        case .prac:
            return "Практика"
        case .aspu:
            return "АГПУ"
        }
    }
    
    var color: UIColor {
        switch self {
        case .system:
            return UIColor.label
        case .exam:
            return UIColor(named: "exam") ?? .label
        case .prac:
            return UIColor(named: "prac") ?? .label
        case .aspu:
            return UIColor(named: "aspu") ?? .label
        }
    }
}


