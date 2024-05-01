//
//  ASPUButtonAnimationOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.04.2024.
//

import Foundation

enum ASPUButtonAnimationOptions: String, CaseIterable, Codable  {
    case spring = "Пружинная"
    case flipFromTop = "Поворот сверху"
    case flipFromRight = "Поворот слева"
    case flipFromLeft = "Поворот справа"
    case flipFromBottom = "Поворот снизу"
    case none = "Без анимации"
}
