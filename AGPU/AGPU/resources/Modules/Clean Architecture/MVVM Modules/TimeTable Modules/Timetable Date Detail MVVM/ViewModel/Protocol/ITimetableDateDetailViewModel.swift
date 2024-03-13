//
//  ITimetableDateDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit

protocol ITimetableDateDetailViewModel {
    func getTimeTableForDay()
    func getPairsCount()-> Int
    func textColor()-> UIColor
    func registerTimeTableHandler(block: @escaping(TimeTableDateModel)->Void)
}
