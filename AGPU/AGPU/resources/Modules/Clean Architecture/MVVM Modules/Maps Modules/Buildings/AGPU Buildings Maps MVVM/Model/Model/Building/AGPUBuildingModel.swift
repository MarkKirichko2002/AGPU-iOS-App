//
//  AGPUBuildingModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import MapKit

struct AGPUBuildingModel: Equatable {
    
    static func == (lhs: AGPUBuildingModel, rhs: AGPUBuildingModel) -> Bool {
        return lhs.audiences.count > rhs.audiences.count
    }
    
    let name: String
    let image: String
    let type: AGPUBuildingType
    let audiences: [String]
    var pin: MKAnnotation
    let voiceCommands: [String]
}
