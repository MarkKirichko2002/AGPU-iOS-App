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
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        makeConstraints()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        let AGPUcoordinate = CLLocationCoordinate2D(latitude: 45.001245, longitude: 41.133068)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)
        
        // текущая геопозиция
        let currentpin = MKPointAnnotation()
        currentpin.coordinate = coordinate
        currentpin.title = "текущая геопозиция"
        
        // АГПУ
        let AGPUpin = MKPointAnnotation()
        AGPUpin.coordinate = AGPUcoordinate
        AGPUpin.title = "АГПУ"
        mapView.showAnnotations([currentpin, AGPUpin], animated: true)
    }
}
