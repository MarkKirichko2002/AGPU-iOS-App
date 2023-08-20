//
//  AGPUBuildingsMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 19.06.2023.
//

import UIKit
import MapKit

final class AGPUBuildingsMapViewController: UIViewController {
    
    // MARK: - сервисы
    private let viewModel = AGPUBuildingsMapViewModel()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUpNavigation()
        SetUpMap()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = "Найти «АГПУ»"
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .black
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: viewModel.makeOptionsMenu())
        options.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func back() {
        viewModel.SendScreenClosedNotification()
        navigationController?.popViewController(animated: true)
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
    
    private func BindViewModel() {
        viewModel.alertHandler = { bool in
            if bool {
                let goToSettings = UIAlertAction(title: "перейти в настройки", style: .default) { _ in
                    self.OpenSettings()
                }
                let cancel = UIAlertAction(title: "отмена", style: .cancel) { _ in
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                self.ShowAlert(title: "Геопозиция выключена", message: "хотите включить в настройках?", actions: [goToSettings, cancel])
            } else {
                fatalError()
            }
        }
        viewModel.CheckLocationAuthorizationStatus()
        viewModel.registerLocationHandler { location in
            self.mapView.setRegion(location.region, animated: true)
            self.mapView.showAnnotations(location.pins, animated: true)
        }
        viewModel.registerChoiceHandler { isBuildingType, annotation in
            if isBuildingType {
                self.mapView.addAnnotation(annotation)
            } else {
                self.mapView.removeAnnotation(annotation)
            }
        }
    }
}
