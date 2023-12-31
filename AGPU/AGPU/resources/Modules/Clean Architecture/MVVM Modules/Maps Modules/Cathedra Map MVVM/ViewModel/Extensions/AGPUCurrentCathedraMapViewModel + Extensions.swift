//
//  AGPUCurrentCathedraMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 03.08.2023.
//

import MapKit

// MARK: - AGPUCurrentCathedraMapViewModelProtocol
extension AGPUCurrentCathedraMapViewModel: AGPUCurrentCathedraMapViewModelProtocol {
    
    func checkLocationAuthorizationStatus() {
        locationManager.checkLocationAuthorization { isAuthorized in
            if isAuthorized {
                self.getLocation()
            } else {
                self.alertHandler?(true)
            }
        }
    }
    
    func getLocation() {
        
        locationManager.getLocations()
        
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
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func getCurrentFaculty()-> AGPUFacultyModel {
        if let faculty = AGPUFaculties.faculties.first(where: { $0.cathedra.contains { $0.name == self.cathedra.name }}) {
            return faculty
        }
        return AGPUFaculties.faculties[0]
    }
}
