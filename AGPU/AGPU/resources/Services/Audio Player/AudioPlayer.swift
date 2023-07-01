//
//  AudioPlayer.swift
//  AGPU
//
//  Created by Марк Киричко on 18.06.2023.
//

import AVFoundation

class AudioPlayer: NSObject {
    
    var player: AVAudioPlayer?
    
    weak var delegate: AVAudioPlayerDelegate?
    
    static let shared = AudioPlayer()
    
    var sound = ""
    
    // MARK: - Init
    private override init() {}
}
