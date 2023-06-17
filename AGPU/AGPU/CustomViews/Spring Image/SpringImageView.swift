//
//  SpringImageView.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import UIKit

class SpringImageView: UIImageView {
    
    private let animation = AnimationClass()
    
    override func layoutSubviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        animation.SpringAnimation(view: self)
    }
}
