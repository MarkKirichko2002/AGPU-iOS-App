//
//  AGPUBuildingsMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

final class AGPUBuildingsMapViewModel {
    
    var locationHandler: ((LocationModel)->Void)?
    var choiceHandler: ((Bool, MKAnnotation)->Void)?
    var alertHandler: ((Bool)->Void)?
    var arr = [MKAnnotation]()
    
    var faculty: AGPUFacultyModel?
    var type = AGPUBuildingType.all
    
    // MARK: - сервисы
    let locationManager = LocationManager()
 
}
