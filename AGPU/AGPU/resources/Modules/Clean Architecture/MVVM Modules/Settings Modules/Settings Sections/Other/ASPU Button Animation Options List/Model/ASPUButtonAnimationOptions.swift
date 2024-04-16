//
//  ASPUButtonAnimationOptions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.04.2024.
//

import Foundation

enum ASPUButtonAnimationOptions: String, CaseIterable, Codable  {
    case spring = "Пружинная"
    case flipFromTop = "Вращение сверху"
    case flipFromRight = "Вращение слева"
    case flipFromLeft = "Вращение справа"
    case flipFromBottom = "Вращение снизу"
}
