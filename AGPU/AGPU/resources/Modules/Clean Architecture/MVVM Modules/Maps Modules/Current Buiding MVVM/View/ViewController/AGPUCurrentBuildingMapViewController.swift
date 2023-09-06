//
//  AGPUCurrentBuildingMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import UIKit
import MapKit

final class AGPUCurrentBuildingMapViewController: UIViewController {

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
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpMap()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        navigationItem.title = viewModel.currentBuilding().title!
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpMap() {
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
    
    private func bindViewModel() {
        viewModel.alertHandler = { bool in
            if bool {
                let goToSettings = UIAlertAction(title: "перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "отмена", style: .cancel) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                self.showAlert(title: "Геопозиция выключена", message: "хотите включить в настройках?", actions: [goToSettings, cancel])
            } else {
                fatalError()
            }
        }
        viewModel.checkLocationAuthorizationStatus()
        viewModel.registerLocationHandler { location in
            self.mapView.setRegion(location.region, animated: true)
            self.mapView.showAnnotations(location.pins, animated: true)
        }
    }
}
