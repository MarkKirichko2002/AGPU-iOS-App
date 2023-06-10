//
//  UIView + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.06.2023.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {return self.cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
    func addSubviews(_ views: UIView...) {
        views.forEach ({
           addSubview($0)
        })
    }
}
