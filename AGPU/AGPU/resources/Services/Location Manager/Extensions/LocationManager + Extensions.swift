//
//  LocationManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation

// MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    
    func GetLocations() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            locationHandler?(location)
        }
    }
}
