//
//  AGPUCurrentCathedraMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 03.08.2023.
//

import Foundation

protocol AGPUCurrentCathedraMapViewModelProtocol {
    func CheckLocationAuthorizationStatus()
    func GetLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
}
