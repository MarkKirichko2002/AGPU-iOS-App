//
//  Sections.swift
//  AGPU
//
//  Created by Марк Киричко on 23.09.2024.
//

import UIKit

struct Sections {
    
    static let list = [
        ForEveryStatusModel(
            id: 1,
            image: UIImage(named: "profile icon")!.pngData()!,
            name: "Личный кабинет ЭИОС"
        ),
        ForEveryStatusModel(
            id: 2,
            image: UIImage(named: "map icon")!.pngData()!,
            name: "Найти кампус"
        ),
        ForEveryStatusModel(
            id: 3,
            image: UIImage(named: "sun")!.pngData()!,
            name: "Погода"
        ),
        ForEveryStatusModel(
            id: 4,
            image: UIImage(named: "university")!.pngData()!,
            name: "Институты/факультеты"
        ),
        ForEveryStatusModel(
            id: 5,
            image: UIImage(named: "sections icon")!.pngData()!,
            name: "Разделы сайта"
        ),
        ForEveryStatusModel(
            id: 6,
            image: UIImage(named: "book")!.pngData()!,
            name: "Методические материалы"
        ),
        ForEveryStatusModel(
            id: 7,
            image: UIImage(named: "wallpaper")!.pngData()!,
            name: "АГПУ обои"
        ),
        ForEveryStatusModel(
            id: 8,
            image: UIImage(named: "document")!.pngData()!,
            name: "Документы"
        ),
        ForEveryStatusModel(
            id: 9,
            image: UIImage(named: "photo icon")!.pngData()!,
            name: "Изображения"
        ),
        ForEveryStatusModel(
            id: 10,
            image: UIImage(named: "play icon")!.pngData()!,
            name: "Видео"
        ),
        ForEveryStatusModel(
            id: 11,
            image: UIImage(named: "contacts icon")!.pngData()!,
            name: "Контакты"
        ),
        ForEveryStatusModel(
            id: 12,
            image: UIImage(named: "clock")!.pngData()!,
            name: "Расписание"
        ),
        ForEveryStatusModel(
            id: 13,
            image: UIImage(named: "online")!.pngData()!,
            name: "Web-страницы"
        )
    ]
}
