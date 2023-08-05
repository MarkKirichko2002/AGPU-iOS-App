//
//  AGPUBuildingModel.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import MapKit

struct AGPUBuildingModel {
    let name: String
    let image: String
    let type: AGPUBuildingType
    let audiences: [String]
    let pin: MKAnnotation
    let voiceCommands: [String]
}
