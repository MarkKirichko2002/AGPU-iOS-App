//
//  LocationManager.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import CoreLocation

final class LocationManager: NSObject {
    
    var manager = CLLocationManager()
    
    var locationHandler: ((CLLocation)->Void)?
    
    func registerLocationHandler(block: @escaping(CLLocation)->Void) {
        self.locationHandler = block
    }
}
