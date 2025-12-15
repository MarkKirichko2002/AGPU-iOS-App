//
//  SimpleMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2024.
//

import UIKit
import MapKit

final class SimpleMapViewController: UIViewController {
    
    // MARK: - сервисы
    let viewModel = SimpleMapViewModel()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let titleView = CustomTitleView(image: "marker icon", title: "Найти кампус", frame: .zero)
        self.navigationItem.titleView = titleView
        setUpMap()
        makeConstraints()
        bindViewModel()
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
                    self.navigationController?.popViewController(animated: true)
                }
                self.showAlert(title: self.viewModel.createAlertMessage().0, message: self.viewModel.createAlertMessage().1, actions: [goToSettings, cancel])
            }
        }
        viewModel.checkLocationAuthorizationStatus()
        viewModel.registerLocationHandler { location in
            self.mapView.showAnnotations(location.pins, animated: true)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                if !self.viewModel.arr.isEmpty {
                    self.setRegion(region: location.region)
                }
            }
        }
    }
    
    func setRegion(region: MKCoordinateRegion) {
        UIView.animate(withDuration: 1) {
            self.mapView.setRegion(region, animated: true)
        } completion: { _ in
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func showNearestBuilding(isAction: Bool) {
        let vc = NearBuildingViewController(info: .map)
        vc.isAction = isAction
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
