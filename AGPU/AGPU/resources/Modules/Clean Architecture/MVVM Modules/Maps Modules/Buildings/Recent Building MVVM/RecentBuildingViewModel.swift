//
//  RecentBuildingViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2024.
//

import Foundation
import MapKit

final class RecentBuildingViewModel {
    
    var arr = [MKAnnotation]()
    
    var alertHandler: ((Bool)->Void)?
    var locationHandler: ((LocationModel)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let settingsManager = SettingsManager()
    
}
