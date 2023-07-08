//
//  HapticsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.07.2023.
//

import UIKit

// MARK: - HapticsManagerProtocol
extension HapticsManager: HapticsManagerProtocol {
    
    func HapticFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
}
