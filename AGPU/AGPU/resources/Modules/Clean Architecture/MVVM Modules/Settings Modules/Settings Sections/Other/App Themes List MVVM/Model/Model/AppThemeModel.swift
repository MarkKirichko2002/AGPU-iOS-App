//
//  File.swift
//  AGPU
//
//  Created by Марк Киричко on 22.09.2023.
//

import UIKit

struct AppThemeModel: Codable {
    let name: String
    let theme: UIUserInterfaceStyle
}

extension UIUserInterfaceStyle: Codable {
    
}
