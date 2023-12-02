//
//  AGPUBuildingsMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import MapKit

// MARK: - MKMapViewDelegate
extension AGPUBuildingsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title != "Вы" {
            let storyboard = UIStoryboard(name: "AGPUBuildingDetailViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AGPUBuildingDetailViewController") as? AGPUBuildingDetailViewController {
                vc.annotation = view.annotation!
                vc.group = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
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
