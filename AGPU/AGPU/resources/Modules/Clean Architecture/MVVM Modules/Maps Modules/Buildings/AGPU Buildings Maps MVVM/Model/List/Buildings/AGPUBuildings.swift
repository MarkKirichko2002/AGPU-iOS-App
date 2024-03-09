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
            type: .building,
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
                "23",
                "23a",
                "23б",
                "23в"
            ],
            pin: AGPUBuildingPins.pins[0],
            voiceCommands: ["главный корпус"]
        ),
        
        // Корпус №1 и Общежитие №1
        AGPUBuildingModel(
            name: "Корпус №1 и Общежитие №1",
            image: "",
            type: .buildingAndHostel,
            audiences: [
                "30",
                "31",
                "32",
                "33",
                "34",
                "35",
                "36",
                "37",
                "38",
                "101",
                "102",
                "103",
                "104",
                "105",
                "106",
                "107",
                "108",
                "109",
                "110",
                "111",
                "112",
                "113",
                "114",
                "115",
                "116",
                "117",
                "118",
                "119",
                "120",
                "121"
            ],
            pin: AGPUBuildingPins.pins[1],
            voiceCommands: [
                // для корпуса
                "корпус один",
                "корпус первый",
                "первый корпус",
                "корпус номер один",
                "корпус под номером один",
                // для общежития
                "общежитие один",
                "общежитие номер один",
                "общежитие под номером один"
            ]
        ),
        
        // Корпус №2
        AGPUBuildingModel(
            name: "Корпус №2",
            image: "",
            type: .building,
            audiences: [
                "24",
                "25",
                "26",
                "27",
                "28"
            ],
            pin: AGPUBuildingPins.pins[2],
            voiceCommands: [
                "корпус два",
                "корпус второй",
                "второй корпус",
                "корпус номер два",
                "корпус под номером два"
            ]
        ),
        
        // Корпус №3 (СПФ)
        AGPUBuildingModel(
            name: "Корпус №3 (СПФ)",
            image: "",
            type: .building,
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
            pin: AGPUBuildingPins.pins[3],
            voiceCommands: [
                "корпус три",
                "корпус третий",
                "третий корпус",
                "корпус номер три",
                "корпус под номером три"
            ]
        ),
        
        // Корпус №4 (ФТЭиД)
        AGPUBuildingModel(
            name: "Корпус №4 (ФТЭиД)",
            image: "",
            type: .building,
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
            pin: AGPUBuildingPins.pins[4],
            voiceCommands: [
                "корпус четыре",
                "корпус четвёртый",
                "четвёртый корпус",
                "корпус номер четыре",
                "корпус под номером четыре"
            ]
        ),
        
        // Корпус №5 (ЕБД)
        AGPUBuildingModel(
            name: "Корпус №5 (ЕБД)",
            image: "",
            type: .building,
            audiences: [
                "80",
                "81",
                "82",
                "82а",
                "83",
                "84"
            ],
            pin: AGPUBuildingPins.pins[5],
            voiceCommands: [
                "корпус пять",
                "корпус пятый",
                "пятый корпус",
                "корпус номер пять",
                "корпус под номером пять"
            ]
        ),
        
        // Корпус №6 (ФОК)
        AGPUBuildingModel(
            name: "Корпус №6 (ФОК)",
            image: "",
            type: .building,
            audiences: [
                "85",
                "85а",
                "86",
                "86a",
                "Спортзал ФОК"
            ],
            pin: AGPUBuildingPins.pins[6],
            voiceCommands: [
                "корпус шесть",
                "корпус шестой",
                "шестой корпус",
                "корпус номер шесть",
                "корпус под номером шесть",
                "фок"
            ]
        ),
        
        // ИСТФАК
        AGPUBuildingModel(
            name: "ИСТФАК",
            image: "",
            type: .building,
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
            pin: AGPUBuildingPins.pins[7],
            voiceCommands: [
                "истфак",
                "ист фак",
                "исторический факультет",
                "факультет исторический"
            ]
        ),
        
        AGPUBuildingModel(
            name: "Общежитие №2",
            image: "",
            type: .hostel,
            audiences: [],
            pin: AGPUBuildingPins.pins[8],
            voiceCommands: [
                "общежитие два",
                "общежитие номер два",
                "общежитие под номером два",
            ]
        )
    ]
}
