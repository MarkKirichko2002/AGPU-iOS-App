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
        
        let options = UIBarButtonItem(image: UIImage(named: "sections"), menu: MakeMenu())
        options.tintColor = .black
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = options
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    private func MakeMenu()-> UIMenu {
        
        let all = UIAction(title: "все") { _ in
            for building in AGPUBuildings.buildings {
                self.mapView.addAnnotation(building.pin)
            }
        }
        
        let buildings = UIAction(title: "корпуса") { _ in
            for building in AGPUBuildings.buildings {
                if building.type == .building || building.type == .buildingAndHostel {
                    self.mapView.addAnnotation(building.pin)
                } else {
                    self.mapView.removeAnnotation(building.pin)
                }
            }
        }
        
        let hostels = UIAction(title: "общежития") { _ in
            for building in AGPUBuildings.buildings {
                if building.type == .hostel || building.type == .buildingAndHostel {
                    self.mapView.addAnnotation(building.pin)
                } else {
                    self.mapView.removeAnnotation(building.pin)
                }
            }
        }
        
        let menu = UIMenu(title: "показать на карте", options: .singleSelection, children: [
            all,
            buildings,
            hostels
        ])
        return menu
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
        viewModel.GetLocation()
        viewModel.registerLocationHandler { location in
            self.mapView.setRegion(location.region, animated: true)
            self.mapView.showAnnotations(location.pins, animated: true)
        }
    }
}
