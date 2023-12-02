//
//  CathedraBuildingDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.12.2023.
//

import WeatherKit
import Foundation
import MapKit
import UIKit

class CathedraBuildingDetailViewModel {
    
    var annotation: MKAnnotation!
    
    var weatherHandler: ((String)->Void)?
    
    // MARK: - Init
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
}
