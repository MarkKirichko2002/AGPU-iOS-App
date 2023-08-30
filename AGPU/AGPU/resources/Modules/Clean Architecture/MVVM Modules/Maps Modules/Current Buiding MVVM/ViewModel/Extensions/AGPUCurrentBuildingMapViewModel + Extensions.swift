//
//  AGPUCurrentBuildingMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

// MARK: - AGPUCurrentBuildingMapViewModelProtocol
extension AGPUCurrentBuildingMapViewModel: AGPUCurrentBuildingMapViewModelProtocol {
    
    func checkLocationAuthorizationStatus() {
        locationManager.СheckLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func getLocation() {
        
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
            
            // текущий корпус
            let currentBuilding = self.currentBuilding()
            
            let location = LocationModel(region: region, pins: [currentpin, currentBuilding])
            
            self.locationHandler?(location)
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func currentBuilding()-> MKAnnotation {
        
        for building in AGPUBuildings.buildings {
            for audience in building.audiences {
                if audience == audienceID {
                    return building.pin
                }
            }
        }
        return AGPUBuildings.buildings[0].pin
    }
}
