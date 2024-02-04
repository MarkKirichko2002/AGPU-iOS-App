//
//  UserStatusListViewModel + Extension.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import Foundation

// MARK: - UserStatusListViewModelProtocol
extension UserStatusListViewModel: UserStatusListViewModelProtocol {
    
    func statusListCount()-> Int {
        return 3
    }
    
    func statusItem(index: Int)-> UserStatusModel {
        let status = UserStatusList.list[index]
        return status
    }
    
    func chooseStatus(index: Int) {
        let status = UserStatusList.list[index]
        let savedStatus = UserDefaults.loadData(type: UserStatusModel.self, key: "user status")
        if status.id != savedStatus?.id {
            UserDefaults.saveData(object: status, key: "user status") {
                self.isChanged.toggle()
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                HapticsManager.shared.hapticFeedback()
            }
            NotificationCenter.default.post(name: Notification.Name("user status"), object: status)
        }
    }
    
    func isStatusSelected(index: Int)-> Bool {
        var defaultstatus = UserStatusList.list[0]
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") ?? defaultstatus
        if status.id == statusItem(index: index).id {
            return true
        } else {
            return false
        }
    }
}
