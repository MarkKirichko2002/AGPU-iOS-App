//
//  AGPUMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.06.2023.
//

import CoreLocation
import UIKit
import MapKit

class AGPUMapViewController: UIViewController, CLLocationManagerDelegate {
    
    private let mapView = MKMapView()
    private let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        makeConstraints()
        makeClearPathButton()
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func makeClearPathButton() {
        let clearButton = UIBarButtonItem(title: "очистить путь", style: .plain, target: self, action: #selector(clearPath))
        clearButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = clearButton
    }
    
    @objc private func clearPath() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)
        
        // MARK: - АГПУ корпуса координаты
        
        // Главный корпус
        let MainBuildingCoordinate = CLLocationCoordinate2D(latitude: 45.001245, longitude: 41.133068)
        
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
        
        // Корпус №1
        let building1Pin = MKPointAnnotation()
        building1Pin.coordinate = building1Coordinate
        building1Pin.title = "Корпус №1"
        
        // Корпус №2
        let building2Pin = MKPointAnnotation()
        building2Pin.coordinate = building2Coordinate
        building2Pin.title = "Корпус №2"
        
        // Корпус №3 (СПФ)
        let building3Pin = MKPointAnnotation()
        building3Pin.coordinate = building3Coordinate
        building3Pin.title = "Корпус №3 (СПФ)"
        
        // Корпус №4 (ФТЭиД)
        let building4Pin = MKPointAnnotation()
        building4Pin.coordinate = building4Coordinate
        building4Pin.title = "Корпус №4 (ФТЭиД)"
        
        // Корпус №5
        let building5Pin = MKPointAnnotation()
        building5Pin.coordinate = building5Coordinate
        building5Pin.title = "Корпус №5"
        
        // Корпус №6 (ФОК)
        let building6Pin = MKPointAnnotation()
        building6Pin.coordinate = building6Coordinate
        building6Pin.title = "Корпус №6 (ФОК)"
        
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
    
    func mapThis(destinationCord: CLLocationCoordinate2D) {
        
        let sourceCoordinate = (manager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Ошибка: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension AGPUMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .green
        return render
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation
        {
            self.mapThis(destinationCord: annotation.coordinate)
        }
    }
}
