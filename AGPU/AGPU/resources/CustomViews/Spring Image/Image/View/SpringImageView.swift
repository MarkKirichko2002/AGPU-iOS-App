//
//  SpringImageView.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import UIKit

final class SpringImageView: UIImageView {
    
    private let animation = AnimationClass()
    var isInteraction = true
    
    override func layoutSubviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        SetUpInteraction()
    }
    
    private func SetUpInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        if isInteraction {
            self.addInteraction(interaction)
        }
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        animation.SpringAnimation(view: self)
        HapticsManager.shared.HapticFeedback()
    }
}
