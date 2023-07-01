//
//  SpeechRecognitionManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import Foundation

// MARK: - SpeechRecognitionManagerProtocol
extension SpeechRecognitionManager: SpeechRecognitionManagerProtocol {
    
    func registerSpeechRecognitionHandler(block: @escaping(String)->Void) {
        self.speechRecognitionHandler = block
    }
    
    func startSpeechRecognition() {
        
        let node = audioEngine.inputNode
        let recognitionFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) {
            [unowned self](buffer, audioTime) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {
            [weak self] (result, error) in
            if let res = result?.bestTranscription {
                DispatchQueue.main.async {
                    self?.speechRecognitionHandler?(res.formattedString)
                    print(res.formattedString.lowercased())
             }
          } else if let error = error {
              print("\(error.localizedDescription)")
          }
        })
    }
    
    func cancelSpeechRecognition() {
        audioEngine.stop()
        recognitionTask?.cancel()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
