//
//  AGPUCurrentCathedraMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

// MARK: - MKMapViewDelegate
extension AGPUCurrentCathedraMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title != "Вы" {
            let storyboard = UIStoryboard(name: "CathedraBuildingDetailViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CathedraBuildingDetailViewController") as? CathedraBuildingDetailViewController {
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