//
//  UIApplication + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.04.2025.
//

import UIKit

extension UIApplication {
    
    func isValidURL(url: String)-> Bool {
        if url.contains("http") || url.contains("https") {
            if let url = URL(string: url) {
                if self.canOpenURL(url) {
                    return true
                }
            }
        }
        return false
    }
}
