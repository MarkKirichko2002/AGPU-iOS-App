//
//  INearBuildingViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.11.2024.
//

import MapKit

protocol INearBuildingViewModel {
    func checkLocationAuthorizationStatus()
    func getNearLocation()
    func createAlertMessage()-> (String, String)
    func getNearBuilding(currentLocation: CLLocation, completion: @escaping(AGPUBuildingModel?)->Void)
    func registerBuildingHandler(block: @escaping(AGPUBuildingModel)->Void)
}
