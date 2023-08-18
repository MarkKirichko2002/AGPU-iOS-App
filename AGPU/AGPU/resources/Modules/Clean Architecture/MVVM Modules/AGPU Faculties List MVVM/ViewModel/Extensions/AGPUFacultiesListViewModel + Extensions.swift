//
//  AGPUFacultiesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - AGPUFacultiesListViewModelProtocol
extension AGPUFacultiesListViewModel: AGPUFacultiesListViewModelProtocol {
    
    func facultiesListCount()-> Int {
        return AGPUFaculties.faculties.count
    }
    
    func facultyItem(index: Int)-> AGPUFacultyModel {
        return AGPUFaculties.faculties[index]
    }
    
    func isFacultySelected(index: Int)-> Bool {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        if faculty?.id == AGPUFaculties.faculties[index].id && faculty?.isSelected == true {
            return true
        } else {
            return false
        }
    }
    
    func SendScreenClosedNotification() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            NotificationCenter.default.post(name: Notification.Name("screen was closed"), object: nil)
        }
    }
}
