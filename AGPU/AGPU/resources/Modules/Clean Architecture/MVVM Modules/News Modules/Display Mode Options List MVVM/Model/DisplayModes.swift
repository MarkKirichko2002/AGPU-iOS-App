//
//  DisplayModes.swift
//  AGPU
//
//  Created by Марк Киричко on 23.04.2024.
//

import Foundation

enum DisplayModes: String, CaseIterable, Codable {
    case grid = "Сетка"
    case table = "Таблица"
    case webpage = "Веб-страница"
    
    var voiceCommand: String {
        switch self {
        case .grid:
            return "сетк"
        case .table:
            return "таблиц"
        case .webpage:
            return "веб"
        }
    }
}
