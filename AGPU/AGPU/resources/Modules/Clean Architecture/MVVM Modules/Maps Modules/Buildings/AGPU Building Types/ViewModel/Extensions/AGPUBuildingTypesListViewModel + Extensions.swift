//
//  AGPUBuildingTypesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

// MARK: - AGPUBuildingTypesListViewModelProtocol
extension AGPUBuildingTypesListViewModel: AGPUBuildingTypesListViewModelProtocol {
    
    func typeItem(index: Int)-> AGPUBuildingTypeModel {
        let type = AGPUBuildingTypes.types[index]
        return type
    }
    
    func numberOfTypesInSection()-> Int {
        let count = AGPUBuildingTypes.types.count
        return count
    }
    
    func getTypesInfo() {
        
        AGPUBuildingTypes.types[0].count = AGPUBuildings.buildings.count
        
        AGPUBuildingTypes.types[1].count = AGPUBuildings.buildings.filter({$0.type == .building || $0.type == .buildingAndHostel}).count
        
        AGPUBuildingTypes.types[2].count = AGPUBuildings.buildings.filter({$0.type == .hostel || $0.type == .buildingAndHostel}).count
        
        self.dataChangedHandler?()
    }
    
    func chooseBuildingType(index: Int) {
        let buildingType = AGPUBuildingTypes.types[index]
        if buildingType.type != type {
            NotificationCenter.default.post(name: Notification.Name("building type selected"), object: buildingType.type)
            type = buildingType.type
            self.dataChangedHandler?()
            self.typeSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func isCurrentType(index: Int)-> Bool {
        let buildingType = AGPUBuildingTypes.types[index]
        if buildingType.type == type {
            return true
        } else {
            return false
        }
    }
    
    func registerTypeSelectedHandler(block: @escaping(()->Void)) {
        self.typeSelectedHandler = block
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
