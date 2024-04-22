//
//  AGPUBuildingsMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

final class AGPUBuildingsMapViewModel {
    
    var arr = [MKAnnotation]()
    var index = 0
    var faculty: AGPUFacultyModel?
    var type: AGPUBuildingType? = .all
    var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var locationHandler: ((LocationModel)->Void)?
    var choiceHandler: ((Bool, MKAnnotation)->Void)?
    var alertHandler: ((Bool)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
 
}
