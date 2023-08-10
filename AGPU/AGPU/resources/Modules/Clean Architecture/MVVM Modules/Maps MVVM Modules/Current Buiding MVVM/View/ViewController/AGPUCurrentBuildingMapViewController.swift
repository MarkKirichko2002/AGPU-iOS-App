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
    init(
        audienceID: String
    ) {
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
        SetUpNavigation()
        SetUpMap()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BindViewModel()
    }
    
    private func SetUpNavigation() {
        
        navigationItem.title = viewModel.CurrentBuilding().title!
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backButton = UIBarButtonItem(customView: button)
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func back() {
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
    }
}
