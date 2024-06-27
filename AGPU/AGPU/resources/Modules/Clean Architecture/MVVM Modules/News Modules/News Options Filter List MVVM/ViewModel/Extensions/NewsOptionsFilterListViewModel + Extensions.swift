//
//  NewsOptionsFilterListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 05.04.2024.
//

import Foundation

// MARK: - INewsOptionsFilterListViewModel
extension NewsOptionsFilterListViewModel: INewsOptionsFilterListViewModel {
    
    func optionItem(index: Int)-> NewsOptionsFilters {
        let option = NewsOptionsFilters.allCases[index]
        return option
    }
    
    func numberOfOptionsInSection()-> Int {
        let count = NewsOptionsFilters.allCases.count
        return count
    }
    
    func countForOption(index: Int)-> Int {
        let option = optionItem(index: index)
        return filterNews(option: option)
    }
    
    func filterNews(option: NewsOptionsFilters)-> Int {
        switch option {
        case .today:
            let date = dateManager.getCurrentDate()
            let filteredData = news.filter({ $0.date == date })
            return filteredData.count
        case .yesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let filteredData = news.filter({ $0.date == yesterday })
            return filteredData.count
        case .dayBeforeYesterday:
            let date = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: date)
            let beforeYesterday = dateManager.previousDay(date: yesterday)
            let filteredData = news.filter({ $0.date == beforeYesterday })
            return filteredData.count
        case .all:
            return news.count
        }
    }
    
    func chooseOption(index: Int) {
        let item = optionItem(index: index)
        if option != item {
            option = item
            optionSelectedHandler?()
            HapticsManager.shared.hapticFeedback()
            saveOption(option: item)
        } else {
            print("уже выбрана")
        }
    }
    
    private func saveOption(option: NewsOptionsFilters) {
        UserDefaults.saveData(object: option, key: "news filter") {
            NotificationCenter.default.post(name: Notification.Name("news filter option"), object: option)
            HapticsManager.shared.hapticFeedback()
            print("сохранено")
        }
    }
    
    func isCurrentOption(index: Int)-> Bool {
        let item = optionItem(index: index)
        if option == item {
            return true
        }
        return false
    }
    
    func registerOptionSelectedHandler(block: @escaping(()->Void)) {
        self.optionSelectedHandler = block
    }
}
