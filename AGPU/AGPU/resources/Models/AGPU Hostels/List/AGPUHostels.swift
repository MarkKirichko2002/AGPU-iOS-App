//
//  AGPUHostels.swift
//  AGPU
//
//  Created by Марк Киричко on 05.08.2023.
//

import Foundation

struct AGPUHostels {
    
    static let hostels = [
        AGPUHostelModel(
            name: "Общежитие №1",
            pin: AGPUHostelPins.pins[0]
        ),
        AGPUHostelModel(
            name: "Общежитие №2",
            pin: AGPUHostelPins.pins[1]
        )
    ]
}
