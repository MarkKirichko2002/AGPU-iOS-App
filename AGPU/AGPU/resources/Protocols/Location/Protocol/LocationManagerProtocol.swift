//
//  LocationManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation

protocol LocationManagerProtocol {
    func GetLocations()
    func getCoordinatesFromAddress(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void)
}
