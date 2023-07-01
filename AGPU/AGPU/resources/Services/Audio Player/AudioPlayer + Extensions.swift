//
//  AudioPlayer + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 01.07.2023.
//

import AVFoundation
import MediaPlayer

// MARK: - AudioPlayerProtocol
extension AudioPlayer: AudioPlayerProtocol {
    
    func PlaySound(resource: String) {
        
        if let audioUrl = URL(string: resource) {
            
            self.sound = resource
            
            // then lets create your document folder url
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                player = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = player else { return }
                player.delegate = self
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func StopSound() {
        player?.stop()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        PlaySound(resource: sound)
    }
}
