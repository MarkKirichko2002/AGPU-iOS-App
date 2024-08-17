//
//  IRecentBuildingViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2024.
//

import Foundation

protocol IRecentBuildingViewModel {
    func checkLocationAuthorizationStatus()
    func getLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
}
