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
                player.currentTime = UserDefaults.standard.object(forKey: "time") as? TimeInterval ?? 0
                player.play()
                
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    UserDefaults.standard.setValue(player.currentTime, forKey: "time")
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func StopSound() {
        UserDefaults.standard.setValue(player?.currentTime ?? 0, forKey: "time")
        player?.stop()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        UserDefaults.standard.setValue(0, forKey: "time")
        PlaySound(resource: sound)
    }
}
