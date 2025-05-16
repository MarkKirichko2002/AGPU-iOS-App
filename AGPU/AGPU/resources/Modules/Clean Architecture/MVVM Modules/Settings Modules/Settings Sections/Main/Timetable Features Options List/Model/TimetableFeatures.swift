//
//  TimetableFeatures.swift
//  AGPU
//
//  Created by Марк Киричко on 27.10.2024.
//

import Foundation

struct TimetableFeatureModel {
    let name: String
    let icon: String
}

struct TimetableFeatures {
    static let features = [
        TimetableFeatureModel(name: "Революционное расписание", icon: "clock"),
        TimetableFeatureModel(name: "Информация о паре", icon: "info icon"),
        TimetableFeatureModel(name: "Умный календарь", icon: "calendar")
    ]
}
