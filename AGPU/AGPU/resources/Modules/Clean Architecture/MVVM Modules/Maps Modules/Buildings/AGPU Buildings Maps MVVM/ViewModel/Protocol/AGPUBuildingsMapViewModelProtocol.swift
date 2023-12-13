//
//  AGPUBuildingsMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

protocol AGPUBuildingsMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    var choiceHandler: ((Bool, MKAnnotation)->Void)? {get set}
    func checkLocationAuthorizationStatus()
    func getLocation()
    func observeBuildingTypeSelected()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void)
}
