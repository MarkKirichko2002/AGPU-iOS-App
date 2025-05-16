//
//  LocationManager.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation
import MapKit

final class LocationManager: NSObject {
    
    var manager = CLLocationManager()
    var type = MKDirectionsTransportType.walking
    
    var locationHandler: ((CLLocation)->Void)?
    var isUpdates = false
    
    func registerLocationHandler(block: @escaping(CLLocation)->Void) {
        self.locationHandler = block
    }
}
