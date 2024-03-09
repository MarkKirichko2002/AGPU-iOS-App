//
//  SpeechRecognitionManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import Foundation

protocol SpeechRecognitionManagerProtocol {
    func requestSpeechAuthorization()
    func startRecognize()
    func startRecording()-> Bool
    func startSpeechRecognition()
    func cancelSpeechRecognition()
    func registerSpeechRecognitionHandler(block: @escaping(String)->Void)
}
