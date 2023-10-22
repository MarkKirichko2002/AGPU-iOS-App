//
//  PairInfoViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 23.10.2023.
//

import Foundation

// MARK: - PairInfoViewModelProtocol
extension PairInfoViewModel: PairInfoViewModelProtocol {
    
    func setUpData() {
        let startTime = getStartTime()
        let endTime = getEndTime()
        let pairType = getPairType(type: pair.type)
        let subGroup = checkSubGroup(subgroup: pair.subgroup)
        pairInfo.append("начало: \(startTime)")
        pairInfo.append("конец: \(endTime)")
        pairInfo.append("подгруппа: \(subGroup)")
        pairInfo.append("тип пары: \(pairType)")
        pairInfo.append("аудитория: \(pair.audienceID)")
        pairInfo.append("дисциплина: \(pair.name)")
        pairInfo.append("преподаватель: \(pair.teacherName)")
        pairInfo.append("группа: \(pair.groupName)")
        dataChangedHandler?()
    }
    
    func getStartTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[0]
        return startTime
    }
    
    func getEndTime()-> String {
        let times = pair.time.components(separatedBy: "-")
        let startTime = times[1]
        return startTime
    }
    
    func getPairType(type: PairType)-> String {
        switch type {
        case .lec:
            return "лекция"
        case .prac:
            return "практика"
        case .exam:
            return "экзамен"
        case .lab:
            return "лабораторная работа"
        case .hol:
            return "каникулы"
        case .cred:
            return "зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "консультация"
        case .none:
            return "другое"
        case .all:
            return ""
        }
    }
    
    func checkSubGroup(subgroup: Int)-> String {
        if subgroup == 0 && !pair.name.contains("Дисциплина по выбору") {
            return "общая пара"
        } else if pair.name.contains("Дисциплина по выбору") {
            return "отсутствует"
        } else {
            return "\(subgroup)"
        }
    }
    
    func checkIsCurrentGroup(index: Int)-> Bool {
        let savedGroup = UserDefaults.standard.string(forKey: "group") ?? ""
        if pairInfo[index].contains(savedGroup) {
            return true
        } else {
            return false
        }
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
