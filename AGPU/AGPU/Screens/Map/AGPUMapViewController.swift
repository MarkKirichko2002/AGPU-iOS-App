//
//  AGPUMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 13.06.2023.
//

import UIKit
import MapKit

class AGPUMapViewController: UIViewController {

    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
