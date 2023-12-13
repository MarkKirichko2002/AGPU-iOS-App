//
//  AGPUBuildingsMapViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import MapKit

// MARK: - AGPUBuildingsMapViewModelProtocol
extension AGPUBuildingsMapViewModel: AGPUBuildingsMapViewModelProtocol {
    
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
            
            if !AGPUBuildingPins.pins.contains(where: { $0.title == "Вы" }) {
                AGPUBuildingPins.pins.append(currentpin)
            }
            
            print(AGPUBuildingPins.pins.count)
            
            let location = LocationModel(region: region, pins: AGPUBuildingPins.pins)
            self.locationHandler?(location)
        }
    }
    
    func observeBuildingTypeSelected() {
        NotificationCenter.default.addObserver(forName: Notification.Name("building type selected"), object: nil, queue: .main) { notification in
            if let type = notification.object as? AGPUBuildingType {
                
                self.type = type
                
                switch type {
                case .all:
                    
                    for pin in self.arr {
                        self.choiceHandler?(false, pin)
                        self.faculty = nil
                    }
                    
                    for building in AGPUBuildings.buildings {
                        self.choiceHandler?(true, building.pin)
                    }
                case .building:
                    
                    for pin in self.arr {
                        self.choiceHandler?(false, pin)
                        self.faculty = nil
                    }
                    
                    for building in AGPUBuildings.buildings {
                        if building.type == .building || building.type == .buildingAndHostel {
                            self.choiceHandler?(true, building.pin)
                        } else {
                            self.choiceHandler?(false, building.pin)
                        }
                    }
                case .hostel:
                    
                    for pin in self.arr {
                        self.choiceHandler?(false, pin)
                        self.faculty = nil
                    }
                    
                    for building in AGPUBuildings.buildings {
                        if building.type == .hostel || building.type == .buildingAndHostel {
                            self.choiceHandler?(true, building.pin)
                        } else {
                            self.choiceHandler?(false, building.pin)
                        }
                    }
                case .buildingAndHostel:
                    break
                }
            }
        }
    }
    
    func observeFacultySelected() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty selected"), object: nil, queue: .main) { notification in
            
            if let faculty = notification.object as? AGPUFacultyModel {
                
                self.faculty = faculty
                self.type = nil
                
                for pin in self.arr {
                    self.choiceHandler?(false, pin)
                }
                
                if !self.arr.isEmpty {
                    self.arr.removeAll()
                }
                
                for building in AGPUBuildings.buildings {
                    self.choiceHandler?(false, building.pin)
                }
                
                // 1 кафедра
                let cathedraLocation1 = CLLocationCoordinate2D(
                    latitude: faculty.cathedra[0].coordinates[0],
                    longitude: faculty.cathedra[0].coordinates[1]
                )
                let cathedraPin1 = MKPointAnnotation(__coordinate: cathedraLocation1)
                cathedraPin1.title = self.faculty?.cathedra[0].name
                cathedraPin1.subtitle = self.faculty?.cathedra[0].address
                
                // 2 кафедра
                let cathedraLocation2 = CLLocationCoordinate2D(
                    latitude: faculty.cathedra[1].coordinates[0],
                    longitude: faculty.cathedra[1].coordinates[1]
                )
                let cathedraPin2 = MKPointAnnotation(__coordinate: cathedraLocation2)
                cathedraPin2.title = self.faculty?.cathedra[1].name
                cathedraPin2.subtitle = self.faculty?.cathedra[1].address
                
                self.arr.append(cathedraPin1)
                self.arr.append(cathedraPin2)
                
                for pin in self.arr {
                    self.choiceHandler?(true, pin)
                }
                
                print(self.arr.count)
            }
        }
    }
    
    func registerLocationHandler(block: @escaping(LocationModel)->Void) {
        self.locationHandler = block
    }
    
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void) {
        self.choiceHandler = block
    }
}
