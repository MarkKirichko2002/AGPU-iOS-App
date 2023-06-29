//
//  AGPUMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import CoreLocation
import MapKit

// MARK: - CLLocationManagerDelegate
extension AGPUMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
}

// MARK: - MKMapViewDelegate
extension AGPUMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        NotificationCenter.default.post(name: Notification.Name("Map Pin Selected"), object: nil)
        if let annotation = view.annotation
        {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
            mapItem.name = annotation.title ?? ""
            let yes = UIAlertAction(title: "да", style: .default) { _ in
                NotificationCenter.default.post(name: Notification.Name("Go To Map"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                    NotificationCenter.default.post(name: Notification.Name("Map Was Opened"), object: nil)
                }
            }
            let cancel = UIAlertAction(title: "нет", style: .default) { _ in
                NotificationCenter.default.post(name: Notification.Name("Map Pin Cancelled"), object: nil)
            }
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.ShowAlert(
                    title: "Вы хотите начать путь до: \"\(mapItem.name ?? "")\"?",
                    message: "",
                    actions: [cancel, yes]
                )
            }
        }
    }
}
