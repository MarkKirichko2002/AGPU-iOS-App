//
//  AGPUBuildingTypes.swift
//  AGPU
//
//  Created by Марк Киричко on 13.12.2023.
//

import Foundation

struct AGPUBuildingTypes {
    
    static var types = [
        AGPUBuildingTypeModel(name: "Все здания", type: AGPUBuildingType.all, count: 0),
        AGPUBuildingTypeModel(name: "Корпуса", type: AGPUBuildingType.building, count: 0),
        AGPUBuildingTypeModel(name: "Общежития", type: AGPUBuildingType.hostel, count: 0),
    ]
}
