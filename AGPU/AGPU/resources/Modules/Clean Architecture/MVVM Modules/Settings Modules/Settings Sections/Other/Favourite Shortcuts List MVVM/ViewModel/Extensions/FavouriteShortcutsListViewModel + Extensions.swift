//
//  FavouriteShortcutsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

// MARK: - IFavouriteShortcutsListViewModel
extension FavouriteShortcutsListViewModel: IFavouriteShortcutsListViewModel {
    
    func shortcutsCount()-> Int {
        return shortcuts.count
    }
    
    func shortcutItem(index: Int)-> ShortcutModel {
        return shortcuts[index]
    }
    
    func getShortcuts() {
        shortcuts = loadShortcuts()
        dataChangedHandler?()
    }
    
    func getChanges(index: Int) {
        shortcuts = loadShortcuts()
        itemChangedHandler?(index)
    }
    
    func updateShortcutInfo(shortcut: ShortcutModel) {
        let index = shortcuts.firstIndex { $0.id == shortcut.id }!
        if shortcuts[index].title != shortcut.title || shortcuts[index].subtitle != shortcut.subtitle {
            shortcuts[index] = shortcut
            saveChanges(shortcut: shortcut)
        }
    }
    
    func resetShortcut(shortcut: ShortcutModel) {
        let item = AppShortcuts.items.first { $0.id == shortcut.id }!
        let index = shortcuts.firstIndex { $0.id == shortcut.id }!
        if shortcuts[index].title != item.title || shortcuts[index].subtitle != shortcut.subtitle {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.shortcuts[index] = item
                self.saveChanges(shortcut: shortcut)
            }
        }
    }
    
    func updateShortcuts(shortcuts: [ShortcutModel], _ index: Int, _ index2: Int) {
        var arr = shortcuts
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        saveArray(array: arr)
    }
    
    func loadShortcuts()-> [ShortcutModel] {
        var data = [ShortcutModel]()
        if let result = UserDefaults.standard.object(forKey: "shortcuts") as? Data {
            do {
                data = try JSONDecoder().decode([ShortcutModel].self, from: result)
            } catch {
                print(error)
            }
        }
        return data
    }
     
    func deleteShortcut(shortcut: ShortcutModel) {
        
        var shortcuts = loadShortcuts()
        
        if let index = shortcuts.firstIndex(where: { $0.title == shortcut.title }) {
            shortcuts.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        saveArray(array: shortcuts)
    }
    
    func saveArray(array: [ShortcutModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "shortcuts")
            getShortcuts()
        } catch {
            print(error)
        }
    }
    
    func saveChanges(shortcut: ShortcutModel) {
        do {
            let arr = try JSONEncoder().encode(shortcuts)
            UserDefaults.standard.setValue(arr, forKey: "shortcuts")
            getChanges(index: shortcuts.firstIndex(where: { $0.id == shortcut.id })!)
        } catch {
            print(error)
        }
    }
    
    func createTextInfoForShortcut(shortcut: ShortcutModel)-> (String, String) {
        let item = AppShortcuts.items.first { $0.id == shortcut.id }
        return (item?.title ?? "Нет названия", item?.subtitle ?? "Нет описания")
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить шорткат", "\(!name.isEmpty ? "\(name) вы точно хотите изменить" : "Вы точно хотите изменить") данные шортката?")
        case .informal:
            return ("Изменить шорткат", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") данные шортката?")
        }
    }
    
    func createTextForEditAlert()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        switch style {
        case .formal:
            return ("Введите название", "Введите описание")
        case .informal:
            return ("Введи название", "Введи описание")
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
