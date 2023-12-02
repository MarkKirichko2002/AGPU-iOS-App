//
//  AGPUBuildingDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 30.11.2023.
//

import WeatherKit
import Foundation
import MapKit
import UIKit

class AGPUBuildingDetailViewModel {
    
    var annotation: MKAnnotation!
    
    var pairsHandler: ((String)->Void)?
    var pairsColorHandler: ((UIColor)->Void)?
    var weatherHandler: ((String)->Void)?
    
    // MARK: - сервисы
    let dateManager = DateManager()
    let timetableService = TimeTableService()
    
    // MARK: - Init
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
}
