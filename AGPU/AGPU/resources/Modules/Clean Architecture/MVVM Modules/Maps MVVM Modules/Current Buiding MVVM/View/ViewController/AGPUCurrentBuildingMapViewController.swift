//
//  AGPUCurrentBuildingMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import UIKit
import MapKit

class AGPUCurrentBuildingMapViewController: UIViewController {

    private var audienceID: String!
    
    // MARK: - сервисы
    private var viewModel: AGPUCurrentBuildingMapViewModel!
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    // MARK: - Init
    init(audienceID: String) {
        self.audienceID = audienceID
        self.viewModel = AGPUCurrentBuildingMapViewModel(audienceID: audienceID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = viewModel.CurrentBuilding().title!
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
