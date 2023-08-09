//
//  AGPUCurrentBuildingMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

final class AGPUCurrentBuildingMapViewModel {
    
    var audienceID: String
    var locationHandler: ((LocationModel)->Void)?
    var alertHandler: ((Bool)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    
    // MARK: - Init
    init(
        audienceID: String
    ) {
        self.audienceID = audienceID
    }
}
