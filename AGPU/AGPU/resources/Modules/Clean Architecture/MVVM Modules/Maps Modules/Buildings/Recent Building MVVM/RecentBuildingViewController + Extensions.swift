//
//  RecentBuildingViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.08.2024.
//

import MapKit

// MARK: - MKMapViewDelegate
extension RecentBuildingViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title!
        if title!.contains("Кафедра") {
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
        
        if title != "Вы" && !title!.contains("Кафедра")  {
            let storyboard = UIStoryboard(name: "AGPUBuildingDetailViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AGPUBuildingDetailViewController") as? AGPUBuildingDetailViewController {
                vc.annotation = view.annotation!
                vc.id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
                vc.owner = UserDefaults.standard.string(forKey: "recentOwner") ?? "GROUP"
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
