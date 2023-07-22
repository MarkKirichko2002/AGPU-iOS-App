//
//  AGPUBuildingsMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

// MARK: - AGPUBuildingsMapViewModelProtocol
extension AGPUBuildingsMapViewModel: AGPUBuildingsMapViewModelProtocol {
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func GetLocation() {
        
        locationManager.GetLocations()
        
        locationManager.registerLocationHandler { location in
            
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: span
            )
            
            // текущая геопозиция
            let currentpin = MKPointAnnotation()
            currentpin.coordinate = coordinate
            currentpin.title = "Вы"
            
            AGPUPins.pins.append(currentpin)
            
            let location = LocationModel(region: region, pins: AGPUPins.pins)
            
            self.locationHandler?(location)
            
        }
    }
}
