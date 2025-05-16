//
//  AllGroupsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 04.08.2023.
//

import Foundation

final class AllGroupsListViewModel {
    
    var group: String = ""
    var groups = [FacultyGroupModel]()
    
    var dataChangedHandler: (()->Void)?
    var scrollHandler: ((Int, Int)->Void)?
    var groupSelectedHandler: (()->Void)?
    
    var isLoading = true
    
    // MARK: - сервисы
    let service = TimeTableService()
    
    // MARK: - Init
    init(group: String) {
        self.group = group
    }
}
