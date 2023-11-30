//
//  AGPUBuildingDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import CoreLocation
import WeatherKit

class AGPUBuildingDetailViewModel {
    
    var location: CLLocation
    
    var weatherHandler: ((String)->Void)?
    
    // MARK: - Init
    init(location: CLLocation) {
        self.location = location
    }
}
