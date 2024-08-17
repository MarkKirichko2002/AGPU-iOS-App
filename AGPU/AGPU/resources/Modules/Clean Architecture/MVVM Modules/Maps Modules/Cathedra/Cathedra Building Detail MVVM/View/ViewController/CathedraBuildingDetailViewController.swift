//
//  CathedraBuildingDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2023.
//

import UIKit
import MapKit

class CathedraBuildingDetailViewController: UIViewController {

    var annotation: MKAnnotation!
    
    // MARK: - сервисы
    var viewModel: CathedraBuildingDetailViewModel!
    
    // MARK: - UI
    @IBOutlet var LocationName: UILabel!
    @IBOutlet var LocationDetail: UILabel!
    @IBOutlet var WeatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindViewModel()
        setUpNavigation()
        setUpTitleLabel()
        setUpWeatherLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.saveLocation(annotaion: annotation)
    }
    
    private func setUpView() {
        LocationName.text = annotation.title!
        LocationDetail.text = annotation.subtitle!
        LocationName.textColor = UIColor.label
        LocationDetail.textColor = UIColor.label
        WeatherLabel.textColor = UIColor.label
    }
    
    private func setUpNavigation() {
        let info = viewModel.getInfo()
        let titleView = CustomTitleView(image: info.1.icon, title: "Кафедра \(info.1.abbreviation)", frame: .zero)
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        closeButton.tintColor = .label
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = closeButton
        setUpMenu()
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    private func setUpMenu() {
        
        let weatherAction = UIAction(title: "Погода") { _ in
            self.showWeatherDetail()
        }
        
        let shareAction = UIAction(title: "Поделиться") { _ in
            self.showShareVC()
        }
        
        let menu = UIMenu(title: annotation.title!!, children: [weatherAction, shareAction])
        let sections = UIBarButtonItem(image: UIImage(named: "sections"), menu: menu)
        sections.tintColor = .label
        navigationItem.rightBarButtonItem = sections
    }
    
    @objc private func showShareVC() {
        let vc = ShareLocationAppsViewController(annotation: annotation)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        HapticsManager.shared.hapticFeedback()
    }
    
    private func setUpTitleLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showCathedraInfo))
        LocationName.isUserInteractionEnabled = true
        LocationName.addGestureRecognizer(tap)
    }
    
    @objc private func showCathedraInfo() {
        let info = viewModel.getInfo()
        HapticsManager.shared.hapticFeedback()
        self.goToWeb(url: info.0.url, image: info.1.icon, title: "Кафедра \(info.1.abbreviation)", isSheet: false, isNotify: false)
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
    
    private func bindViewModel() {
        viewModel = CathedraBuildingDetailViewModel(annotation: annotation)
        viewModel.getWeather()
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
