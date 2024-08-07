//
//  SettablePersonalityOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2024.
//

import Foundation

class SettablePersonalityOptionsListViewModel {
    
    private var dataChangedHandler: (()->Void)?
    
    var options = PersonalityOptions.options
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func optionItem(index: Int)-> PersonalityOptionModel {
        return options[index]
    }
    
    func optionsCount()-> Int {
        return options.count + 1
    }
    
    func getData() {
        options[0].name = "Имя (\(getName()))"
        options[1].name = "Стиль общения: (\(getCommunicationStyle().rawValue))"
        dataChangedHandler?()
    }
    
    func saveName(name: String) {
        UserDefaults.standard.setValue(name, forKey: "name")
        getData()
    }
    
    func getName()-> String {
        return UserDefaults.standard.string(forKey: "name") ?? ""
    }
    
    func getCommunicationStyle()-> CommunicationStyles {
        return settingsManager.getSavedCommunicationStyle()
    }
    
    func createAlertMessage()-> (String, String) {
        let savedStyle = settingsManager.getSavedCommunicationStyle()
        switch savedStyle {
        case .formal:
            return ("Обращение по имени", "как к вам обращаться?")
        case .informal:
            return ("Обращение по имени", "как к тебе обращаться?")
        }
    }
    
    func createTextForPlaceHolder()-> String {
        let savedStyle = settingsManager.getSavedCommunicationStyle()
        switch savedStyle {
        case .formal:
            return "Введите ваше имя"
        case .informal:
            return "Введи свое имя"
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
