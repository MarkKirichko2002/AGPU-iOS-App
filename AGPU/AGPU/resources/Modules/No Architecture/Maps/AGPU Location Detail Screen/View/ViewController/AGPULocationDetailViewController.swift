//
//  AGPULocationDetailViewController.swift
//  AGPU
//
//  Created by Марк Киричко on 17.07.2023.
//

import UIKit
import MapKit

final class AGPULocationDetailViewController: UIViewController {
    
    var annotation: MKAnnotation!
    
    @IBOutlet var LocationName: UILabel!
    @IBOutlet var LocationDetail: UILabel!
    @IBOutlet var WeatherLabel: UILabel!
    
    // MARK: - Init
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        setUpView()
    }
    
    private func setUpNavigation() {
        navigationItem.title = "Найти «АГПУ»"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeScreen))
        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(showShareAlert))
        closeButton.tintColor = .label
        shareButton.tintColor = .label
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    @objc private func showShareAlert() {
        let shareAppleMaps = UIAlertAction(title: "С помощью Apple Maps", style: .default) { _ in
            self.shareLocationWithAppleMaps()
        }
        let shareGoogleMaps = UIAlertAction(title: "С помощью Google Maps", style: .default) { _ in
            self.shareLocationWithGoogleMaps()
        }
        self.showAlert(title: "Поделиться локацией", message: "Как вы хотите поделиться локацией?", actions: [shareAppleMaps, shareGoogleMaps])
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
    
    private func setUpView() {
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        LocationName.text = annotation.title!
        LocationDetail.text = annotation.subtitle!
        WeatherManager.shared.getWeather(location: location) { weather in
            DispatchQueue.main.async {
                self.WeatherLabel.text = "Погода: \(WeatherManager.shared.formatWeather(weather: weather))"
            }
        }
    }
    
    @IBAction func GoToMap() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
        mapItem.name = annotation.title ?? ""
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
