//
//  AGPUSecondMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import CoreLocation
import MapKit

// MARK: - CLLocationManagerDelegate
extension AGPUSecondMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension AGPUSecondMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation
        {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
            mapItem.name = annotation.title ?? ""
            let yes = UIAlertAction(title: "да", style: .default) { _ in
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            let cancel = UIAlertAction(title: "нет", style: .default) { _ in}
            self.ShowAlert(
                title: "Вы хотите начать путь до: \"\(mapItem.name ?? "")\"?",
                message: "",
                actions: [cancel, yes]
            )
        }
    }
}
