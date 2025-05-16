//
//  ASPUButtonGestureOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2024.
//

import UIKit

enum ASPUButtonGestureOptions: String, CaseIterable, Codable  {
    case tap = "Простое нажатие"
    case doubleTap = "Двойное нажатие"
    case tripleTap = "Тройное нажатие"
    case longTap = "Долгое нажатие"
    
    var gesture: UIGestureRecognizer {
        switch self {
        case .tap:
            let tap = UITapGestureRecognizer()
            return tap
        case .doubleTap:
            let tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 2
            return tap
        case .tripleTap:
            let tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 3
            return tap
        case .longTap:
            let tap = UILongPressGestureRecognizer()
            tap.minimumPressDuration = 0.4
            return tap
        }
    }
}
