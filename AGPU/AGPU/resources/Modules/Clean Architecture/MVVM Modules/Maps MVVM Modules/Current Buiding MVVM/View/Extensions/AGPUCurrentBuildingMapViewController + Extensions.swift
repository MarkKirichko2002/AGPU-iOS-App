//
//  AGPUCurrentBuildingMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import MapKit

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
