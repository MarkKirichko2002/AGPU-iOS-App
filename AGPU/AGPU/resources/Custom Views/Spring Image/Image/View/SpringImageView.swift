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
    var option = ASPUButtonAnimationOptions.spring
    
    weak var delegate: SpringImageViewDelegate?
    
    override func layoutSubviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        setUpInteraction()
    }
    
    private func setUpInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        if isInteraction {
            self.addInteraction(interaction)
        }
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        delegate?.imageWasTapped()
        switch option {
        case .spring:
            self.animation.springAnimation(view: self)
            HapticsManager.shared.hapticFeedback()
        case .flipFromTop:
            self.animation.flipAnimation(view: self, option: .transitionFlipFromTop) {
                HapticsManager.shared.hapticFeedback()
            }
        case .flipFromRight:
            self.animation.flipAnimation(view: self, option: .transitionFlipFromRight) {
                HapticsManager.shared.hapticFeedback()
            }
        case .flipFromLeft:
            self.animation.flipAnimation(view: self, option: .transitionFlipFromLeft) {
                HapticsManager.shared.hapticFeedback()
            }
        case .flipFromBottom:
            self.animation.flipAnimation(view: self, option: .transitionFlipFromBottom) {
                HapticsManager.shared.hapticFeedback()
            }
        case .none:
            HapticsManager.shared.hapticFeedback()
        }
    }
}
