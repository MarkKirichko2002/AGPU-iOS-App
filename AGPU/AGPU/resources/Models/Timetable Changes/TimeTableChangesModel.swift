//
//  TimeTableChangesModel.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2024.
//

import Foundation

struct TimeTableChangesModel {
    let id: String
    let date: String
    let owner: String
    let type: PairType
    let subgroup: Int
    let filteredPairs: [Discipline]
    let allPairs: [Discipline]
}
