//
//  SearchAGPUBuildingMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import MapKit

protocol SearchAGPUBuildingMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func GetLocation()
    func ObserveActions(block: @escaping()->Void)
}
