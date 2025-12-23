//
//  differentWays.swift
//  AGPU
//
//  Created by Марк Киричко on 05.12.2025.
//

import Foundation

enum differentWays: String, CaseIterable {
    case voiceCommands = "Голосовые команды"
    case gestureRecognition = "Распознавание жестов"
    case volume = "Уровень громкости"
    case deviceOrientation = "Ориентация устройства"
    
    var icon: String {
        switch self {
        case .voiceCommands:
            return "microphone"
        case .gestureRecognition:
            return "choose"
        case .volume:
            return "sound"
        case .deviceOrientation:
            return "mobile"
        }
    }
}
