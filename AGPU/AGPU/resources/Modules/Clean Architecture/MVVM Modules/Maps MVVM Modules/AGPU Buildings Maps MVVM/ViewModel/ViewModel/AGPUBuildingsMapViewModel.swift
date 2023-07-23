//
//  AGPUBuildingsMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

final class AGPUBuildingsMapViewModel {
    
    var locationHandler: ((LocationModel)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    
}
