//
//  TabsListTableViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import Foundation

// MARK: - ITabsListTableViewModel
extension TabsListTableViewModel: ITabsListTableViewModel {
    
    func getData() {
        
        tabs = TabsList.tabs
        
        let index = tabs.firstIndex { $0.id == 2}!
        let status = settingsManager.getUserStatus()
        let position = settingsManager.getTabsPosition()
        
        tabs[index].icon = status.icon
        tabs[index].name = status.name + "у"
        
        for tab in tabs {
            for number in position {
                let index = tabs.firstIndex(of: tab)!
                print("индекс: \(index) позиция: \(number)")
                tabs.swapAt(index, number)
            }
        }
        
        dataChangedHandler?()
    }
    
    func saveTabsPosition(_ index: Int, _ index2: Int) {
        
        var arr = tabs
        
        arr.swapAt(index, index2)
        
        let index1 = arr.firstIndex { $0.id == 1 }
        let index2 = arr.firstIndex { $0.id == 2 }
        let index3 = arr.firstIndex { $0.id == 3 }
        let index4 = arr.firstIndex { $0.id == 4 }
        
        let numbers = [index1, index2, index3, index4]
        
        UserDefaults.standard.setValue(numbers, forKey: "tabs")
        
        UserDefaults.saveArray(array: numbers as! [Int], key: "tabs") {
            self.getData()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
