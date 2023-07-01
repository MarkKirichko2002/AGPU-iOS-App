//
//  SpeechRecognitionManager.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Speech

class SpeechRecognitionManager {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru_RU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var speechRecognitionHandler: ((String)->Void)?
    
    func startRecognize() {
        if startRecording() {
            startSpeechRecognition()
        } else {}
    }
    
    func startRecording()-> Bool {
        do {
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default,
            policy: .default, options: .defaultToSpeaker)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
