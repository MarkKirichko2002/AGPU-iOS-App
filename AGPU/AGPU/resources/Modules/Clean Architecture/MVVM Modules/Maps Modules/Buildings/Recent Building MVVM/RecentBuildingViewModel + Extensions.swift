//
//  RecentBuildingViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2024.
//

import MapKit

// MARK: - RecentBuildingViewModel
extension RecentBuildingViewModel: IRecentBuildingViewModel {
    
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
            
            let annotation = MKPointAnnotation()
            annotation.title = "Вы"
            annotation.coordinate = location.coordinate
            
            let model = self.getRecentLocation()
            
            let recentLocation = MKPointAnnotation()
            recentLocation.title = model.name
            recentLocation.subtitle = model.info
            recentLocation.coordinate = CLLocationCoordinate2D(latitude: model.coordinates[0], longitude: model.coordinates[1])
            
            self.arr.append(annotation)
            self.arr.append(recentLocation)
            
            let location = LocationModel(region: region, pins: self.arr)
            
            self.locationHandler?(location)
        }
    }
    
    func defaultLocation()-> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: arr[0].coordinate, span: span)
        return region
    }
    
    func getRecentLocation()-> RecentBuildingModel {
        return UserDefaults.loadData(type: RecentBuildingModel.self, key: "last location") ?? RecentBuildingModel(name: "", info: "", coordinates: [])
    }
    
    func createAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Геопозиция выключена", "Хотите включить в настройках?")
        case .informal:
            return ("Геопозиция выключена", "Хочешь включить в настройках?")
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func registerAlertHandler(block: @escaping(Bool)->Void) {
        self.alertHandler = block
    }
}
