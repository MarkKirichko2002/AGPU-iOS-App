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
        dates = loadDates().sorted(by: {$0 < $1})
        dataChangedHandler?()
    }
    
    func updateDates(dates: [String], _ index: Int, _ index2: Int) {
        
        var arr = [String]()
        
        for date in dates {
            arr.append(date)
        }
        
        print("\(index) and \(index2)")
        
        arr.swapAt(index, index2)
        
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
