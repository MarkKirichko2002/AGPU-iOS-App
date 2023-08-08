//
//  SpringRoundedImageView.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import UIKit

class SpringRoundedImageView: UIImageView {
    
    private let animation = AnimationClass()
    var color = UIColor.black
    var borderWidth = 3
    var music = ""
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        animation.SpringAnimation(view: self)
    }
}

