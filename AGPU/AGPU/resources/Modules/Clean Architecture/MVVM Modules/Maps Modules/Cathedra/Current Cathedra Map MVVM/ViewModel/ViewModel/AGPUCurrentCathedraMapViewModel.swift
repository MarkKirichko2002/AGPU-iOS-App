//
//  AGPUCurrentCathedraMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

final class AGPUCurrentCathedraMapViewModel {
    
    var arr = [MKAnnotation]()
    var cathedra: FacultyCathedraModel!
    var locationHandler: ((LocationModel)->Void)?
    var alertHandler: ((Bool)->Void)?
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let settingsManager = SettingsManager()
    
    // MARK: - Init
    init(cathedra: FacultyCathedraModel) {
        self.cathedra = cathedra
    }
}
