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
        closeButton.tintColor = .label
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
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
