//
//  SpeechRecognitionManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2023.
//

import Foundation

protocol SpeechRecognitionManagerProtocol {
    func registerSpeechRecognitionHandler(block: @escaping(String)->Void)
    func startSpeechRecognition()
    func cancelSpeechRecognition()
}
