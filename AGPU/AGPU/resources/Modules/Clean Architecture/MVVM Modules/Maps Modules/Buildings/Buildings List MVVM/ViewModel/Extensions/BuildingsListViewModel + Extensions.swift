//
//  BuildingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import MapKit

// MARK: - IBuildingsListViewModel
extension BuildingsListViewModel: IBuildingsListViewModel {
    
    func fillData(annotations: [MKAnnotation]) {
        self.buildings = annotations.compactMap({ BuildingModel(name: pseudonymManager.returnOriginalBuildingName(building: $0.title!!), coordinate: $0.coordinate, annotation: $0, distance: (-1, -1))})
    }
    
    func buildingItem(index: Int)-> BuildingModel {
        return buildings[index]
    }
    
    func buildingItemsCountInSection()-> Int {
        return buildings.count
    }
    
    func getData() {
        
        let group = DispatchGroup()
        guard let location = currentLocation else {return}
        
        for i in 0..<buildings.count {
            group.enter()
            locationManager.getDistance(source: location.coordinate, destination: buildings[i].coordinate) { km, m, _ in
                self.buildings[i].distance = (km, m)
                group.leave()
            } errorHandler: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.dataChangedHandler?()
        }
    }
    
    func resetBuildings() {
        for i in 0..<buildings.count {
            self.buildings[i].distance = (-1, -1)
        }
        dataChangedHandler?()
    }
    
    func selectBuilding(index: Int) {
        let item = buildingItem(index: index)
        if item.name != currentLocation?.name {
            currentLocation = item
            self.index = index
            HapticsManager.shared.hapticFeedback()
            selectedHandler?()
        }
    }
    
    func isBuildingSelected(index: Int)-> Bool {
        let item = buildingItem(index: index)
        if item.name == currentLocation?.name && item.coordinate.longitude == currentLocation?.coordinate.longitude {
            return true
        }
        return false
    }
    
    func configureItem(index: Int)-> String {
        let item = buildingItem(index: index)
        if item.distance == (-1,-1) {
            return "\(item.name) (Вычисляем расстояние...)"
        } else if item.distance == (0, 0) {
            return "\(item.name) (Выбрано)"
        } else {
            return "\(item.name) (\(item.distance.0) км \(item.distance.1) м)"
        }
    }
    
    func createTransportTypeMenu()-> UIMenu {
        let walking = UIAction(title: "Пешком", state: selectedType == .walking ? .on : .off) { item in
            self.selectedType = MKDirectionsTransportType.walking
            self.locationManager.type = self.selectedType
            self.resetBuildings()
            self.getData()
            self.transportTypeHandler?()
        }
        let auto = UIAction(title: "Автомобиль", state: selectedType == .automobile ? .on : .off) { _ in
            self.selectedType = MKDirectionsTransportType.automobile
            self.locationManager.type = self.selectedType
            self.resetBuildings()
            self.getData()
            self.transportTypeHandler?()
        }
        let types = UIMenu(title: "Тип транспорта", children: [walking, auto])
        return UIMenu(title: "Здания", children: [types])
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerSelectedHandler(block: @escaping()-> Void) {
        self.selectedHandler = block
    }
    
    func registerTransportTypeHandler(block: @escaping()->Void) {
        self.transportTypeHandler = block
    }
}
