//
//  NewsFavouriteOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2025.
//

import Foundation

// MARK: - INewsFavouriteOptionsListViewModel
extension NewsFavouriteOptionsListViewModel: INewsFavouriteOptionsListViewModel {
    
    func optionsCount()-> Int {
        return options.count
    }
    
    func optionItem(index: Int)-> NewsOptionModel {
        return options[index]
    }
    
    func getOptions() {
        options = settingsManager.loadNewsOptions()
        dataChangedHandler?()
    }
    
    func updateOptions(options: [NewsOptionModel], _ index: Int, _ index2: Int) {
        var arr = options
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        settingsManager.saveNewsOptions(news: arr) {
            self.getOptions()
        }
    }
    
    func deleteOption(option: NewsOptionModel) {
        var options = settingsManager.loadNewsOptions()
        
        if let index = options.firstIndex(where: { $0.id == option.id }) {
            options.remove(at: index)
        }
        HapticsManager.shared.hapticFeedback()
        settingsManager.saveNewsOptions(news: options) {
            self.getOptions()
        }
    }
    
    func registerDataChangedHandler(block: @escaping () -> Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}

