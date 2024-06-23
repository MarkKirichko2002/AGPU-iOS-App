//
//  TabsList.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

struct TabsList {
    
    static var tabs = [
        TabModel(id: 1, name: "Новости", icon: UIImage(named: "mail")!),
        TabModel(id: 2, name: "Абитуриенту", icon: UIImage(named: "applicant")!),
        TabModel(id: 3, name: "Расписание", icon: UIImage(named: "clock")!),
        TabModel(id: 4, name: "Настройки", icon: UIImage(named: "settings")!),
    ]
}
