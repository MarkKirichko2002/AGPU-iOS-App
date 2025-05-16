//
//  IFavouriteShortcutsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

protocol IFavouriteShortcutsListViewModel {
    func shortcutsCount()-> Int
    func shortcutItem(index: Int)-> ShortcutModel
    func getShortcuts()
    func updateShortcuts(shortcuts: [ShortcutModel], _ index: Int, _ index2: Int)
    func loadShortcuts()-> [ShortcutModel]
    func deleteShortcut(shortcut: ShortcutModel)
    func saveArray(array: [ShortcutModel])
    func registerDataChangedHandler(block: @escaping()->Void)
}
