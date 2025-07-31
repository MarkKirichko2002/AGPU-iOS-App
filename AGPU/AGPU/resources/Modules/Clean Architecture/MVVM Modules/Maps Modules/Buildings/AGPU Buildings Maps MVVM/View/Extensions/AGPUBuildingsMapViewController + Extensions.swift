//
//  AGPUBuildingsMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 22.06.2023.
//

import MapKit

// MARK: - MKMapViewDelegate
extension AGPUBuildingsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let heading = Int(mapView.camera.heading)
        if (45..<135).contains(heading) {
            mapView.camera.heading = 0
            pastLocation()
        } else if (225..<315).contains(heading) {
            mapView.camera.heading = 0
            nextLocation()
        }
    }
    
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
                vc.id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-3-1"
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

// MARK: - BuildingListTableViewControllerDelegate
extension AGPUBuildingsMapViewController: BuildingsListTableViewControllerDelegate {
    
    func buildingWasSelected(location: (MKAnnotation, Int)) {
        let region = MKCoordinateRegion(center: location.0.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        viewModel.index = location.1
        viewModel.checkButton()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.setRegion(region: region)
        }
    }
}
