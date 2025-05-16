//
//  RecentDatesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import Foundation

// MARK: - IRecentDatesListViewModel
extension RecentDatesListViewModel: IRecentDatesListViewModel {
    
    func datesCount()-> Int {
        return dates.count
    }
    
    func dateItem(index: Int)-> String {
        return dates[index]
    }
    
    func getDates() {
        dates = loadDates()
        dataChangedHandler?()
    }
    
    func updateDates(dates: [String], _ index: Int, _ index2: Int) {
        
        var arr = dates
        
        let date = arr.remove(at: index)
        arr.insert(date, at: index2)
        
        UserDefaults.saveArray(array: arr, key: "recent dates") {
            self.getDates()
        }
    }
    
    func loadDates()-> [String] {
        let dates = UserDefaults.standard.array(forKey: "recent dates") as? [String] ?? []
        return dates
    }
     
    func deleteDate(date: String) {
        var dates = loadDates()
        if let index = dates.firstIndex(of: date) {
            dates.remove(at: index)
            HapticsManager.shared.hapticFeedback()
            UserDefaults.saveArray(array: dates, key: "recent dates") {
                self.getDates()
            }
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
