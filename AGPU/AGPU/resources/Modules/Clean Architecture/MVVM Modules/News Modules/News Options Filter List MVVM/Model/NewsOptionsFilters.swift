//
//  NewsOptionsFilters.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

enum NewsOptionsFilters: String, CaseIterable, Codable {
    case today = "Сегодня"
    case yesterday = "Вчера"
    case dayBeforeYesterday = "Позавчера"
    case all = "Все новости"
}
