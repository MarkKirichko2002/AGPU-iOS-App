//
//  AGPUBuildings.swift
//  AGPU
//
//  Created by Марк Киричко on 20.07.2023.
//

import Foundation

struct AGPUBuildings {
    
    static let buildings = [
        // Главный корпус
        AGPUBuildingModel(
            name: "Главный корпус",
            image: "",
            audiences: [
                "1",
                "2",
                "3",
                "4",
                "4а",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "14а",
                "15",
                "15а",
                "16",
                "17",
                "18",
                "21",
                "22",
                "23"
            ],
            pin: AGPUPins.pins[0]
        ),
        
        // Корпус №1
        AGPUBuildingModel(
            name: "Корпус №1",
            image: "",
            audiences: [
                "24",
                "25",
                "26",
                "27",
                "28"
            ],
            pin: AGPUPins.pins[1]
        ),
        
        // Корпус №2
        AGPUBuildingModel(
            name: "Корпус №2",
            image: "",
            audiences: [
                "24",
                "25",
                "26",
                "27",
                "28"
            ],
            pin: AGPUPins.pins[2]
        ),
        
        // Корпус №3 (СПФ)
        AGPUBuildingModel(
            name: "Корпус №3 (СПФ)",
            image: "",
            audiences: [
                "40",
                "41",
                "42",
                "43",
                "44",
                "45",
                "46",
                "47",
                "48",
                "49",
                "50"
            ],
            pin: AGPUPins.pins[3]
        ),
        
        // Корпус №4 (ФТЭиД)
        AGPUBuildingModel(
            name: "Корпус №4 (ФТЭиД)",
            image: "",
            audiences: [
                "51",
                "52",
                "53",
                "57",
                "58а",
                "58б",
                "59",
                "60",
                "61",
                "62",
                "63",
                "64",
                "65",
                "66",
                "67",
                "68"
            ],
            pin: AGPUPins.pins[4]
        ),
        
        // Корпус №5 (ЕБД)
        AGPUBuildingModel(
            name: "Корпус №5 (ЕБД)",
            image: "",
            audiences: [
                "80",
                "81",
                "82",
                "82а",
                "83",
                "84"
            ],
            pin: AGPUPins.pins[5]
        ),
        
        // Корпус №6 (ФОК)
        AGPUBuildingModel(
            name: "Корпус №6 (ФОК)",
            image: "",
            audiences: [
                "85",
                "85а",
                "86",
                "Спортзал ФОК"
            ],
            pin: AGPUPins.pins[6]
        ),
        
        // (ИСТФАК)
        AGPUBuildingModel(
            name: "(ИСТФАК)",
            image: "",
            audiences: [
                "201",
                "202",
                "203",
                "204",
                "205",
                "206",
                "207",
                "208",
                "209",
                "210"
            ],
            pin: AGPUPins.pins[7]
        )
    ]
}