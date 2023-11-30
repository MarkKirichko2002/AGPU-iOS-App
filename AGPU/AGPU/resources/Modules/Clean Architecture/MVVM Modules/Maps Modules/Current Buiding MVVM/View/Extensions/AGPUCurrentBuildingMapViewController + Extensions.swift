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

