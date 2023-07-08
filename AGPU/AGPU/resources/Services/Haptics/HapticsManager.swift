//
//  HapticsManager.swift
//  AGPU
//
//  Created by Марк Киричко on 08.07.2023.
//

import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    // MARK: - Init
    private init() {}
    
    func HapticFeedback() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
}
