//
//  TimetableMenuManager.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2025.
//

import UIKit

final class TimetableMenuManager {
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    func addTimetablePseyMenu(discipline: Discipline)-> UIMenu {
        
        let timeAction = UIAction(title: "Время", image: UIImage(named: "time icon")) { _ in
            self.settingsManager.addTimetablePseudonym(model: PseudonymModel(originalName: discipline.time, pseudonym: discipline.time), category: "Время") {}
        }
        
        let disciplineAction = UIAction(title: "Дисциплина", image: UIImage(named: "book")) { _ in
            self.settingsManager.addTimetablePseudonym(model: PseudonymModel(originalName: discipline.name, pseudonym: discipline.name), category: "Дисциплины") {}
        }
        
        let teacherAction = UIAction(title: "Преподаватель", image: UIImage(named: "profile icon")) { _ in
            self.settingsManager.addTimetablePseudonym(model: PseudonymModel(originalName: discipline.teacherName, pseudonym: discipline.teacherName), category: "Преподаватели") {}
        }
        
        let auidienceAction = UIAction(title: "Аудитория", image: UIImage(named: "door")) { _ in
            self.settingsManager.addTimetablePseudonym(model: PseudonymModel(originalName: discipline.audienceID, pseudonym: discipline.audienceID), category: "Аудитории") {}
        }
        
        let groupAction = UIAction(title: "Группа", image: UIImage(named: "group")) { _ in
            self.settingsManager.addTimetablePseudonym(model: PseudonymModel(originalName: discipline.groupName, pseudonym: discipline.groupName), category: "Группы") {}
        }
        
        return UIMenu(title: "Добавить псевдоним", image: UIImage(named: "add"), children: [timeAction, disciplineAction, teacherAction, auidienceAction, groupAction])
    }
}
