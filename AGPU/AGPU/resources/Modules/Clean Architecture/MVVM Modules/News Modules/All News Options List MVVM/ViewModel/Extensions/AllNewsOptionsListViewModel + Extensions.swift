//
//  AllNewsOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

// MARK: - IAllNewsOptionsListViewModel
extension AllNewsOptionsListViewModel: IAllNewsOptionsListViewModel {
    
    func optionsCount()-> Int {
        return NewsOptions.list.count
    }
    
    func optionItem(index: Int)-> NewsOptionModel {
        return NewsOptions.list[index]
    }
    
    func selectOption(index: Int) {
        let option = optionItem(index: index)
        saveOption(option: option)
    }
    
    func saveOption(option: NewsOptionModel) {
        var options = settingsManager.loadNewsOptions()
        if !options.contains(where: { $0.id == option.id }) {
            HapticsManager.shared.hapticFeedback()
            options.append(option)
        }
        settingsManager.saveNewsOptions(news: options) {
            self.itemSelectedHandler?()
        }
    }
    
    func saveOptions(options: [NewsOptionModel]) {
        var savedOptions = settingsManager.loadNewsOptions()
        for option in options {
            if !savedOptions.contains(where: { $0.id == option.id }) {
                savedOptions.append(option)
            }
        }
        settingsManager.saveNewsOptions(news: savedOptions) {
            self.itemSelectedHandler?()
        }
    }
    
    func registerItemSelectedHandler(block: @escaping() -> Void) {
        self.itemSelectedHandler = block
    }
}
