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
    
    private var address: String = ""
    
    // MARK: - Init
    init(address: String) {
        self.address = address
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
            
            self.locationManager.getCoordinatesFromAddress(address: self.address) { location, error in
                if let error = error {
                    print(error)
                }
                if let location = location {
                    let cathedraLocation = location
                    let cathedraPin = MKPointAnnotation(__coordinate: cathedraLocation)
                    cathedraPin.title = "Кафедра"
                    
                    let location = LocationModel(region: region, pins: [currentpin, cathedraPin])
                    
                    self.locationHandler?(location)
                }
            }
        }
    }
}
