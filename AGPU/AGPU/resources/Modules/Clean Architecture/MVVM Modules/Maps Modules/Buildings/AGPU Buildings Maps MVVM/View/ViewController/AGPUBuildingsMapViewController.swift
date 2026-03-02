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
    
    weak var delegate: ScreenClosedDelegate?
    
    var isSettings = false
    var isAction = false
    var isNotify = false
    var isTab = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigation()
        setUpMap()
        makeConstraints()
        setUpNavigationBarGestures()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkVoiceCommandsOption()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelRecognition()
    }

    private func setUpNavigation() {
        
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        
        let button2 = UIButton()
        button2.tintColor = .label
        button2.setImage(UIImage(named: "cross"), for: .normal)
        button2.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        let closeButton = UIBarButtonItem(customView: button2)
        
        let searchBuilding = UIAction(title: "Нужное здание") { _ in
            let vc = NearBuildingViewController(info: .map)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        let buidlingsList = UIAction(title: "Корпуса") { _ in
            let vc = BuildingsListTableViewController(currentLocation: self.viewModel.arr[self.viewModel.index], annotations: self.viewModel.arr)
            vc.delegate = self
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let voiceCommands = UIAction(title: "Голосовые команды") { _ in
            let vc = VoiceCommandsListTableViewController(type: .mapCorps)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let pseyAction = UIAction(title: "Псевдонимы") { _ in
            let vc = PseudonymListViewController(category: PseudonymCategories.buildings)
            vc.isModal = true
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
        
        let menu = UIMenu(title: "Карта", children: [searchBuilding, buidlingsList, voiceCommands, pseyAction])
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        options.tintColor = .label
        
        navigationItem.title = "Текущая локация..."
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        if !isTab {
            if isAction {
                navigationItem.leftBarButtonItem = closeButton
            } else {
                navigationItem.leftBarButtonItem = backButton
            }
        }
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeScreen() {
        if isNotify {
            delegate?.screenWasClosed()
        }
        HapticsManager.shared.hapticFeedback()
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
    
    private func setUpNavigationBarGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(pastLocation))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextLocation))
        swipeRight.direction = .right
        self.navigationController?.navigationBar.addGestureRecognizer(swipeLeft)
        self.navigationController?.navigationBar.addGestureRecognizer(swipeRight)
    }
    
    @objc func pastLocation() {
        guard let region = viewModel.pastLocation() else {return}
        if !viewModel.arr.isEmpty {
            setRegion(region: region)
        }
    }
        
    @objc func nextLocation() {
        guard let region = viewModel.nextLocation() else {return}
        if !viewModel.arr.isEmpty {
            setRegion(region: region)
        }
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
        viewModel.alertMicHandler = { isPresent, title, message in
            if isPresent {
                let goToSettings = UIAlertAction(title: "Перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in}
                self.showAlert(title: title, message: message, actions: [goToSettings, cancel])
            }
        }
        viewModel.checkLocationAuthorizationStatus()
        viewModel.registerLocationHandler { location in
            let titleView = CustomTitleView(image: "marker icon", title: "Найти кампус", frame: .zero)
            self.navigationItem.titleView = titleView
            self.mapView.showAnnotations(location.pins, animated: true)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                if !self.viewModel.arr.isEmpty {
                    self.setRegion(region: self.viewModel.defaultLocation())
                }
            }
        }
        viewModel.registerChoiceHandler { isBuildingType, annotation in
            let titleView = CustomTitleView(image: "search", title: "Поиск...", frame: .zero)
            self.navigationItem.titleView = titleView
            if isBuildingType {
                self.mapView.addAnnotation(annotation)
            } else {
                self.mapView.removeAnnotation(annotation)
            }
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                if !self.viewModel.arr.isEmpty {
                    self.setRegion(region: self.viewModel.defaultLocation())
                }
            }
        }
        viewModel.registerVoiceChoiceHandler { location in
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            self.setRegion(region: region)
        }
    }
    
    func setRegion(region: MKCoordinateRegion) {
        UIView.animate(withDuration: 1) {
            self.mapView.setRegion(region, animated: true)
        } completion: { _ in
            if self.viewModel.index == 0 {
                let titleView = CustomTitleView(image: "marker icon", title: "Текущая локация", frame: .zero)
                self.navigationItem.titleView = titleView
            } else {
                let titleView = CustomTitleView(image: "marker icon", title: self.viewModel.makeNavigationTitle(), frame: .zero)
                self.navigationItem.titleView = titleView
            }
            HapticsManager.shared.hapticFeedback()
        }
    }
}
