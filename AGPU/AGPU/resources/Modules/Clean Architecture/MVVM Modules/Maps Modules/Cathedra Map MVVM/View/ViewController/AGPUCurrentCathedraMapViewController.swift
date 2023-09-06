//
//  AGPUCurrentCathedraMapViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import UIKit
import MapKit

class AGPUCurrentCathedraMapViewController: UIViewController {
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    private func setUpNavigation() {
        let titleView = CustomTitleView(image: "\(viewModel.getCurrentFaculty().icon)", title: "\(viewModel.getCurrentFaculty().abbreviation) кафедра", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
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
                let goToSettings = UIAlertAction(title: "перейти в настройки", style: .default) { _ in
                    self.openSettings()
                }
                let cancel = UIAlertAction(title: "отмена", style: .cancel) { _ in
                    self.dismiss(animated: true)
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
