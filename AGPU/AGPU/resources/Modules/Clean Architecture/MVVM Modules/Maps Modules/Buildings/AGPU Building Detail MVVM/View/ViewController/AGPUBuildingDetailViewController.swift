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
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDetail))
        PairsExistence.isUserInteractionEnabled = true
        PairsExistence.addGestureRecognizer(tap)
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Найти кампус"
        let closeButton = UIBarButtonItem(image: UIImage(named: "cross"), style: .plain, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(showShareAlert))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeScreen() {
        HapticsManager.shared.hapticFeedback()
        dismiss(animated: true)
    }
    
    @objc private func showShareAlert() {
        let shareAppleMaps = UIAlertAction(title: "С помощью Apple Maps", style: .default) { _ in
            self.shareLocationWithAppleMaps()
        }
        let shareGoogleMaps = UIAlertAction(title: "С помощью Google Maps", style: .default) { _ in
            self.shareLocationWithGoogleMaps()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Поделиться локацией", message: "Как вы хотите поделиться локацией?", actions: [shareAppleMaps, shareGoogleMaps, cancel])
    }
    
    private func shareLocationWithAppleMaps() {
        let title = annotation.title!! + " (Apple Maps)"
        let url = "http://maps.apple.com/?q=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
    }
    
    private func shareLocationWithGoogleMaps() {
        let title = annotation.title!! + " (Google Maps)"
        let url = "https://www.google.com/maps/search/?api=1&query=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
    }
    
    @objc private func showDetail() {
        HapticsManager.shared.hapticFeedback()
        let vc = TimeTableForCurrentBuildingViewController(timetable: viewModel.getTimeTableForBuilding(pairs: viewModel.disciplines))
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(navVC, animated: true)
        }
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
    
    private func showChooseAppAlert() {
        
        let openAppleMaps = UIAlertAction(title: "С помощью Apple Maps", style: .default) { _ in
            let url = URL(string: "http://maps.apple.com/?q=\(self.annotation.coordinate.latitude),\(self.annotation.coordinate.longitude)")!
            UIApplication.shared.open(url)
        }
        
        let openGoogleMaps = UIAlertAction(title: "С помощью Google Maps", style: .default) { _ in
            let url = URL(string: "comgooglemaps://?q=\(self.annotation.coordinate.latitude),\(self.annotation.coordinate.longitude)")!
            UIApplication.shared.open(url) { canOpen in
                if canOpen {
                    UIApplication.shared.open(url)
                } else {
                    self.showNoGoogleMapsAlert()
                }
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Открыть карты", message: "Как вы хотите открыть карты?", actions: [openAppleMaps, openGoogleMaps, cancel])
    }
    
    private func showNoGoogleMapsAlert() {
        let ok = UIAlertAction(title: "Показать в App Store", style: .default) { _ in
            UIApplication.shared.open(URL(string: "https://apps.apple.com/app/google-maps-transit-food/id585027354")!)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Google Maps не установлено", message: "Хотите установить в App Store?", actions: [ok, cancel])
    }
    
    @IBAction func GoToMap() {
        showChooseAppAlert()
    }
}
