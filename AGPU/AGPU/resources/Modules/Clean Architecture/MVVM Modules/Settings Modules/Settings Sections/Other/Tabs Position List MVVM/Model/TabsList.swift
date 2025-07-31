//
//  TabsList.swift
//  AGPU
//
//  Created by Марк Киричко on 23.03.2024.
//

import UIKit

struct TabsList {
    static var tabs = [
        TabModel(id: 1, name: "Новости", icon: UIImage(named: "mail icon")?.pngData()!, position: 0),
        TabModel(id: 2, name: "Разделы", icon: UIImage(named: "sections icon")?.pngData()!, position: 1),
        TabModel(id: 3, name: "Расписание", icon: UIImage(named: "clock")?.pngData()!, position: 2),
        TabModel(id: 4, name: "Настройки", icon: UIImage(named: "options")?.pngData()!, position: 3),
    ]
}
