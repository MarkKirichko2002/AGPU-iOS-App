//
//  AGPUBuildingsMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

// MARK: - AGPUBuildingsMapViewModelProtocol
extension AGPUBuildingsMapViewModel: AGPUBuildingsMapViewModelProtocol {
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void) {
        self.choiceHandler = block
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
            
            AGPUBuildingPins.pins.append(currentpin)
            
            let location = LocationModel(region: region, pins: AGPUBuildingPins.pins)
            self.locationHandler?(location)
        }
    }
    
    func makeOptionsMenu()-> UIMenu {
        
        let all = UIAction(title: "Все здания", state: .on) { _ in
            for building in AGPUBuildings.buildings {
                self.choiceHandler?(true, building.pin)
            }
        }
        
        let buildings = UIAction(title: "Корпуса") { _ in
            for building in AGPUBuildings.buildings {
                if building.type == .building || building.type == .buildingAndHostel {
                    self.choiceHandler?(true, building.pin)
                } else {
                    self.choiceHandler?(false, building.pin)
                }
            }
        }
        
        let hostels = UIAction(title: "Общежития") { _ in
            for building in AGPUBuildings.buildings {
                if building.type == .hostel || building.type == .buildingAndHostel {
                    self.choiceHandler?(true, building.pin)
                } else {
                    self.choiceHandler?(false, building.pin)
                }
            }
        }
        
        let menu = UIMenu(title: "Показать на карте", options: .singleSelection, children: [
            all,
            buildings,
            hostels
        ])
        return menu
    }
}
