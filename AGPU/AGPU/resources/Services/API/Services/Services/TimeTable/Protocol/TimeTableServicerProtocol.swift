//
//  TimeTableServicerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

protocol TimeTableServicerProtocol {
    func getSearchResults(searchText: String, completion: @escaping(Result<[SearchResultModel],Error>)->Void)
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void)
    func getTimeTableDay(groupId: String, date: String, completion: @escaping(Result<TimeTable,Error>)->Void)
    func getTimeTableWeek(groupId: String, startDate: String, endDate: String, completion: @escaping(Result<[TimeTable],Error>)->Void)
    func getTimeTableDayImage(json: Data, completion: @escaping(UIImage)->Void)
    func getTimeTableWeekImage(json: Data, completion: @escaping(UIImage)->Void)
    func getDisciplineImage(json: Data, completion: @escaping(UIImage)->Void)
}
