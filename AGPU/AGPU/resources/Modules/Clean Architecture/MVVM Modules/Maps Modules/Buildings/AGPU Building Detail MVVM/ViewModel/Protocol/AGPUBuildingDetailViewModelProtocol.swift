//
//  AGPUBuildingDetailViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import UIKit

protocol AGPUBuildingDetailViewModelProtocol {
    func getTimetable()
    func getWeather()
    func getPairsCount(pairs: [Discipline])-> Int
    func checkPairsExisting(pairs: [Discipline])-> String
    func registerWeatherHandler(block: @escaping(String)->Void)
    func registerPairsHandler(block: @escaping(String)->Void)
    func registerPairsColorHandler(block: @escaping(UIColor)->Void)
}
