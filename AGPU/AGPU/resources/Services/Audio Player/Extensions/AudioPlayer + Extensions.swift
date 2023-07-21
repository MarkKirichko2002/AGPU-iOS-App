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
    
    func getAudioDuration(url: URL)-> TimeInterval? {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            let duration = audioPlayer.duration
            return duration
        } catch {
            print("Failed to get audio duration: \(error.localizedDescription)")
            return nil
        }
    }
    
    func PlaySound(resource: String) {
        
        if let audioUrl = URL(string: resource) {
            
            self.sound = resource
            
            PlayBackControlls()
            
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
    
    func PlayBackControlls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            self.StopSound()
            self.PlaySound(resource: self.sound)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { event in
            self.StopSound()
            return .success
        }
    }
    
    func StopSound() {
        UserDefaults.standard.setValue(player?.currentTime ?? 0, forKey: "time")
        player?.pause()
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        UserDefaults.standard.setValue(0, forKey: "time")
        PlaySound(resource: sound)
    }
}
