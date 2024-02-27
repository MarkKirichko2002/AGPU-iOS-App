//
//  ITimetableDateDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import Foundation

protocol ITimetableDateDetailViewModel {
    func getTimeTableForDay()
    func registerTimeTableHandler(block: @escaping(TimeTableDateModel)->Void)
}
