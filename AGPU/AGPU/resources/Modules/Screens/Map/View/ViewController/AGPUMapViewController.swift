//
//  AGPUMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2023.
//

import CoreLocation
import UIKit
import MapKit

class AGPUMapViewController: UIViewController {
    
    // MARK: - сервисы
    private let manager = CLLocationManager()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Найти «АГПУ»"
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        makeConstraints()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)
        
        // MARK: - «АГПУ» корпуса координаты
        
        // Главный корпус
        let MainBuildingCoordinate = CLLocationCoordinate2D(latitude: 45.001817, longitude: 41.132393)
        
        // Корпус №1
        let building1Coordinate = CLLocationCoordinate2D(latitude: 45.000517, longitude: 41.126859)
        
        // Корпус №2
        let building2Coordinate = CLLocationCoordinate2D(latitude: 45.000415, longitude: 41.131333)
        
        // Корпус №3 (СПФ)
        let building3Coordinate = CLLocationCoordinate2D(latitude: 45.002263, longitude: 41.121873)
        
        //  Корпус №4 (ФТЭиД)
        let building4Coordinate = CLLocationCoordinate2D(latitude: 45.003697, longitude: 41.122763)
        
        //  Корпус №5
        let building5Coordinate = CLLocationCoordinate2D(latitude: 45.003372, longitude: 41.121388)
        
        // Корпус №6 (ФОК)
        let building6Coordinate = CLLocationCoordinate2D(latitude: 45.006374, longitude: 41.128629)
        
        // MARK: - АГПУ корпуса метки
        
        // текущая геопозиция
        let currentpin = MKPointAnnotation()
        currentpin.coordinate = coordinate
        currentpin.title = "Вы"
        
        // Главный корпус
        let mainBuildingPin = MKPointAnnotation()
        mainBuildingPin.coordinate = MainBuildingCoordinate
        mainBuildingPin.title = "Главный корпус"
        mainBuildingPin.subtitle = "Аудитории: 1, 2, 3, 4, 4а, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 14а, 15, 15а, 16, 17, 18,  23"
        
        // Корпус №1
        let building1Pin = MKPointAnnotation()
        building1Pin.coordinate = building1Coordinate
        building1Pin.title = "Корпус №1"
        building1Pin.subtitle = "Аудитории: 101, 103, 104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121"
        
        // Корпус №2
        let building2Pin = MKPointAnnotation()
        building2Pin.coordinate = building2Coordinate
        building2Pin.title = "Корпус №2"
        building2Pin.subtitle = "Аудитории: 24, 25, 26, 27, 28"
        
        // Корпус №3 (СПФ)
        let building3Pin = MKPointAnnotation()
        building3Pin.coordinate = building3Coordinate
        building3Pin.title = "Корпус №3 (СПФ)"
        building3Pin.subtitle = "Аудитории: 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50"
        
        // Корпус №4 (ФТЭиД)
        let building4Pin = MKPointAnnotation()
        building4Pin.coordinate = building4Coordinate
        building4Pin.title = "Корпус №4 (ФТЭиД)"
        building4Pin.subtitle = "Аудитории: 51, 52, 53, 57, 58 а, 58 б, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68"
        
        // Корпус №5
        let building5Pin = MKPointAnnotation()
        building5Pin.coordinate = building5Coordinate
        building5Pin.title = "Корпус №5 (ЕБД)"
        building5Pin.subtitle = "Аудитории: 80, 81, 82, 82а, 83, 84"
        
        // Корпус №6 (ФОК)
        let building6Pin = MKPointAnnotation()
        building6Pin.coordinate = building6Coordinate
        building6Pin.title = "Корпус №6 (ФОК)"
        building6Pin.subtitle = "Аудитории: 85, 85а, 86"
        
        mapView.showAnnotations([
            currentpin,
            mainBuildingPin,
            building1Pin,
            building2Pin,
            building3Pin,
            building4Pin,
            building5Pin,
            building6Pin
        ], animated: true)
    }
}
