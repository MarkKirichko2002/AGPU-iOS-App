//
//  AudioPlayerClass + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.01.2024.
//

import AVFoundation

// MARK: - AudioPlayerClassProtocol
extension AudioPlayerClass: AudioPlayerClassProtocol {
    
    func playSound(sound: String) {
        
        guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else {return}
        
        do {
            self.player = try AVAudioPlayer(contentsOf: soundURL)
            player?.play()
        } catch {
            print(error)
        }
    }
    
    func stopSound(sound: String) {
        player?.stop()
    }
}
