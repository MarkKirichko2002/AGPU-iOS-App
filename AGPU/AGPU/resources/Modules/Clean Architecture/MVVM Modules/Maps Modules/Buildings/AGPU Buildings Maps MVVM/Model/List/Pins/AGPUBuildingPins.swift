//
//  AGPUBuildingPins.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

struct AGPUBuildingPins {
    
    static var pins = [
        // Главный корпус
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.001817, longitude: 41.132393),
            title: "Главный корпус",
            subtitle: "Аудитории: 1, 2, 3, 4, 4а, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 14а, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23а"
        ),
        
        // Корпус и Общежитие №1
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.000517, longitude: 41.126859),
            title: "Корпус и Общежитие №1",
            subtitle: "Аудитории: 30, 31, 32, 33, 34, 35, 36, 37, 38, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121"
        ),
        
        // Корпус №2
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.000415, longitude: 41.131333),
            title: "Корпус №2",
            subtitle: "Аудитории: 24, 25, 26, 27, 28"
        ),
        
        // Корпус №3 (СПФ)
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.002263, longitude: 41.121873),
            title: "Корпус №3 (СПФ)",
            subtitle: "Аудитории: 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50"
        ),
        
        // Корпус №4 (ФТЭиД)
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.003697, longitude: 41.122763),
            title: "Корпус №4 (ФТЭиД)",
            subtitle: "Аудитории: 51, 52, 53, 54, 55, 56, 57, 58 а, 58 б, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68"
        ),
        
        // Корпус №5 (ЕБД)
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.003372, longitude: 41.121388),
            title: "Корпус №5 (ЕБД)",
            subtitle: "Аудитории: 80, 81, 82, 82а, 83, 84"
        ),
        
        // Корпус №6 (ФОК)
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 45.006374, longitude: 41.128629),
            title: "Корпус №6 (ФОК)",
            subtitle: "Аудитории: 85, 85а, 86, 86а, 89, Спортзал ФОК"
        ),
        
        // ИСТФАК
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 44.989082, longitude: 41.126904),
            title: "ИСТФАК",
            subtitle: "Аудитории: 201, 202, 203, 204, 205, 206, 207, 208, 209, 210"
        ),
        
        // Общежитие №2
        CustomAnnotation(
            coordinate: CLLocationCoordinate2D(latitude: 44.972907, longitude: 41.149784),
            title: "Общежитие №2",
            subtitle: ""
        ),
    ]
}
