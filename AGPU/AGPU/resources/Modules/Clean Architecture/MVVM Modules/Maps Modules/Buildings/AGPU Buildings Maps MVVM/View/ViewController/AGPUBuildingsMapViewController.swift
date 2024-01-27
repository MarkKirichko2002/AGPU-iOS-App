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
    let viewModel = AGPUBuildingsMapViewModel()
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpMap()
        makeConstraints()
        setUpButtons()
        bindViewModel()
    }
    
    private func setUpNavigation() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        
        let typeList = UIAction(title: "Корпуса") { _ in
            let vc = AGPUBuildingTypesListTableViewController(type: self.viewModel.type)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let facultiesList = UIAction(title: "Кафедры") { _ in
            let vc = FacultyCathedraMapListTableViewController(faculty: self.viewModel.faculty)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let menu = UIMenu(title: "Карта", children: [typeList, facultiesList])
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        options.tintColor = .label
        
        navigationItem.title = "Найти «АГПУ»"
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func back() {
        sendScreenWasClosedNotification()
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
    
    private func setUpButtons() {
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "backward"), style: .plain, target: self, action: #selector(pastLocation))
        leftButton.tintColor = .label
        let rightButton = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(nextLocation))
        rightButton.tintColor = .label
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar()
        toolbar.items = [leftButton, flexibleSpace, rightButton]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: (view.bounds.height / 4) / 2 / 1.5)
        ])
    }
    
    @objc private func nextLocation() {
        if index < AGPUBuildingPins.pins.count - 1 {
            index += 1
            // Определение региона для прокрутки и увеличения
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001) // Задание масштаба
            let region = MKCoordinateRegion(center: AGPUBuildingPins.pins[index].coordinate, span: span)
            // Прокрутка и увеличение до метки на карте
            UIView.animate(withDuration: 1) {
                self.mapView.setRegion(region, animated: true)
            } completion: { _ in
                self.navigationItem.title = AGPUBuildingPins.pins[self.index].title
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    @objc private func pastLocation() {
        if index > 0 {
            index -= 1
            // Определение региона для прокрутки и увеличения
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001) // Задание масштаба
            let region = MKCoordinateRegion(center: AGPUBuildingPins.pins[index].coordinate, span: span)
            // Прокрутка и увеличение до метки на карте
            UIView.animate(withDuration: 1) {
                self.mapView.setRegion(region, animated: true)
            } completion: { _ in
                self.navigationItem.title = AGPUBuildingPins.pins[self.index].title
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.observeBuildingTypeSelected()
        viewModel.observeFacultySelected()
        viewModel.alertHandler = { bool in
            if bool {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                self.showAlert(title: "Геопозиция выключена", message: "Хотите включить в настройках?", actions: [goToSettings, cancel])
            } else {
                fatalError()
            }
        }
        viewModel.checkLocationAuthorizationStatus()
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
