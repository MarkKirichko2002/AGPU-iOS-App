//
//  CurrentTabOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 14.12.2024.
//

import Foundation

// MARK: - ICurrentTabOptionsListViewModel
extension CurrentTabOptionsListViewModel: ICurrentTabOptionsListViewModel {
    
    func optionsCount()-> Int {
        return currentSection.options.count
    }
    
    func optionItem(index: Int)-> TabOptionModel {
        return currentSection.options[index]
    }
    
    func selectOption(index: Int) {
        let shortcut = optionItem(index: index)
        saveOption(option: shortcut)
    }
    
    func saveOption(option: TabOptionModel) {
        var options = settingsManager.getTabOptions(title: title)
        if !options.contains(where: { $0.title == option.title }) {
            HapticsManager.shared.hapticFeedback()
            options.append(option)
        }
        saveArray(array: options)
    }
    
    func saveOptions(options: [TabOptionModel]) {
        var savedOptions = settingsManager.getTabOptions(title: title)
        for option in options {
            if !savedOptions.contains(where: { $0.title == option.title }) {
                savedOptions.append(option)
            }
        }
        saveArray(array: savedOptions)
    }
    
    func saveArray(array: [TabOptionModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "\(title) options")
        } catch {
            print(error)
        }
        itemSelectedHandler?()
    }
    
    func registerItemSelectedHandler(block: @escaping()->Void) {
        self.itemSelectedHandler = block
    }
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
