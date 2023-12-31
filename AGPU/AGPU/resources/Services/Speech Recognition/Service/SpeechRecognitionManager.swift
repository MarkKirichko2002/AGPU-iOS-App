//
//  SpeechRecognitionManager.swift
//  AGPU
//
//  Created by Марк Киричко on 08.06.2023.
//

import Speech

final class SpeechRecognitionManager {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru_RU"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var speechRecognitionHandler: ((String)->Void)?
    
    var tapInstalled = false

    
    var speechAuthorizationHandler: ((SFSpeechRecognizerAuthorizationStatus)->Void)?
    
    func registerSpeechAuthorizationHandler(block: @escaping(SFSpeechRecognizerAuthorizationStatus)->Void) {
        self.speechAuthorizationHandler = block
    }
}
