//
//  AudioPlayerClass + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.01.2024.
//

import AVFoundation

// MARK: - AudioPlayerClassProtocol
extension AudioPlayerClass: AudioPlayerClassProtocol {
    
    func playSound(sound: String, isPlaying: Bool) {
        if sound != "" {
            guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else {return}
            do {
                self.player = try AVAudioPlayer(contentsOf: soundURL)
                self.isPlaying = isPlaying
                player?.delegate = self
                player?.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stopSound() {
        player?.stop()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerClass: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag && isPlaying {
            player.play()
        }
    }
}
