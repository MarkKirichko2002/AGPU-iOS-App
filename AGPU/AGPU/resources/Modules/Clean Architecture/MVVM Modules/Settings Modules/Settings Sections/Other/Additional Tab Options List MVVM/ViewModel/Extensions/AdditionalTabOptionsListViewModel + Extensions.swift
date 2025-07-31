//
//  AdditionalTabOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.12.2024.
//

import Foundation

// MARK: - IAdditionalTabOptionsListViewModel
extension AdditionalTabOptionsListViewModel: IAdditionalTabOptionsListViewModel {
    
    func variantsCount()-> Int {
        return AdditionalTabVariants.allCases.count
    }
    
    func variantItem(index: Int)-> AdditionalTabVariants {
        return AdditionalTabVariants.allCases[index]
    }
    
    func selectVariant(index: Int) {
        
        let savedVariant = settingsManager.getAdditionalTabVariant()
        let variant = variantItem(index: index)
        
        if savedVariant.rawValue != variant.rawValue {
            UserDefaults.saveData(object: variant, key: "additional tab") {
                NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
                self.dataChangedHandler?()
            }
        }
    }
    
    func editText(variant: AdditionalTabVariants, text: String) {
        let index = AdditionalTabVariants.allCases.firstIndex(of: variant) ?? 0
        if textForVariant(variant: variant) != text {
            saveChanges(title: text, index: index)
        }
    }
    
    func resetTitle(variant: AdditionalTabVariants) {
        let index = AdditionalTabVariants.allCases.firstIndex(of: variant) ?? 0
        if AdditionalTabVariants.allCases[index].rawValue != textForVariant(variant: variant) {
            saveChanges(title: AdditionalTabVariants.allCases[index].rawValue, index: index)
        }
    }
    
    func saveChanges(title: String, index: Int) {
        settingsManager.saveAdditionalTabName(variant: AdditionalTabVariants.allCases[index], title: title)
        NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
        self.itemChangedHandler?(index)
    }
    
    func isVariantSelected(index: Int)-> Bool {
        let savedVariant = settingsManager.getAdditionalTabVariant()
        let variant = variantItem(index: index)
        if savedVariant.rawValue == variant.rawValue {
            return true
        }
        return false
    }
    
    func textForVariant(variant: AdditionalTabVariants)-> String {
        if !settingsManager.getAdditionalTabName(title: variant.rawValue).isEmpty {
            return settingsManager.getAdditionalTabName(title: variant.rawValue)
        } else {
            return variant.rawValue
        }
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить вкладку", "\(!name.isEmpty ? "\(name) Вы точно хотите изменить" : "Вы точно хотите изменить") название вкладки?")
        case .informal:
            return ("Изменить вкладку", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название вкладки?")
        }
    }
    
    func titleForNavigation()-> String {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return "Выберите вариант"
        case .informal:
            return "Выбери вариант"
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
