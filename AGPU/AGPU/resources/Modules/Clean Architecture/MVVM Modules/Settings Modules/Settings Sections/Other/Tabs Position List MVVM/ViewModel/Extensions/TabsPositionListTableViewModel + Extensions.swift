//
//  TabsPositionListTableViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

// MARK: - ITabsListTableViewModel
extension TabsPositionListTableViewModel: ITabsPositionListTableViewModel {
    
    func getData() {
        
        tabs = TabsList.tabs
        
        let index1 = tabs.firstIndex { $0.id == 1 }!
        let index2 = tabs.firstIndex { $0.id == 2 }!
        let index3 = tabs.firstIndex { $0.id == 3 }!
        let index4 = tabs.firstIndex { $0.id == 4 }!
        
        let icons = settingsManager.getTabsIcons()
        let style = settingsManager.getTabsIconStyle()
        
        let status = settingsManager.getUserStatus()
        let position = settingsManager.getTabsPosition()
        
        if style == .apple {
            tabs[index1].icon = icons[0].icon
            tabs[index2].icon = settingsManager.getTabIconForStatus().icon
            tabs[index2].name = status.name + "у"
            tabs[index3].icon = icons[1].icon
            tabs[index4].icon = icons[2].icon
        } else {
            tabs[index2].icon = UIImage(named: status.icon)!
            tabs[index2].name = status.name + "у"
        }
        
        for tab in tabs {
            for number in position {
                let index = tabs.firstIndex(of: tab)!
                print("индекс: \(index) позиция: \(number)")
                tabs.swapAt(index, number)
            }
        }
        NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
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
        
        UserDefaults.saveArray(array: numbers as! [Int], key: "tabs") {
            self.getData()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
