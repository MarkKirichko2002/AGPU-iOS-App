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
        setUpNavigation()
        bindViewModel()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.saveLocation(annotaion: annotation)
    }
    
    private func setUpView() {
        LocationDetail.text = !annotation.subtitle!!.isEmpty ? annotation.subtitle!! : "Нет информации"
        LocationDetail.textColor = UIColor.label
        WeatherLabel.textColor = UIColor.label
        PairsExistence.textColor = UIColor.label
        setUpTitleLabel()
        setUpLabel()
        setUpLocationDetailLabel()
        setUpWeatherLabel()
    }
    
    private func setUpTitleLabel() {
        viewModel.setUpBuildingName()
        LocationName.text = annotation.title!
        LocationName.textColor = UIColor.label
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
    
    private func setUpLocationDetailLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAudenciesList))
        LocationDetail.isUserInteractionEnabled = true
        LocationDetail.addGestureRecognizer(tap)
    }
    
    @objc private func showAudenciesList() {
        let audencies = viewModel.makeAudenciesList()
        let vc = AudenciesListTableViewController(name: annotation.title!!, audencies: audencies)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        if audencies.count > 1 {
            present(navVC, animated: true)
            HapticsManager.shared.hapticFeedback()
        } else {
            showAlert(title: "Нет аудиторий!", message: "в корпусе нет аудиторий", actions: [UIAlertAction(title: "ОК", style: .default)])
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
        closeButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        setUpMenu()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu() {
        
        let ARAction = UIAction(title: "AR режим") { _ in
            let vc = ARViewController()
            guard let building = AGPUBuildings.buildings.first(where: { $0.name == self.annotation.title! }) else {return}
            if building.image != "img" {
                vc.image = UIImage(named: building.image)!
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            } else {
                self.showAlert(title: "Нет изображений", message: "у данного корпуса нет изображений", actions: [UIAlertAction(title: "ОК", style: .default)])
            }
        }
        
        let timetableAction = UIAction(title: "Расписание") { _ in
            self.showTimetableDetail()
        }
        
        let audenciesListAction = UIAction(title: "Аудитории") { _ in
            self.showAudenciesList()
        }
        
        let weatherAction = UIAction(title: "Погода") { _ in
            self.showWeatherDetail()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.showShareVC()
        }
        
        let menu = UIMenu(title: annotation.title!!, children: [
            ARAction,
            timetableAction,
            audenciesListAction,
            weatherAction,
            shareAction
        ])
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .label
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func showShareVC() {
        let vc = ShareLocationAppsViewController(annotation: annotation)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func bindViewModel() {
        viewModel = AGPUBuildingDetailViewModel(annotation: annotation, id: id, owner: owner)
        viewModel.setUpBuildingName()
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
