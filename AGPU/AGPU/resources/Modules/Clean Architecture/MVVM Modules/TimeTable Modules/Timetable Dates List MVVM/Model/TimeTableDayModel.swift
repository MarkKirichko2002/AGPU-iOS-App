//
//  TimeTableDayModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

struct TimeTableDayModel {
    let id: String
    let owner: String
    var date: String
    var disciplines: [Discipline]
}

