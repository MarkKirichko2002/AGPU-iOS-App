//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

protocol TimeTableServicerProtocol {
    func getSearchResults(searchText: String, completion: @escaping(Result<[SearchResultModel],Error>)->Void)
    func getTimeTableDay(id: String, date: String, owner: String, completion: @escaping(Result<TimeTable,Error>)->Void)
    func getTimeTableWeek(id: String, startDate: String, endDate: String, owner: String, completion: @escaping(Result<[TimeTable],Error>)->Void)
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void)
    func getTimeTableDayImage(json: Data, completion: @escaping(UIImage)->Void)
    func getTimeTableWeekImage(json: Data, completion: @escaping(UIImage)->Void)
}
