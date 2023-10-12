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
        var status = UserStatusList.list[index]
        let savedStatus = UserDefaults.loadData(type: UserStatusModel.self, key: "user status")
        if status.id != savedStatus?.id {
            status.isSelected = true
            UserDefaults.saveData(object: status, key: "user status") {
                self.isChanged.toggle()
                HapticsManager.shared.hapticFeedback()
            }
            NotificationCenter.default.post(name: Notification.Name("user status"), object: status)
        }
    }
    
    func isStatusSelected(index: Int)-> Bool {
        var defaultstatus = UserStatusList.list[0]
        defaultstatus.isSelected = true
        let status = UserDefaults.loadData(type: UserStatusModel.self, key: "user status") ?? defaultstatus
        if status.id == UserStatusList.list[index].id && status.isSelected == true {
            return true
        } else {
            return false
        }
    }
}
