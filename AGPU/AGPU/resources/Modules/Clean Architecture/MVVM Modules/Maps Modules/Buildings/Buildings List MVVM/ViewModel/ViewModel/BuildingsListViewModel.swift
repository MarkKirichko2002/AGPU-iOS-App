//
//  BuildingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import MapKit

class BuildingsListViewModel {
    
    var currentLocation: MKAnnotation?
    var buildings = [MKAnnotation]()
    var index = 0
    
    var selectedHandler: (()->Void)?
    
    init(currentLocation: MKAnnotation, buildings: [MKAnnotation]) {
        self.currentLocation = currentLocation
        self.buildings = buildings
    }
}
