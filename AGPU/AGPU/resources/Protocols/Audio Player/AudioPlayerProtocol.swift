//
//  AudioPlayerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 21.06.2023.
//

import AVFoundation

protocol AudioPlayerProtocol {
    func getAudioDuration(url: URL)-> TimeInterval?
    func PlaySound(resource: String)
    func StopSound()
}
