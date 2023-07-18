//
//  AGPUCurrentBuildingMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import CoreLocation
import MapKit

// MARK: - CLLocationManagerDelegate
extension AGPUCurrentBuildingMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
}

// MARK: - MKMapViewDelegate
extension AGPUCurrentBuildingMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "AGPULocationDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AGPULocationDetailViewController") as? AGPULocationDetailViewController {
            vc.annotation = view.annotation!
            present(vc, animated: true)
        }
    }
}

