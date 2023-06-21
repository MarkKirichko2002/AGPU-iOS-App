//
//  UIView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach ({
           addSubview($0)
        })
    }
}
