//
//  TabsList.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

struct TabsList {
    
    static var tabs = [
        TabModel(id: 1, name: "Новости", icon: UIImage(named: "mail icon")!),
        TabModel(id: 2, name: "Абитуриенту", icon: UIImage(named: "profile icon")!),
        TabModel(id: 3, name: "Расписание", icon: UIImage(named: "clock")!),
        TabModel(id: 4, name: "Настройки", icon: UIImage(named: "options")!),
    ]
}
