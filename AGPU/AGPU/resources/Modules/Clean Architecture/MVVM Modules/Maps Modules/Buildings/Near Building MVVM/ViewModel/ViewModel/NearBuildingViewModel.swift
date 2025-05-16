//
//  NearBuildingViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 28.11.2024.
//

import MapKit

enum SearchLocationType {
    case distance
    case audience
}

final class NearBuildingViewModel {
    
    var currentBuilding: AGPUBuildingModel?
    var metres = 300
    var selectedType = MKDirectionsTransportType.walking
    var selectedSearchType = SearchLocationType.distance
    
    var buildingHandler: ((AGPUBuildingModel)->Void)?
    var alertHandler: ((Bool)->Void)?
    var noBuildingHandler: ((String, String)->Void)?
    var metresHandler: (()->Void)?
    var transportTypeHandler: (()->Void)?
    var searchTypeHandler: (()->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let settingsManager = SettingsManager()
    
}
