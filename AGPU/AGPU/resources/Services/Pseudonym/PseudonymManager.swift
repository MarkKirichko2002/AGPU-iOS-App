//
//  PseudonymManager.swift
//  AGPU
//
//  Created by Марк Киричко on 16.10.2025.
//

import Foundation

final class PseudonymManager {
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    private let dateManager = DateManager()
    
    func setUpTimetablePseudonyms(pairs: inout [Discipline])-> [Discipline] {
        pairs = setUpTimesPseudonym(pairs: &pairs)
        pairs = setUpDisciplinesPseudonym(pairs: &pairs)
        pairs = setUpTeachersPseudonym(pairs: &pairs)
        pairs = setUpAudiencePseudonym(pairs: &pairs)
        pairs = setUpGroupPseudonym(pairs: &pairs)
        return pairs
    }
    
    func setUpTimetableOriginal(pairs: inout [Discipline])-> [Discipline] {
        pairs = setUpTimesOriginal(pairs: &pairs)
        pairs = setUpDisciplinesOriginal(pairs: &pairs)
        pairs = setUpTeachersOriginal(pairs: &pairs)
        pairs = setUpAudienceOriginal(pairs: &pairs)
        pairs = setUpGroupOriginal(pairs: &pairs)
        return pairs
    }
    
    // MARK: - псевдонимы
    func setUpTimesPseudonym(pairs: inout [Discipline])-> [Discipline] {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Время")
        for (i, discipline) in pairs.enumerated() {
            if let pseudonym = pseudonyms.first(where: { $0.originalName == discipline.time })?.pseudonym {
                pairs[i].time = pseudonym
            }
        }
        return pairs
    }
    
    func setUpDisciplinesPseudonym(pairs: inout [Discipline])-> [Discipline] {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Дисциплины")
        for (i, discipline) in pairs.enumerated() {
            if let pseudonym = pseudonyms.first(where: { $0.originalName == discipline.name })?.pseudonym {
                pairs[i].name = pseudonym
            }
        }
        return pairs
    }
    
    func setUpTeachersPseudonym(pairs: inout [Discipline])-> [Discipline] {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Преподаватели")
        for (i, discipline) in pairs.enumerated() {
            if let pseudonym = pseudonyms.first(where: { $0.originalName == discipline.teacherName })?.pseudonym {
                pairs[i].teacherName = pseudonym
            }
        }
        return pairs
    }
    
    func setUpAudiencePseudonym(pairs: inout [Discipline])-> [Discipline] {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Аудитории")
        for (i, discipline) in pairs.enumerated() {
            if let pseudonym = pseudonyms.first(where: { $0.originalName == discipline.audienceID })?.pseudonym {
                pairs[i].audienceID = pseudonym
            }
        }
        return pairs
    }
    
    func setUpGroupPseudonym(pairs: inout [Discipline])-> [Discipline] {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Группы")
        for (i, discipline) in pairs.enumerated() {
            if let pseudonym = pseudonyms.first(where: { $0.originalName == discipline.groupName })?.pseudonym {
                pairs[i].groupName = pseudonym
            }
        }
        return pairs
    }
    
    func setUpDayOfWeekPseudonym(date: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Дни недели")
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        if let pseudonym = pseudonyms.first(where: { $0.originalName == dayOfWeek })?.pseudonym {
            return "\(pseudonym) \(date)"
        }
        return "\(dayOfWeek) \(date)"
    }
    
    // MARK: - оригинальные названия
    func setUpTimesOriginal(pairs: inout [Discipline])-> [Discipline] {
        for (i, discipline) in pairs.enumerated() {
            pairs[i].time = returnOriginalTime(time: discipline.time)
        }
        return pairs
    }
    
    func setUpDisciplinesOriginal(pairs: inout [Discipline])-> [Discipline] {
        for (i, discipline) in pairs.enumerated() {
            pairs[i].name = returnOriginalDisciplineName(name: discipline.name)
        }
        return pairs
    }
    
    func setUpTeachersOriginal(pairs: inout [Discipline])-> [Discipline] {
        for (i, discipline) in pairs.enumerated() {
            pairs[i].teacherName = returnOriginalTeacherName(name: discipline.teacherName)
        }
        return pairs
    }
    
    func setUpAudienceOriginal(pairs: inout [Discipline])-> [Discipline] {
        for (i, discipline) in pairs.enumerated() {
            pairs[i].audienceID = returnOriginalAudienceName(audience: discipline.audienceID)
        }
        return pairs
    }
    
    func setUpGroupOriginal(pairs: inout [Discipline])-> [Discipline] {
        for (i, discipline) in pairs.enumerated() {
            pairs[i].groupName = returnOriginalGroupName(group: discipline.groupName)
        }
        return pairs
    }
    
    func setUpDayOfWeekOriginal(date: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Дни недели")
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        if let pseudonym = pseudonyms.first(where: { $0.originalName == dayOfWeek })?.originalName {
            return "\(pseudonym) \(date)"
        }
        return "\(dayOfWeek) \(date)"
    }
    
    func returnOriginalTime(time: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Время")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == time })?.originalName {
            return originalName
        }
        return time
    }
    
    func returnOriginalDisciplineName(name: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Дисциплины")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == name })?.originalName {
            print("ОРИГИНАЛ: \(originalName)")
            return originalName
        } else {
            print("НЕТ ТАКОГО")
            print(name)
        }
        return name
    }
    
    func returnOriginalTeacherName(name: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Преподаватели")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == name })?.originalName {
            return originalName
        }
        return name
    }
    
    func returnOriginalAudienceName(audience: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Аудитории")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == audience })?.originalName {
            return originalName
        }
        return audience
    }
    
    func returnOriginalGroupName(group: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Группы")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == group })?.originalName {
            return originalName
        }
        return group
    }
    
    func returnOriginalBuildingName(building: String)-> String {
        let pseudonyms = settingsManager.loadTimetablePseudonyms(category: "Корпуса")
        if let originalName = pseudonyms.first(where: { $0.pseudonym == building })?.originalName {
            return originalName
        }
        return building
    }
}
