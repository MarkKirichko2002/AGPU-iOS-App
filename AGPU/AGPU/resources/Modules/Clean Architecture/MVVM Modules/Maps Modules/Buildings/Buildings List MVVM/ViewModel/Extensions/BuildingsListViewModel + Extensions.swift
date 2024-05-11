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
    
    func setUpData() {
        
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
    
    func isBuildingSelected(index: Int) -> Bool {
        let item = buildingItem(index: index)
        if item.title! == currentLocation?.title! {
            return true
        }
        return false
    }
    
    func registerSelectedHandler(block: @escaping()-> Void) {
        self.selectedHandler = block
    }
}
