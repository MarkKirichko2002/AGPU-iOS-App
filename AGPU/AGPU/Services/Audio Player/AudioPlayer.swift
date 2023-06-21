//
//  AudioPlayer.swift
//  AGPU
//
//  Created by Марк Киричко on 18.06.2023.
//

import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    
    weak var delegate: AVAudioPlayerDelegate?
    
    static let shared = AudioPlayer()
    
    private var sound = ""
    
    // MARK: - Init
    private override init() {}
    
    func PlaySound(resource: String) {
        
        self.sound = resource
        
        guard let url = Bundle.main.url(forResource: resource, withExtension: nil) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.delegate = self
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func StopSound(resource: String) {

        guard let url = Bundle.main.url(forResource: resource, withExtension: nil) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.stop()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
       PlaySound(resource: sound)
    }
}
