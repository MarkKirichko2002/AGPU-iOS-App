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
    
    // MARK: - сервисы
    let locationManager = LocationManager()
 
    func CheckLocationAuthorizationStatus() {
        locationManager.СheckLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.GetLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
}
