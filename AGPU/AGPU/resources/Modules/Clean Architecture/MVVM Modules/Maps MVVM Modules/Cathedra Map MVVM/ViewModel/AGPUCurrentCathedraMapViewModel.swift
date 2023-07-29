//
//  AGPUCurrentCathedraMapViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

class AGPUCurrentCathedraMapViewModel {
    
    var locationHandler: ((LocationModel)->Void)?
    
    private let locationManager = LocationManager()
    
    private var cathedra: FacultyCathedraModel!
    
    // MARK: - Init
    init(cathedra: FacultyCathedraModel) {
        self.cathedra = cathedra
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func GetLocation() {
        
        locationManager.GetLocations()
        
        locationManager.registerLocationHandler { location in
            
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: span
            )
            
            // текущая геопозиция
            let currentpin = MKPointAnnotation()
            currentpin.coordinate = coordinate
            currentpin.title = "Вы"
            
            // кафедра
            let cathedraLocation = CLLocationCoordinate2D(
                latitude: self.cathedra.coordinates[0],
                longitude: self.cathedra.coordinates[1]
            )
            let cathedraPin = MKPointAnnotation(__coordinate: cathedraLocation)
            cathedraPin.title = self.cathedra.name
            cathedraPin.subtitle = self.cathedra.address
            
            let location = LocationModel(region: region, pins: [currentpin, cathedraPin])
            
            self.locationHandler?(location)
        }
    }
}
