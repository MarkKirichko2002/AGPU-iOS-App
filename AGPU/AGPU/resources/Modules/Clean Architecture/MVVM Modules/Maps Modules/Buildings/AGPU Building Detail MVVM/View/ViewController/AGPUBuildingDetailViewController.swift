//
//  AGPUBuildingDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.07.2023.
//

import UIKit
import MapKit

final class AGPUBuildingDetailViewController: UIViewController {
    
    var annotation: MKAnnotation!
    var id: String = ""
    var owner: String = ""
    
    // MARK: - сервисы
    var viewModel: AGPUBuildingDetailViewModel!
    
    // MARK: - UI
    @IBOutlet var LocationName: UILabel!
    @IBOutlet var LocationDetail: UILabel!
    @IBOutlet var PairsExistence: UILabel!
    @IBOutlet var WeatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpNavigation()
        setUpLabel()
        setUpWeatherLabel()
        bindViewModel()
    }
    
    private func setUpView() {
        LocationName.text = annotation.title!
        LocationDetail.text = annotation.subtitle!
        LocationName.textColor = UIColor.label
        LocationDetail.textColor = UIColor.label
        WeatherLabel.textColor = UIColor.label
        PairsExistence.textColor = UIColor.label
    }
    
    private func setUpLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showTimetableDetail))
        PairsExistence.isUserInteractionEnabled = true
        PairsExistence.addGestureRecognizer(tap)
    }
    
    @objc private func showTimetableDetail() {
        HapticsManager.shared.hapticFeedback()
        let vc = TimeTableForCurrentBuildingViewController(timetable: viewModel.getTimeTableForBuilding(pairs: viewModel.disciplines))
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(navVC, animated: true)
        }
    }
    
    private func setUpWeatherLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showWeatherDetail))
        WeatherLabel.isUserInteractionEnabled = true
        WeatherLabel.addGestureRecognizer(tap)
    }
    
    @objc private func showWeatherDetail() {
        HapticsManager.shared.hapticFeedback()
        let vc = LocationWeatherDetailViewController(annotation: annotation)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Найти кампус"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(showShareVC))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func showShareVC() {
        let vc = ShareLocationAppsViewController(annotation: annotation)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func bindViewModel() {
        viewModel = AGPUBuildingDetailViewModel(annotation: annotation, id: id, owner: owner)
        viewModel.getTimetable()
        viewModel.getWeather()
        viewModel.registerPairsHandler { pairsInfo in
            DispatchQueue.main.async {
                self.PairsExistence.text = pairsInfo
            }
        }
        viewModel.registerPairsColorHandler { color in
            DispatchQueue.main.async {
                self.PairsExistence.textColor = color
            }
        }
        viewModel.registerWeatherHandler { weatherInfo in
            DispatchQueue.main.async {
                self.WeatherLabel.text = weatherInfo
            }
        }
    }
    
    @IBAction func GoToMap() {
        let vc = LocationAppsViewController(annotation: annotation)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
