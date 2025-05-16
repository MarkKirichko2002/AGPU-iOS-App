//
//  IAllShortcutsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.12.2024.
//

import Foundation

protocol IAllShortcutsListViewModel {
    func shortcutsCount()-> Int
    func shortcutItem(index: Int)-> ShortcutModel
    func selectShortcut(index: Int)
    func saveShortcut(shortcut: ShortcutModel)
    func registerItemSelectedHandler(block: @escaping()->Void)
}
