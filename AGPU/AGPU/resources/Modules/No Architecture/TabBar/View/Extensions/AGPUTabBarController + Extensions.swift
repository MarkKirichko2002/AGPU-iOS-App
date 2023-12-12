//
//  AGPUTabBarController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.11.2023.
//

import UIKit

extension AGPUTabBarController {
    
    // поиск раздела
    func searchSection(text: String) {
        
        for section in AGPUSections.sections {
            
            if text.lowercased().contains(section.voiceCommand) {
                
                self.updateDynamicButton(icon: section.icon)
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false)
                }
                ResetSpeechRecognition()
                break
            }
        }
    }
    
    // случайный раздел
    func GenerateRandomSection(text: String) {
        
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            
            self.updateDynamicButton(icon: "dice")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false)
            }
            ResetSpeechRecognition()
        }
    }
    
    // поиск подраздела
    func searchSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.noWhitespacesWord().contains(subsection.voiceCommand) && subsection.url != "" {
                    ResetSpeechRecognition()
                    self.updateDynamicButton(icon: subsection.icon)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.goToWeb(url: subsection.url, image: subsection.icon, title: "ФГБОУ ВО «АГПУ»", isSheet: false)
                    }
                    break
                }
            }
        }
    }
    
    // поиск корпуса
    func findBuilding(text: String) {
        
        for building in AGPUBuildings.buildings {
            
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                ResetSpeechRecognition()
                self.updateDynamicButton(icon: "map icon")
                let vc = SearchAGPUBuildingMapViewController(building: building)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.present(navVC, animated: true)
                }
                break
            }
        }
    }
    
    // закрыть экран
    func closeScreen(text: String) {
        
        if text.lowercased().contains("закр") {
            
            self.ResetSpeechRecognition()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.updateDynamicButton(icon: "mic")
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
        }
    }
    
    func ResetSpeechRecognition() {
        speechRecognitionManager.cancelSpeechRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.speechRecognitionManager.startRecognize()
        }
    }
    
    // выключить микрофон
    func turnOfMicrophone(text: String) {
        
        if text.lowercased().contains("стоп") {
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("close screen"), object: nil)
            }
            
            self.DynamicButton.sendActions(for: .touchUpInside)
            
        }
    }
    
    // прокрутка веб страницы
    func ScrollWebScreen(text: String) {
        for direction in VoiceDirections.directions {
            if direction.name.contains(text.lastWord()) {
                NotificationCenter.default.post(name: Notification.Name("scroll web page"), object: text.lastWord())
            }
        }
    }
    
    // измение корпуса на карте
    func ChangeBuilding(text: String) {
        
        for building in AGPUBuildings.buildings {
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                ResetSpeechRecognition()
                NotificationCenter.default.post(name: Notification.Name("building selected"), object: building.pin)
            }
        }
    }
    
    // изменение Dynamic Button
    func updateDynamicButton(icon: String) {
        DispatchQueue.main.async {
            self.DynamicButton.setImage(UIImage(named: icon), for: .normal)
            self.animation.springAnimation(view: self.DynamicButton)
            HapticsManager.shared.hapticFeedback()
        }
    }
}
