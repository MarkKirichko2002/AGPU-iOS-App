//
//  OnlyMainVariants.swift
//  AGPU
//
//  Created by Марк Киричко on 07.05.2024.
//

import Foundation

enum OnlyMainVariants: String, CaseIterable, Codable {
    case schedule = "Только расписание"
    case news = "Только новости"
    case sections = "Только разделы сайта"
    case none = "По умолчанию"
}
