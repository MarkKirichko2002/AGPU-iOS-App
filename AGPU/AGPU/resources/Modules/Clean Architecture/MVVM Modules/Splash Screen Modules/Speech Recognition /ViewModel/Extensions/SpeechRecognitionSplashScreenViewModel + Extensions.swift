//
//  SpeechRecognitionSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2025.
//

import UIKit

// MARK: - ISpeechRecognitionSplashScreenViewModel
extension SpeechRecognitionSplashScreenViewModel: ISpeechRecognitionSplashScreenViewModel {
    
    func startRecognize() {
        speechRecognitionManager.requestSpeechAndMicrophonePermission()
        speechRecognitionManager.registerSpeechAuthorizationHandler { auth in
            switch auth {
            case .notDetermined:
                print("Разрешение на распознавание речи еще не было получено.")
            case .denied:
                self.alertHandler?(true, self.createMicAlertMessage().0, self.createMicAlertMessage().1)
                print("Доступ к распознаванию речи был отклонен.")
            case .restricted:
                print("Функциональность распознавания речи ограничена.")
            case .authorized:
                print("Разрешение на распознавание речи получено.")
                self.speechRecognitionManager.startRecognize()
            @unknown default:
                print("неизвестно")
            }
        }
        speechRecognitionManager.registerSpeechRecognitionHandler { text in
            self.voiceCommands(text: text)
        }
    }
    
    func voiceCommands(text: String) {
        recognizeSplashScreen(text: text)
        skipSplashScreenWithVoice(text: text)
    }
    
    func skipSplashScreenWithVoice(text: String) {
        if text.lowercased().contains("пропуст") {
            let vc = splashScreenStorageManager.getSplashScreen(screen: .none)
            cancelRecognition()
            skipHandler?(vc)
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func recognizeSplashScreen(text: String) {
        for screen in SplashScreenOptions.allCases {
            if text.lowercased().contains(screen.voiceCommand) {
                let vc = splashScreenStorageManager.getSplashScreen(screen: screen)
                currentScreen = screen
                cancelRecognition()
                splashScreenViewControllerHandler?(vc)
                HapticsManager.shared.hapticFeedback()
                break
            }
        }
    }
    
    func cancelRecognition() {
        speechRecognitionManager.cancelSpeechRecognition()
    }
    
    func createMicAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хотите" : "Хотите") включить в настройках?")
        case .informal:
            return ("Микрофон выключен", "\(!name.isEmpty ? "\(name) хочешь" : "Хочешь") врубить в настройках?")
        }
    }
    
    func registerSplashScreenViewControllerHandler(block: @escaping(UIViewController)->Void) {
        self.splashScreenViewControllerHandler = block
    }
    
    func registerSkipHandler(block: @escaping(UIViewController)->Void) {
        self.skipHandler = block
    }
}
