//
//  SearchAGPUBuildingMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import MapKit

// MARK: - MKMapViewDelegate
extension SearchAGPUBuildingMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "AGPULocationDetailViewController", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "AGPULocationDetailViewController") as? AGPULocationDetailViewController {
            vc.annotation = view.annotation!
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)
        }
    }
}
