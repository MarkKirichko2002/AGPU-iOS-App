//
//  SearchAGPUBuildingMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import MapKit

// MARK: - SearchAGPUBuildingMapViewModelProtocol
extension SearchAGPUBuildingMapViewModel: SearchAGPUBuildingMapViewModelProtocol {
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func getLocation() {
        
        locationManager.getLocations()
        
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
            
            let location = LocationModel(region: region, pins: [currentpin, self.building.pin])
            
            self.locationHandler?(location)
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func observeActions(block: @escaping(Actions)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("actions"), object: nil, queue: .main) { notification in
            if let action = notification.object as? Actions {
                block(action)
            }
        }
    }
    
    func observeBuildingSelected(block: @escaping(MKAnnotation)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("building selected"), object: nil, queue: .main) { notification in
            if let pin = notification.object as? MKAnnotation {
                block(pin)
            }
        }
    }
}
