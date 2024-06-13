//
//  PairTypesListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

// MARK: - PairTypesListViewModelProtocol
extension PairTypesListViewModel: PairTypesListViewModelProtocol {
    
    func typeItem(index: Int)-> PairType {
        return PairType.allCases[index]
    }
    
    func numberOfTypesInSection()-> Int {
        return PairType.allCases.count
    }
    
    func countForPairType(index: Int)-> Int {
        let type = typeItem(index: index)
        var filteredData = [Discipline]()
        var uniqueTimes: Set<String> = Set()
        
        allDisciplines = disciplines
        
        if type != .all {
            filteredData = type == .leftToday ? filterLeftedPairs(pairs: disciplines) : disciplines.filter({ $0.type == type })
        } else {
            filteredData = disciplines
        }
        
        for pair in filteredData {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
        
    }
    
    func filterLeftedPairs(pairs: [Discipline])-> [Discipline] {
        
        var disciplines = [Discipline]()
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime()
        
        for pair in pairs {
            
            let pairEndTime = "\(pair.time.components(separatedBy: "-")[1]):00"
            
            let timetableDate = date
            
            let compareDate = dateManager.compareDates(date1: timetableDate, date2: currentDate)
            let compareTime = dateManager.compareTimes(time1: pairEndTime, time2: currentTime)
            
            // прошлый день
            if compareDate == .orderedAscending {
                return disciplines
            }
            
            // время больше и тот же день
            if compareTime == .orderedDescending && compareDate == .orderedSame {
                disciplines.append(pair)
            }
            
            // следующий день
            if compareDate == .orderedDescending {
                return allDisciplines
            }
        }
        
        return disciplines
    }
    
    func choosePairType(index: Int) {
        let type = typeItem(index: index)
        self.type = type
        self.pairTypeSelectedHandler?()
        HapticsManager.shared.hapticFeedback()
    }
    
    func isCurrentType(index: Int)-> Bool {
        let type = typeItem(index: index)
        if type == self.type {
            return true
        } else {
            return false
        }
    }
    
    func registerPairTypeSelectedHandler(block: @escaping(()->Void)) {
        self.pairTypeSelectedHandler = block
    }
}
