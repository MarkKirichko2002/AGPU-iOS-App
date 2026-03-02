//
//  BuildingsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 11.05.2024.
//

import MapKit

struct BuildingModel {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let annotation: MKAnnotation
    var distance: (Int, Int)
}

final class BuildingsListViewModel {
    
    var currentLocation: BuildingModel?
    var buildings = [BuildingModel]()
    var index = 0
    
    var selectedType = MKDirectionsTransportType.walking
    
    // MARK: - сервисы
    let locationManager = LocationManager()
    let pseudonymManager = PseudonymManager()
    
    var dataChangedHandler: (()->Void)?
    var selectedHandler: (()->Void)?
    var transportTypeHandler: (()->Void)?
    
    init(currentLocation: MKAnnotation, buildings: [MKAnnotation]) {
        self.currentLocation = BuildingModel(name: currentLocation.title!!, coordinate: currentLocation.coordinate, annotation: currentLocation, distance: (0, 0))
        self.fillData(annotations: buildings)
    }
}
