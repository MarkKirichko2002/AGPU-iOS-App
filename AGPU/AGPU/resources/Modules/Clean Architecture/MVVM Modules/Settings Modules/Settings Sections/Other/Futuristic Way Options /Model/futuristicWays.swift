//
//  futuristicWays.swift
//  AGPU
//
//  Created by Марк Киричко on 05.12.2025.
//

import Foundation

enum futuristicWays: String, CaseIterable {
    case voiceCommands = "Голосовые команды"
    case gestureRecognition = "Распознавание жестов"
    
    var icon: String {
        switch self {
        case .voiceCommands:
            return "microphone"
        case .gestureRecognition:
            return "choose"
        }
    }
}
