//
//  TimetableDayInfoViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 17.05.2025.
//

import Foundation

final class TimetableDayInfoViewModel {
    
    var infoHandler: ((String, Int)->Void)?
    
    // MARK: - сервисы
    private let service = TimeTableService()
    private let settingsManager = SettingsManager()
    private let dateManager = DateManager()
    
    func getTimetableDayInfo() {
        let id = settingsManager.getSavedID()
        let date = dateManager.getCurrentDate()
        let owner = settingsManager.getSavedOwner()
        service.getTimeTableDay(id: id, date: date, owner: owner) { result in
            switch result {
            case .success(let data):
                self.infoHandler?(data.date, self.getPairsCount(pairs: data.disciplines))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPairsCount(pairs: [Discipline])-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
                            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
    }
    
    func registerInfoHandler(block: @escaping(String, Int)->Void) {
        self.infoHandler = block
    }
}
