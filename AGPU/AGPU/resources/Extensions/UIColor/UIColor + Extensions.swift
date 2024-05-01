//
//  UIColor + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.04.2024.
//

import UIKit

extension UIColor: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        let components = self.cgColor.components
        
        try container.encode(components)
    }
}
