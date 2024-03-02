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
        setUpNavigation()
        setUpWeatherLabel()
        bindViewModel()
    }
    
    private func setUpView() {
        LocationName.text = annotation.title!
        LocationDetail.text = annotation.subtitle!
        LocationName.textColor = UIColor.label
        LocationDetail.textColor = UIColor.label
        WeatherLabel.textColor = UIColor.label
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
        let shareYandexMaps = UIAlertAction(title: "С помощью Яндекс Карты", style: .default) { _ in
            self.shareLocationWithYandexMaps()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive) { _ in}
        self.showAlert(title: "Поделиться локацией", message: "Как вы хотите поделиться локацией?", actions: [shareAppleMaps, shareGoogleMaps, shareYandexMaps, cancel])
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
    
    private func shareLocationWithYandexMaps() {
        let title = annotation.title!! + " (Яндекс Карты)"
        let url = "https://maps.yandex.ru/?pt=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)&z=14"
        shareInfo(image: UIImage(named: "map icon")!, title: title, text: "\(title)-\(url)")
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
        present(vc, animated: true)
    }
}
