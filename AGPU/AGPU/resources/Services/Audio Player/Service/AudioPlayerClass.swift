//
//  AudioPlayerClass.swift
//  AGPU
//
//  Created by Марк Киричко on 02.01.2024.
//

import AVFoundation

class AudioPlayerClass: NSObject {
    
    var player: AVAudioPlayer?
    var isPlaying = false
    
    static let shared = AudioPlayerClass()
    
}
