//
//  AGPUBuildingDetailViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import Foundation

protocol AGPUBuildingDetailViewModelProtocol {
    func getWeather()
    func registerWeatherHandler(block: @escaping(String)->Void)
}
