//
//  TabsPositionListTableViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

// MARK: - ITabsListTableViewModel
extension TabsPositionListTableViewModel: ITabsPositionListTableViewModel {
    
    func tabItem(index: Int)-> TabModel {
        return tabs[index]
    }
    
    func getData() {
        getTabsPosition()
        dataChangedHandler?()
    }
    
    func getTabsPosition() {
        
        let icons = settingsManager.getTabsIcons()
        
        let position = settingsManager.getTabs()
        
        tabs = position
        
        let index1 = tabs.firstIndex { $0.id == 1 }!
        let index2 = tabs.firstIndex { $0.id == 2 }!
        let index3 = tabs.firstIndex { $0.id == 3 }!
        let index4 = tabs.firstIndex { $0.id == 4 }!
        
        tabs[index1].icon = icons[0].icon.pngData()
        tabs[index2].icon = icons[1].icon.pngData()
        tabs[index3].icon = icons[2].icon.pngData()
        tabs[index4].icon = icons[4].icon.pngData()
    }
    
    func editText(tab: TabModel, text: String) {
        let index = tabs.firstIndex(of: tab) ?? 0
        if tabs[index].name != text {
            tabs[index].name = text
            saveChanges(tab: tab)
        }
    }
    
    func resetTitle(tab: TabModel) {
        let searchTab = TabsList.tabs.first { $0.id == tab.id }!
        let index = tabs.firstIndex(of: tab) ?? 0
        if tabs[index].name != searchTab.name {
            tabs[index].name = searchTab.name
            saveChanges(tab: tab)
        }
    }
    
    func saveTabsPosition(_ index: Int, _ index2: Int) {
        
        var arr = tabs
        
        let item = arr.remove(at: index)
        arr.insert(item, at: index2)
        
        let index1 = arr.firstIndex { $0.id == 1 }!
        let index2 = arr.firstIndex { $0.id == 2 }!
        let index3 = arr.firstIndex { $0.id == 3 }!
        let index4 = arr.firstIndex { $0.id == 4 }!
        
        arr[0].position = index1
        arr[1].position = index2
        arr[2].position = index3
        arr[3].position = index4
        
        saveTabs(arr: arr)
    }
    
    func saveTabs(arr: [TabModel]) {
        do {
            let arr = try JSONEncoder().encode(arr)
            UserDefaults.standard.setValue(arr, forKey: "tabs")
            getData()
            sendNotifications()
        } catch {
            print(error)
        }
    }
    
    func saveChanges(tab: TabModel) {
        do {
            let arr = try JSONEncoder().encode(tabs)
            UserDefaults.standard.setValue(arr, forKey: "tabs")
            getChanges(index: tabs.firstIndex(where: { $0.id == tab.id })!)
            sendNotifications()
        } catch {
            print(error)
        }
    }
    
    func getChanges(index: Int) {
        getTabsPosition()
        itemChangedHandler?(index)
    }
    
    func sendNotifications() {
        NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("tabs changed"), object: nil)
    }
    
    func createEditAlertMessage()-> (String, String) {
        let style = settingsManager.getSavedCommunicationStyle()
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        switch style {
        case .formal:
            return ("Изменить вкладку", "\(!name.isEmpty ? "\(name) Вы точно хотите изменить" : "Вы точно хотите изменить") название вкладки?")
        case .informal:
            return ("Изменить вкладку", "\(!name.isEmpty ? "\(name) ты точно хочешь изменить" : "Ты точно хочешь изменить") название вкладки?")
        }
    }
    
    func getTabName(tab: TabModel)-> String {
        if tab.id == 1 {
            return "news"
        } else if tab.id == 2 {
            return "sections"
        } else if tab.id == 3 {
            return "timetable"
        } else if tab.id == 4 {
            return "settings"
        } else {
            return ""
        }
    }
    
    func convertTabName(tab: TabModel)-> String {
        return getTabName(tab: tab).getCurrentTabName()
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
    
    func registerItemChangedHandler(block: @escaping(Int)->Void) {
        self.itemChangedHandler = block
    }
}
