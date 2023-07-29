//
//  FacultyCathedraModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.07.2023.
//

import MapKit

struct FacultyCathedraModel: Codable {
    let name: String
    let url: String
    let address: String
    let coordinates: [Double]
    let email: String
    let manualUrl: String
    let additionalEducationUrl: String
}
