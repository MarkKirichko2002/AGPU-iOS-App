//
//  SearchAGPUBuildingMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import MapKit

protocol SearchAGPUBuildingMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    func checkLocationAuthorizationStatus()
    func getLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func observeActions(block: @escaping()->Void)
    func observeBuildingSelected(block: @escaping(MKAnnotation)->Void)
}
