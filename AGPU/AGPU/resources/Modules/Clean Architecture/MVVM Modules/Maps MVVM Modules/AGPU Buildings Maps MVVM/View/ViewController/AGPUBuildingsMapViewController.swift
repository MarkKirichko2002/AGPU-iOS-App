//
//  AGPUBuildingsMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2023.
//

import UIKit
import MapKit

class AGPUBuildingsMapViewController: UIViewController {
    
    // MARK: - сервисы
    private let viewModel = AGPUBuildingsMapViewModel()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Найти «АГПУ»"
        SetUpMap()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.GetLocation()
        viewModel.registerLocationHandler { location in
            self.mapView.setRegion(
                location.region,
                animated: true
            )
            self.mapView.showAnnotations(
                location.pins
                , animated: true
            )
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("for student appear"), object: nil)
    }
    
    private func SetUpMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
