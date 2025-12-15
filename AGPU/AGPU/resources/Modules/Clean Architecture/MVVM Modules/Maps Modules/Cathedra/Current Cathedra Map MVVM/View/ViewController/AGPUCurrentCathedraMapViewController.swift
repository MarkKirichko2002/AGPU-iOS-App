//
//  AGPUCurrentCathedraMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit
import MapKit

final class AGPUCurrentCathedraMapViewController: UIViewController {
    
    var cathedra: FacultyCathedraModel!
    
    // MARK: - сервисы
    private var viewModel: AGPUCurrentCathedraMapViewModel!
    
    // MARK: - UI
    private let mapView = MKMapView()
    
    // MARK: - Init
    init(cathedra: FacultyCathedraModel) {
        self.cathedra = cathedra
        self.viewModel = AGPUCurrentCathedraMapViewModel(cathedra: cathedra)
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
        let titleView = CustomTitleView(image: "\(viewModel.getCurrentFaculty().icon)", title: "Кафедра \(viewModel.getCurrentFaculty().abbreviation)", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
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
            self.mapView.setRegion(location.region, animated: true)
            self.mapView.showAnnotations(location.pins, animated: true)
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
