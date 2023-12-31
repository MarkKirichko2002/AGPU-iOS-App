//
//  LocationManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation

protocol LocationManagerProtocol {
    func getLocations()
    func checkLocationAuthorization(completion: @escaping (Bool) -> Void)
}
