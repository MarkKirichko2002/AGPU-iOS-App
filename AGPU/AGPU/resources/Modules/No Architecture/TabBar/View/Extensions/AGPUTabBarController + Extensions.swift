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
                
                self.updateASPUButton(icon: section.icon)
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false, isNotify: true)
                }
                isOpened = true
                resetSpeechRecognition()
                break
            }
        }
    }
    
    // измение раздела сайта
    func changeSection(text: String) {
        
        for section in AGPUSections.sections {
            
            if text.lowercased().contains(section.voiceCommand) {
                resetSpeechRecognition()
                NotificationCenter.default.post(name: Notification.Name("section selected"), object: section)
            }
        }
    }
    
    // случайный раздел
    func generateRandomSection(text: String) {
        
        if text.lowercased().contains("случайный раздел") || text.lowercased().contains("случайно раздел") || text.lowercased().contains("рандомный раздел") || text.lowercased().contains("рандомно раздел") {
            
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            
            self.updateASPUButton(icon: "dice")
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.isOpened = true
                self.goToWeb(url: section.url, image: section.icon, title: section.name, isSheet: false, isNotify: true)
            }
            resetSpeechRecognition()
        }
    }
    
    func randomSectionOnScreen(text: String) {
        if text.contains("случайный раздел") || text.contains("случайно раздел") || text.contains("рандомный раздел") || text.contains("рандомно раздел") {
            let section = AGPUSections.sections[Int.random(in: 0..<AGPUSections.sections.count - 1)]
            resetSpeechRecognition()
            NotificationCenter.default.post(name: Notification.Name("section selected"), object: section)
        }
    }
    
    // поиск подраздела
    func searchSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.noWhitespacesWord().contains(subsection.voiceCommand) && subsection.url != "" {
                    resetSpeechRecognition()
                    self.updateASPUButton(icon: subsection.icon)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                        self.isOpened = true
                        self.goToWeb(url: subsection.url, image: subsection.icon, title: "АГПУ сайт", isSheet: false, isNotify: true)
                    }
                    break
                }
            }
        }
    }
    
    // измение подраздела сайта
    func changeSubSection(text: String) {
        
        for section in AGPUSections.sections {
            
            for subsection in section.subsections {
                
                if text.lowercased().contains(subsection.voiceCommand) {
                    resetSpeechRecognition()
                    NotificationCenter.default.post(name: Notification.Name("subsection selected"), object: subsection)
                }
            }
        }
    }
    
    // поиск корпуса
    func findBuilding(text: String) {
        
        for building in AGPUBuildings.buildings {
            
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                resetSpeechRecognition()
                self.updateASPUButton(icon: "map icon")
                let vc = VoiceSearchAGPUBuildingMapViewController(building: building)
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                    self.isOpened = true
                    self.present(navVC, animated: true)
                }
                break
            }
        }
    }
    
    // измение корпуса на карте
    func changeBuilding(text: String) {
        
        for building in AGPUBuildings.buildings {
            if building.voiceCommands.contains(where: { text.lowercased().range(of: $0.lowercased()) != nil }) {
                resetSpeechRecognition()
                NotificationCenter.default.post(name: Notification.Name("building selected"), object: building.pin)
            }
        }
    }
    
    func webActions(text: String) {
        
        if text.lowercased().lastWord().contains("закр") {
            self.resetSpeechRecognition()
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.isOpened = false
                self.updateASPUButton(icon: "mic")
                NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.closeScreen)
            }
        } 
        
        if text.lowercased().lastWord().contains("назад") {
            NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.back)
        } 
        
        if text.lowercased().lastWord().contains("вперед") || text.lowercased().lastWord().contains("вперёд")  {
            NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.forward)
        }
    }
    
    func resetSpeechRecognition() {
        speechRecognitionManager.cancelSpeechRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.speechRecognitionManager.startRecognize()
        }
    }
    
    // выключить микрофон
    func turnOfMicrophone(text: String) {
        
        if text.lowercased().contains("стоп") {
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                NotificationCenter.default.post(name: Notification.Name("actions"), object: Actions.closeScreen)
            }
            
            self.ASPUButton.sendActions(for: .touchUpInside)
            
        }
    }
    
    // прокрутка веб страницы
    func scrollWebScreen(text: String) {
        for direction in VoiceDirections.directions {
            if direction.name.contains(text.lastWord()) {
                NotificationCenter.default.post(name: Notification.Name("scroll web page"), object: text.lastWord())
            }
        }
    }
    
    // изменение ASPU Button
    func updateASPUButton(icon: String) {
        let option = settingsManager.checkASPUButtonAnimationOption()
        DispatchQueue.main.async {
            self.ASPUButton.setImage(UIImage(named: icon), for: .normal)
            switch option {
            case .spring:
                self.animation.springAnimation(view: self.ASPUButton)
                HapticsManager.shared.hapticFeedback()
            case .flipFromTop:
                self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromTop) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromRight:
                self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromRight) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromLeft:
                self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromLeft) {
                    HapticsManager.shared.hapticFeedback()
                }
            case .flipFromBottom:
                self.animation.flipAnimation(view: self.ASPUButton, option: .transitionFlipFromBottom) {
                    HapticsManager.shared.hapticFeedback()
                }
            }
        }
    }
}
