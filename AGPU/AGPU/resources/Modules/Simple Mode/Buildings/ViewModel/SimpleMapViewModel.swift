//
//  SimpleMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2024.
//

import MapKit

final class SimpleMapViewModel {
        
    var arr = [MKAnnotation]()
    var locationHandler: ((LocationModel)->Void)?
    var alertHandler: ((Bool)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let settingsManager = SettingsManager()
    
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
                latitudeDelta: 0.001,
                longitudeDelta: 0.001
            )
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: span
            )
            
            if !self.arr.isEmpty {
                self.arr.removeAll()
            }
            
            let location = LocationModel(region: region, pins: AGPUBuildingPins.pins)
            self.currentLocation(coordinate: coordinate)
            
            self.arr.append(AGPUBuildingPins.pins.last!)
            for building in AGPUBuildings.buildings {
                self.arr.append(building.pin)
            }
            
            self.locationHandler?(location)
        }
    }
    
    func defaultLocation()-> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: arr[0].coordinate, span: span)
        return region
    }
    
    func currentLocation(coordinate: CLLocationCoordinate2D) {
        // текущая геопозиция
        let currentpin = CustomAnnotation(coordinate: coordinate, title: "Вы", subtitle: "")
        if !AGPUBuildingPins.pins.contains(where: { $0.title == "Вы" }) {
            AGPUBuildingPins.pins.append(currentpin)
        }
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
}
