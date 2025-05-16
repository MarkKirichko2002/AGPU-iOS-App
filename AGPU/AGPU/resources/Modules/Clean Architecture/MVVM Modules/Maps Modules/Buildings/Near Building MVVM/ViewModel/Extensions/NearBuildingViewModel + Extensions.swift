//
//  NearBuildingViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.11.2024.
//

import MapKit
import UIKit

// MARK: - INearBuildingViewModel
extension NearBuildingViewModel: INearBuildingViewModel {
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getNearLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func getNearLocation() {
        
        locationManager.getLocations()
        
        locationManager.registerLocationHandler { location in
            self.getNearBuilding(currentLocation: location) { building in
                if let building = building {
                    self.currentBuilding = building
                    self.buildingHandler?(building)
                }
            }
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
    
    func createMetresMenu()-> UIMenu {
        let metres = [100,200,300,400,500]
        var actions = [UIAction]()
        for item in metres {
            let action = UIAction(title: "\(item) метров", state: self.metres == item ? .on : .off) { _ in
                self.metres = item
                self.metresHandler?()
            }
            actions.append(action)
        }
        return UIMenu(title: "Расстояние", children: actions)
    }
    
    func getNearBuilding(currentLocation: CLLocation, completion: @escaping(AGPUBuildingModel?)->Void) {
        
        var buildings: [Int: AGPUBuildingModel] = [:]
        let group = DispatchGroup()
        
        for building in AGPUBuildings.buildings {
            group.enter()
            locationManager.getDistance(source: currentLocation.coordinate, destination: building.pin.coordinate) { km, m, _ in
                if km == 0 && m <= self.metres {
                    buildings[m] = building
                }
                group.leave()
            } errorHandler: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let values = buildings.sorted { $0.key < $1.key }
            if !values.isEmpty {
                let foundBuilding = values.first!
                completion(foundBuilding.value)
            } else {
                self.noBuildingHandler?("Здание не найдено", "здание в радиусе \(self.metres) метров отсутствует")
            }
        }
    }
    
    func createSearchTypeMenu()-> UIMenu {
        let distance = UIAction(title: "Расстояние", state: selectedSearchType == .distance ? .on : .off) { item in
            self.selectedSearchType = SearchLocationType.distance
            self.searchTypeHandler?()
        }
        let audience = UIAction(title: "Аудитория", state: selectedSearchType == .audience ? .on : .off) { _ in
            self.selectedSearchType = SearchLocationType.audience
            self.searchTypeHandler?()
        }
        return UIMenu(title: "Тип поиска", children: [distance, audience])
    }
    
    
    func createTransportTypeMenu()-> UIMenu {
        let walking = UIAction(title: "Пешком", state: selectedType == .walking ? .on : .off) { item in
            self.selectedType = MKDirectionsTransportType.walking
            self.locationManager.type = self.selectedType
            self.transportTypeHandler?()
        }
        let auto = UIAction(title: "Автомобиль", state: selectedType == .automobile ? .on : .off) { _ in
            self.selectedType = MKDirectionsTransportType.automobile
            self.locationManager.type = self.selectedType
            self.transportTypeHandler?()
        }
        return UIMenu(title: "Тип транспорта", children: [walking, auto])
    }
    
    func getCurrentBuilding()-> AGPUBuildingModel? {
        return currentBuilding
    }
    
    func checkInputText(text: String)-> Bool {
        if !text.contains("-") {
            if let building = AGPUBuildings.buildings.first(where: { $0.audiences.contains(text) }) {
                currentBuilding = building
                return true
            }
        }
        return false
    }
    
    func registerBuildingHandler(block: @escaping(AGPUBuildingModel)->Void) {
        self.buildingHandler = block
    }
    
    func registerNoBuildingHandler(block: @escaping(String, String)->Void) {
        self.noBuildingHandler = block
    }
    
    func registerMetresHandler(block: @escaping()->Void) {
        self.metresHandler = block
    }
    
    func registerTransportTypeHandler(block: @escaping()->Void) {
        self.transportTypeHandler = block
    }
    
    func registerSearchTypeHandler(block: @escaping()->Void) {
        self.searchTypeHandler = block
    }
}
