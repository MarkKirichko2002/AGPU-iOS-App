//
//  SpeechSynthesizerManager.swift
//  AGPU
//
//  Created by Марк Киричко on 07.08.2024.
//

import AVFoundation

final class SpeechSynthesizerManager: NSObject {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    let synthesizer = AVSpeechSynthesizer()
    
    static let shared = SpeechSynthesizerManager()
    
    func checkIsSaying(text: String) {
        let isSaying = UserDefaults.standard.object(forKey: "isSaying") as? Bool ?? false
        if isSaying {
            sayComment(text: text)
        }
    }
    
    func sayComment(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        utterance.rate = 0.3
        synthesizer.speak(utterance)
    }
    
    func stopComment() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
