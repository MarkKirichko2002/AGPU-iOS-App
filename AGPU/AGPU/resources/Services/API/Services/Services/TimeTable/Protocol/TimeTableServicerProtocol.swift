//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

protocol TimeTableServicerProtocol {
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void)
    func getTimeTableDay(groupId: String, date: String, completion: @escaping(Result<TimeTable,Error>)->Void)
    func getTimeTableWeek(groupId: String, startDate: String, endDate: String, completion: @escaping(Result<[TimeTable],Error>)->Void)
    func getTimeTableImage(json: Data, completion: @escaping(UIImage)->Void)
}
