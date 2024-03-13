//
//  ITimeTableSplashScreenViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2024.
//

import UIKit

protocol ITimeTableSplashScreenViewModel {
    func getTimeTable()
    func getImage(json: Codable, completion: @escaping(UIImage)->Void)
    func textColor()-> UIColor
    func registerTimeTableHandler(block: @escaping(TimeTableDateModel)->Void)
}
