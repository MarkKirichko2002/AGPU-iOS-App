//
//  DisciplinesPseudonymListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.10.2025.
//

import Foundation

final class TimetablePseudonymListViewModel {
    
    var pseudonyms = [PseudonymModel]()
    var category: PseudonymCategories
    
    var dataChangedHandler: (()->Void)?
    var itemChangedHandler: ((Int)->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    init(category: PseudonymCategories) {
        self.category = category
    }
    
    func getPseudonyms() {
        pseudonyms = settingsManager.loadTimetablePseudonyms(category: category.rawValue)
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        pseudonyms = settingsManager.loadTimetablePseudonyms(category: category.rawValue)
        itemChangedHandler?(index)
    }
    
    func editPseudonym(model: PseudonymModel, pseudonym: String) {
        let index = pseudonyms.firstIndex { $0.originalName == model.originalName } ?? 0
        pseudonyms[index].pseudonym = pseudonym
        settingsManager.saveTimetablePseudonyms(pseudonyms: pseudonyms, category: category.rawValue) {
            self.getChanges(index: index)
        }
    }
    
    func deletePseudonym(model: PseudonymModel) {
        let index = pseudonyms.firstIndex { $0.originalName == model.originalName } ?? 0
        pseudonyms.remove(at: index)
        settingsManager.saveTimetablePseudonyms(pseudonyms: pseudonyms, category: category.rawValue) {
            self.getPseudonyms()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func updatePseudonyms(_ index: Int, _ index2: Int) {
        let pseudonym = pseudonyms.remove(at: index)
        pseudonyms.insert(pseudonym, at: index2)
        settingsManager.saveTimetablePseudonyms(pseudonyms: pseudonyms, category: category.rawValue) {
            self.getPseudonyms()
        }
    }
    
    func numberOfPseudonyms()-> Int {
        return pseudonyms.count
    }
    
    func pseudonymItem(index: Int)-> PseudonymModel {
        return pseudonyms[index]
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") название?")
        case .informal:
            return ("Изменить название", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название?")
        }
    }
    
    func createAddAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Добавить название", "\(!name.isEmpty ? "\(name) введите" : "Введите") название")
        case .informal:
            return ("Добавить название", "\(!name.isEmpty ? "\(name) введи" : "Введи") название")
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
