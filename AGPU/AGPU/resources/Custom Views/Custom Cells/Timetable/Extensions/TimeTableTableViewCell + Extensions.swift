//
//  TimeTableTableViewCell + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2024.
//

import Foundation

extension TimeTableTableViewCell {
    
    func isEnded(date: String, time: String)-> Bool  {
        
        let currentTime = DateManager().getCurrentTime()
        let currentDate = DateManager().getCurrentDate()
        
        let compareTime = DateManager().compareTimes(time1: "\(time):00", time2: currentTime)
        let compareDate = DateManager().compareDates(date1: date, date2: currentDate)
        
        // прошлый день
        if compareDate == .orderedAscending {
            return true
        }
        
        // время меньше и тот же день
        if compareTime == .orderedAscending && compareDate == .orderedSame {
            return true
        }
        
        // время такое же и тот же день
        if compareTime == .orderedSame && compareDate == .orderedSame  {
            return true
        }
        
        return false
    }
}
