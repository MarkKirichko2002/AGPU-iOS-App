//
//  SpeechRecognitionManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import Foundation

protocol SpeechRecognitionManagerProtocol: AnyObject {
    func registerSpeechRecognitionHandler(block: @escaping(String)->Void)
    func startSpeechRecognition()
    func cancelSpeechRecognition()
    func configureAudioSession()
}
