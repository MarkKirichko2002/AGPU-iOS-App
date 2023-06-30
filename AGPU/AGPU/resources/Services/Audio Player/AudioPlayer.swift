//
//  AudioPlayer.swift
//  AGPU
//
//  Created by Марк Киричко on 18.06.2023.
//

import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate, AudioPlayerProtocol {
    
    var player: AVAudioPlayer?
    
    weak var delegate: AVAudioPlayerDelegate?
    
    static let shared = AudioPlayer()
    
    private var sound = ""
    
    // MARK: - Init
    private override init() {}
    
    func PlaySound(resource: String) {
        if let audioUrl = URL(string: resource) {
            
            // then lets create your document folder url
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                player = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = player else { return }
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func StopSound(resource: String) {
        if let audioUrl = URL(string: resource) {
            
            // then lets create your document folder url
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            do {
                player = try AVAudioPlayer(contentsOf: destinationUrl)
                guard let player = player else { return }
                player.stop()
            } catch let error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        PlaySound(resource: sound)
    }
}
