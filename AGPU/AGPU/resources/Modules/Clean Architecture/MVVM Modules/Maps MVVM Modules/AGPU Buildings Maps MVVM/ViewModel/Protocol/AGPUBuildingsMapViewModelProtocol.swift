//
//  AGPUBuildingsMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import Foundation

protocol AGPUBuildingsMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func GetLocation()
}
