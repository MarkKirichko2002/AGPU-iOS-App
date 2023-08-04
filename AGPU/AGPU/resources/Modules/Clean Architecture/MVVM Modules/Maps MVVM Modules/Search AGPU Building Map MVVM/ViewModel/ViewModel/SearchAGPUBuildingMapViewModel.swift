//
//  SearchAGPUBuildingMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import MapKit

class SearchAGPUBuildingMapViewModel {
    
    var locationHandler: ((LocationModel)->Void)?
    var building: AGPUBuildingModel!
    
    // MARK: - сервисы
    let locationManager = LocationManager()

    // MARK: - Init
    init(building: AGPUBuildingModel) {
        self.building = building
    }
}
