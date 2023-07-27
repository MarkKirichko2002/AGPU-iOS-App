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
            isSelected: false
        ),
        UserStatusModel(
            id: 2,
            name: "студент",
            isSelected: false
        ),
        UserStatusModel(
            id: 3,
            name: "сотрудник",
            isSelected: false
        )
    ]
}
 
