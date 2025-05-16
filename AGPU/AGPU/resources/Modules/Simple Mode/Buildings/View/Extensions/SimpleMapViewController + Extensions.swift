//
//  SimpleMapViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2024.
//

import MapKit

// MARK: - MKMapViewDelegate
extension SimpleMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let url = URL(string: "http://maps.apple.com/?q=\(view.annotation?.coordinate.latitude ?? 0),\(view.annotation?.coordinate.longitude ?? 0)")!
        UIApplication.shared.open(url)
    }
}
