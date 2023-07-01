//
//  AppDelegate + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 01.07.2023.
//

import AVFoundation

extension AppDelegate {
    
    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longFormAudio,
                                    options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
    }
}
