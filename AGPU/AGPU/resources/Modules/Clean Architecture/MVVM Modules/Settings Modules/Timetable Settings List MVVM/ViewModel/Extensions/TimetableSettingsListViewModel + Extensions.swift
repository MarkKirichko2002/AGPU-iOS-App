//
//  TimetableSettingsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

// MARK: - TimetableSettingsListViewModelProtocol
extension TimetableSettingsListViewModel: TimetableSettingsListViewModelProtocol {
    
    func getAllData() {
        options[0].info = getSavedGroup()
        options[1].info = "\(getSavedSubGroup())"
        options[2].info = getSavedPairType().title
        dataChangedHandler?()
    }
    
    func getSavedFaculty()-> AGPUFacultyModel? {
        let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
        return faculty
    }
    
    func getSavedGroup()-> String {
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? "нет группы"
        print("группа: \(group)")
        return group
    }
    
    func getSavedSubGroup()-> Int {
        let subGroup = UserDefaults.standard.object(forKey: "subgroup") as? Int ?? 0
        return subGroup
    }
    
    func getSavedPairType()-> PairType {
        let type = UserDefaults.loadData(type: PairType.self, key: "type") ?? .all
        return type
    }
    
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.getAllData()
            self.dataChangedHandler?()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
