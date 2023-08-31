//
//  AGPUCurrentBuildingMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

protocol AGPUCurrentBuildingMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    func checkLocationAuthorizationStatus()
    func getLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func currentBuilding()-> MKAnnotation
}
