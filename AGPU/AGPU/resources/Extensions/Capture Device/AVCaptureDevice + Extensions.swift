//
//  AVCaptureDevice + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 04.01.2025.
//

import AVFoundation

extension AVCaptureDevice {
    
    func onOffTorch(on: Bool) {
        do {
            try self.lockForConfiguration()
            self.torchMode = on ? .on : .off
            self.unlockForConfiguration()
        } catch {
            print(error)
        }
        HapticsManager.shared.hapticFeedback()
    }
}
