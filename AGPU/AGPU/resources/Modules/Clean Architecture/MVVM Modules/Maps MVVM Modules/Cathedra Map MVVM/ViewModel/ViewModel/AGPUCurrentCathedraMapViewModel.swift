//
//  AGPUCurrentCathedraMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

class AGPUCurrentCathedraMapViewModel {
    
    var locationHandler: ((LocationModel)->Void)?
    
    let locationManager = LocationManager()
    
    var cathedra: FacultyCathedraModel!
    
    // MARK: - Init
    init(cathedra: FacultyCathedraModel) {
        self.cathedra = cathedra
    }
}
