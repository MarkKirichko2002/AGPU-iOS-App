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
    
    func СheckLocationAuthorization(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            completion(false)
        } else if status == .restricted || status == .denied {
            completion(false)
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            completion(true)
        }
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
