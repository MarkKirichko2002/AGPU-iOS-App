//
//  UserStatusList.swift
//  AGPU
//
//  Created by Марк Киричко on 27.07.2023.
//

import Foundation

struct UserStatusList {
    
    static let list = [
        
        UserStatusModel(
            id: 1,
            name: "Абитуриент",
            icon: "applicant",
            isSelected: false
        ),
        
        UserStatusModel(
            id: 2,
            name: "Студент",
            icon: "student icon",
            isSelected: false
        ),
        
        UserStatusModel(
            id: 3,
            name: "Сотрудник",
            icon: "computer",
            isSelected: false
        )
    ]
}
