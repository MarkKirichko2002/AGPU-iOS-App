//
//  CathedraBuildingDetailViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2023.
//

import Foundation

protocol CathedraBuildingDetailViewModelProtocol {
    func getWeather()
    func registerWeatherHandler(block: @escaping(String)->Void)
}

