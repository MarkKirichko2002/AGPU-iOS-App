//
//  AGPUBuildingsMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

protocol AGPUBuildingsMapViewModelProtocol {
    func checkLocationAuthorizationStatus()
    func getLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void)
}
