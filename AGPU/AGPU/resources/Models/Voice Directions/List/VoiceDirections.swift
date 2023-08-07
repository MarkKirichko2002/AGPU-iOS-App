//
//  VoiceDirections.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2023.
//

import Foundation

struct VoiceDirections {
    
    static let directions = [
        
        VoiceDirectionModel(
            name: "вверх",
            icon: "arrow.up"
        ),
        VoiceDirectionModel(
            name: "вниз",
            icon: "arrow.down"
        ),
        VoiceDirectionModel(
            name: "право",
            icon: "arrow.right"
        ),
        VoiceDirectionModel(
            name: "лево",
            icon: "arrow.left"
        )
    ]
}
