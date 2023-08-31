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
            name: "абитуриент",
            icon: "applicant",
            isSelected: false
        ),
        
        UserStatusModel(
            id: 2,
            name: "студент",
            icon: "student icon",
            isSelected: false
        ),
        
        UserStatusModel(
            id: 3,
            name: "сотрудник",
            icon: "computer",
            isSelected: false
        )
    ]
}
 
