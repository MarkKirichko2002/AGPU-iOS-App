//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

protocol TimeTableServicerProtocol {
    func GetWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) 
    func GetTimeTableDay(groupId: String, date: String, completion: @escaping(Result<TimeTable,Error>)->Void)
    func GetTimeTableWeek(groupId: String, startDate: String, endDate: String, completion: @escaping(Result<[TimeTable],Error>)->Void)
    
}