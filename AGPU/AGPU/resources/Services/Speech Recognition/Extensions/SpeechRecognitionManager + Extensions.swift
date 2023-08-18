//
//  SpeechRecognitionManager + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 02.07.2023.
//

import Speech
import AVFAudio

// MARK: - SpeechRecognitionManagerProtocol
extension SpeechRecognitionManager: SpeechRecognitionManagerProtocol {
    
    func requestSpeechAndMicrophonePermission() {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission == .undetermined {
            audioSession.requestRecordPermission { (granted) in
                if granted {
                    self.requestSpeechAuthorization()
                } else {}
            }
        } else {
            requestSpeechAuthorization()
        }
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.speechAuthorizationHandler?(.authorized)
            case .denied:
                self.speechAuthorizationHandler?(.denied)
            case .restricted:
                self.speechAuthorizationHandler?(.restricted)
            case .notDetermined:
                self.speechAuthorizationHandler?(.notDetermined)
            @unknown default:
                break
            }
        }
    }
    
    func startRecognize() {
        if startRecording() {
            startSpeechRecognition()
        }
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
    
    func registerSpeechRecognitionHandler(block: @escaping(String)->Void) {
        self.speechRecognitionHandler = block
    }
    
    func startSpeechRecognition() {
        
        guard !tapInstalled else { return }
        
        let node = audioEngine.inputNode
        let recognitionFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) {
            [unowned self](buffer, audioTime) in
            self.request.append(buffer)
        }
        
        tapInstalled = true
        
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
        guard tapInstalled else { return }

        audioEngine.stop()
        recognitionTask?.cancel()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        tapInstalled = false

    }
}
