//
//  InteractiveView.swift
//  AGPU
//
//  Created by Марк Киричко on 02.08.2023.
//

import UIKit

final class InteractiveView: UIView {
    
    var tapAction: (() -> Void)?
    
    override func layoutSubviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        HapticsManager.shared.HapticFeedback()
        tapAction?()
    }
}
