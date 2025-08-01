//
//  TabModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

struct TabModel: Codable, Equatable {
    let id: Int
    var name: String
    var icon = UIImage().pngData()
    var position: Int
    
    var tabName: String {
        if id == 1 {
            return "news"
        } else if id == 2 {
            return "sections"
        } else if id == 3 {
            return "timetable"
        } else if id == 4 {
            return "settings"
        } else {
            return ""
        }
    }
}
