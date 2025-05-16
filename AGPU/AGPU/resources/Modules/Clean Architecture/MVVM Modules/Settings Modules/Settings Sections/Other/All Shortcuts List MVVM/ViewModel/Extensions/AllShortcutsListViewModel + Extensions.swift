//
//  AllShortcutsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

// MARK: - IAllShortcutsListViewModel
extension AllShortcutsListViewModel: IAllShortcutsListViewModel {
    
    func shortcutsCount()-> Int {
        return AppShortcuts.items.count
    }
    
    func shortcutItem(index: Int)-> ShortcutModel {
        return AppShortcuts.items[index]
    }
    
    func selectShortcut(index: Int) {
        let shortcut = shortcutItem(index: index)
        saveShortcut(shortcut: shortcut)
    }
    
    func saveShortcut(shortcut: ShortcutModel) {
        var shortcuts = loadActions()
        if shortcuts.count < 4 {
            if !shortcuts.contains(where: { $0.title == shortcut.title }) {
                HapticsManager.shared.hapticFeedback()
                shortcuts.append(shortcut)
            }
            saveArray(array: shortcuts)
        } else {
            alertHandler?("Слишком много ярлыков!", "ярлыков не может быть больше 4")
        }
    }
    
    func saveShortcuts(shortcuts: [ShortcutModel]) {
        var savedShortcuts = loadActions()
        if savedShortcuts.count + shortcuts.count <= 4 {
            for shortcut in shortcuts {
                if !savedShortcuts.contains(where: { $0.title == shortcut.title }) {
                    savedShortcuts.append(shortcut)
                }
            }
            saveArray(array: savedShortcuts)
        } else {
            alertHandler?("Слишком много ярлыков!", "ярлыков не может быть больше 4")
        }
    }
    
    func loadActions()-> [ShortcutModel] {
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
    
    func saveArray(array: [ShortcutModel]) {
        do {
            let arr = try JSONEncoder().encode(array)
            UserDefaults.standard.setValue(arr, forKey: "shortcuts")
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
