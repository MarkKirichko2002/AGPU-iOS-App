//
//  AGPUCurrentCathedraMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 03.08.2023.
//

import Foundation

protocol AGPUCurrentCathedraMapViewModelProtocol {
    func checkLocationAuthorizationStatus()
    func getLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func getCurrentFaculty()-> AGPUFacultyModel
}
