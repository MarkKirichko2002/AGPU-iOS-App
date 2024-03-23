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
        
        let index = TabsList.tabs.firstIndex { $0.id == 1}!
        let status = settingsManager.getUserStatus()
        let position = settingsManager.getTabsPosition()
        
        TabsList.tabs[index].icon = status.icon
        TabsList.tabs[index].name = status.name
        
        for tab in TabsList.tabs {
            
            for number in position {
                let index = TabsList.tabs.firstIndex(of: tab)!
                TabsList.tabs.swapAt(index, number)
            }
        }
        
        dataChangedHandler?()
    }
    
    func saveTabsPosition(tabs: [TabModel], _ index: Int, _ index2: Int) {
        
        var arr = tabs
        
        arr.swapAt(index, index2)
        
        let index1 = arr.firstIndex { $0.id == 0 }
        let index2 = arr.firstIndex { $0.id == 1 }
        let index3 = arr.firstIndex { $0.id == 2 }
        let index4 = arr.firstIndex { $0.id == 3 }
        
        let numbers = [index1, index2, index3, index4]
        
        UserDefaults.standard.setValue(numbers, forKey: "tabs")
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
