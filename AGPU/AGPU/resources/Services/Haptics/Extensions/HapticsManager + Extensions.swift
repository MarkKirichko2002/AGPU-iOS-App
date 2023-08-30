//
//  HapticsManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 09.07.2023.
//

import UIKit

// MARK: - HapticsManagerProtocol
extension HapticsManager: HapticsManagerProtocol {
    
    func hapticFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
}
