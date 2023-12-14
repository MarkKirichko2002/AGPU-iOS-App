//
//  VoiceSearchAGPUBuildingMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit
import MapKit

class VoiceSearchAGPUBuildingMapViewController: UIViewController {
    
    private var building: AGPUBuildingModel!
    
    // MARK: - сервисы
    private var viewModel: SearchAGPUBuildingMapViewModel!
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    // MARK: - Init
    init(building: AGPUBuildingModel) {
        self.building = building
        self.viewModel = SearchAGPUBuildingMapViewModel(building: building)
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
        bindViewModel()
    }
    
    private func setUpNavigation() {
        navigationItem.title = building.name
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        sendScreenWasClosedNotification()
        dismiss(animated: true)
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
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                    self.dismiss(animated: true)
                }
                self.showAlert(title: "Геопозиция выключена", message: "Хотите включить в настройках?", actions: [goToSettings, cancel])
            } else {}
        }
        viewModel.checkLocationAuthorizationStatus()
        viewModel.registerLocationHandler { location in
            DispatchQueue.main.async {
                self.mapView.setRegion(location.region, animated: true)
                self.mapView.showAnnotations(location.pins, animated: true)
            }
        }
        viewModel.observeActions { action in
            switch action {
            case .closeScreen:
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .forward:
                break
            case .back:
                break
            }
        }
        viewModel.observeBuildingSelected { pin in
            self.mapView.annotations.forEach { annotation in
                if annotation.title != "Вы" {
                    DispatchQueue.main.async {
                        self.navigationItem.title = pin.title!
                        self.mapView.removeAnnotation(annotation)
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
}
