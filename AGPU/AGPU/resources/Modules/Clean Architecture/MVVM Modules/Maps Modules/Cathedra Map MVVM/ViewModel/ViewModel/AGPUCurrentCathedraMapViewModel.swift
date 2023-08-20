//
//  AGPUCurrentCathedraMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

class AGPUCurrentCathedraMapViewModel {
    
    let locationManager = LocationManager()
    var cathedra: FacultyCathedraModel!
    var locationHandler: ((LocationModel)->Void)?
    var alertHandler: ((Bool)->Void)?
    
    // MARK: - Init
    init(cathedra: FacultyCathedraModel) {
        self.cathedra = cathedra
    }
}
