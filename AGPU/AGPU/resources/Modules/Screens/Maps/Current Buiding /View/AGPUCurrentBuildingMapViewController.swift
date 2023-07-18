//
//  AGPUCurrentBuildingMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import CoreLocation
import UIKit
import MapKit

class AGPUCurrentBuildingMapViewController: UIViewController {

    private var audienceID: String!
    
    // MARK: - сервисы
    private let manager = CLLocationManager()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    // MARK: - Init
    init(audienceID: String) {
        self.audienceID = audienceID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = CurrentBuilding().title!
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
    
    func CurrentBuilding()-> MKAnnotation {
        
        for location in AGPUPins.pins {
            let audiences = location.subtitle!.components(separatedBy: " ")
            for audience in audiences {
                if audience.contains(audienceID) {
                    print(audience)
                    return location
                }
            }
        }
        
        if audienceID.contains("ФОК") {
            return AGPUPins.pins[6]
        }
        
        return AGPUPins.pins[0]
    }
    
    func render(_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate,
                                        span: span)
        
        mapView.setRegion(region,
                          animated: true)
      
        // текущая геопозиция
        let currentpin = MKPointAnnotation()
        currentpin.coordinate = coordinate
        currentpin.title = "Вы"
              
        let building = CurrentBuilding()
        
        mapView.showAnnotations([
            currentpin,
            building
        ], animated: true)
    }
}
