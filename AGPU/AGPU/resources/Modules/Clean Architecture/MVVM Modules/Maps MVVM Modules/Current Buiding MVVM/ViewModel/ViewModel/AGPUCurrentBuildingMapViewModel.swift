//
//  AGPUCurrentBuildingMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

class AGPUCurrentBuildingMapViewModel {
    
    var audienceID: String
    
    var locationHandler: ((LocationModel)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    
    // MARK: - Init
    init(audienceID: String) {
        self.audienceID = audienceID
    }
}
