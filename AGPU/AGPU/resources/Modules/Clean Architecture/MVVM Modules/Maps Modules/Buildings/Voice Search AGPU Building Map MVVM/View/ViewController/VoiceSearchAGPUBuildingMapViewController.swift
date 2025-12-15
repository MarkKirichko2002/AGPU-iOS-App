//
//  VoiceSearchAGPUBuildingMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import UIKit
import MapKit

final class VoiceSearchAGPUBuildingMapViewController: UIViewController {
    
    private var building: AGPUBuildingModel!
    weak var delegate: ScreenClosedDelegate?
    
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
        let titleView = CustomTitleView(image: "marker icon", title: building.name, frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        delegate?.screenWasClosed()
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
                self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [goToSettings, cancel])
            }
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
                        let titleView = CustomTitleView(image: "marker icon", title: pin.title!!, frame: .zero)
                        self.navigationItem.titleView = titleView
                        self.mapView.removeAnnotation(annotation)
                        self.mapView.addAnnotation(pin)
                        let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                        self.setRegion(region: region)
                    }
                }
            }
        }
    }
    
    private func setRegion(region: MKCoordinateRegion) {
        UIView.animate(withDuration: 1) {
            self.mapView.setRegion(region, animated: true)
        } completion: { _ in
            HapticsManager.shared.hapticFeedback()
        }
    }
}
