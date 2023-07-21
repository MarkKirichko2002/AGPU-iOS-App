//
//  AGPUNewsViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

class AGPUNewsViewModel {
    
    // MARK: - cервисы
    let dateManager = DateManager()
    
    let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
    
    var dateHandler: ((String)->Void)?
    
}
