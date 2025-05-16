//
//  LocationManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation
import MapKit

// MARK: - LocationManagerProtocol
extension LocationManager: LocationManagerProtocol {
    
    func getLocations() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func checkLocationAuthorization(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
            completion(true)
        } else if status == .restricted || status == .denied {
            completion(false)
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            completion(true)
        }
    }
    
    func getDistance(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping(Int, Int, [Int])->Void, errorHandler: @escaping(Error)->Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = type
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Ошибка при получении маршрута: \(error.localizedDescription)")
                    errorHandler(error)
                }
                return
            }
            
            if let route = response.routes.first {
                let kilometres = Int(route.distance / 1000.0)
                let metres = Int(route.distance) % 1000
                completion(kilometres, metres, route.expectedTravelTime.getTime())
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if isUpdates {
                manager.desiredAccuracy = kCLLocationAccuracyBest     
                manager.startUpdatingLocation()
            } else {
                manager.stopUpdatingLocation()
            }
            locationHandler?(location)
        }
    }
}
