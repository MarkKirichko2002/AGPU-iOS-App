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
            icon: "profile icon",
            iconSelected: "applicant selected"
        ),
        
        UserStatusModel(
            id: 2,
            name: "Студент",
            icon: "student icon",
            iconSelected: "student icon selected"
        ),
        
        UserStatusModel(
            id: 3,
            name: "Сотрудник",
            icon: "computer",
            iconSelected: "computer selected"
        )
    ]
}
