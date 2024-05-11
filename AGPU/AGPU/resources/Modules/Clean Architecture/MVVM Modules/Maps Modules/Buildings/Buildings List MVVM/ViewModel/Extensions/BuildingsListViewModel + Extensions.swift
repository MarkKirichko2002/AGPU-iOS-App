//
//  BuildingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import MapKit

// MARK: - IBuildingsListViewModel
extension BuildingsListViewModel: IBuildingsListViewModel {
    
    func buildingItem(index: Int)-> MKAnnotation {
        return buildings[index]
    }
    
    func buildingItemsCountInSection()-> Int {
        return buildings.count
    }
    
    func getInfo(for building: Int)-> String {
        let item = buildingItem(index: building)
        let locationA = CLLocation(latitude: currentLocation?.coordinate.latitude ?? 0, longitude: currentLocation?.coordinate.longitude ?? 0)
        let locationB = CLLocation(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
        let distance = locationA.distance(from: locationB)
        let kilometers = Int(distance) / 1000
        let metres = Int(distance.truncatingRemainder(dividingBy: 1000))
        
        if locationA.coordinate.longitude == locationB.coordinate.longitude {
            return "\(item.title!!) (Выбрано)"
        } else {
            return "\(item.title!!) (\(kilometers) км \(metres) м)"
        }
    }
    
    func selectBuilding(index: Int) {
        let item = buildingItem(index: index)
        if item.title! != currentLocation?.title! {
            currentLocation = item
            self.index = index
            HapticsManager.shared.hapticFeedback()
            selectedHandler?()
        }
    }
    
    func isBuildingSelected(index: Int)-> Bool {
        let item = buildingItem(index: index)
        if item.title! == currentLocation?.title! && item.coordinate.longitude == currentLocation?.coordinate.longitude {
            return true
        }
        return false
    }
    
    func registerSelectedHandler(block: @escaping()-> Void) {
        self.selectedHandler = block
    }
}
