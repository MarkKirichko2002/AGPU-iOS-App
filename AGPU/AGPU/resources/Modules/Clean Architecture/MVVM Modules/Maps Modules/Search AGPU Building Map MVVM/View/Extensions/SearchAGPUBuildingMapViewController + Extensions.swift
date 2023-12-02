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
        if view.annotation?.title != "Вы" {
            let storyboard = UIStoryboard(name: "AGPUBuildingDetailViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AGPUBuildingDetailViewController") as? AGPUBuildingDetailViewController {
                vc.annotation = view.annotation!
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(navVC, animated: true)
                }
            }
            HapticsManager.shared.hapticFeedback()
        }
    }
}
