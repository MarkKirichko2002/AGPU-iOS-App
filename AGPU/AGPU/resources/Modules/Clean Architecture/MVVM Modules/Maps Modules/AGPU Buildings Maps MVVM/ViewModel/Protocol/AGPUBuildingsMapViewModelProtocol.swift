//
//  AGPUBuildingsMapViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 23.07.2023.
//

import UIKit
import MapKit

protocol AGPUBuildingsMapViewModelProtocol {
    var locationHandler: ((LocationModel)->Void)? {get set}
    var choiceHandler: ((Bool, MKAnnotation)->Void)? {get set}
    func CheckLocationAuthorizationStatus()
    func GetLocation()
    func registerLocationHandler(block: @escaping(LocationModel)->Void)
    func registerChoiceHandler(block: @escaping(Bool, MKAnnotation)->Void)
    func makeOptionsMenu()-> UIMenu
}
