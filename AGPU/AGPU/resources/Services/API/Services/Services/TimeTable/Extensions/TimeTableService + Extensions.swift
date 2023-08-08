//
//  TimeTableService + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation
import Alamofire

// MARK: - TimeTableServicerProtocol
extension TimeTableService: TimeTableServicerProtocol {
    
    func GetWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) {
        
        AF.request("http://\(HostName.host):8080/api/timetable/weeks").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let weeks = try JSONDecoder().decode([WeekModel].self, from: data)
                print("Недели: \(weeks)")
                completion(.success(weeks))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func GetTimeTableDay(groupId: String, date: String, completion: @escaping(Result<TimeTable,Error>)->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host):8080/api/timetable/day?groupId=\(group)&date=\(date)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode(TimeTable.self, from: data)
                print("Расписание: \(timetable)")
                completion(.success(timetable))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func GetTimeTableWeek(groupId: String, startDate: String, endDate: String, completion: @escaping(Result<[TimeTable],Error>)->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host):8080/api/timetable/days?groupId=\(groupId)&startDate=\(startDate)&endDate=\(endDate)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode([TimeTable].self, from: data)
                print("Расписание: \(timetable)")
                completion(.success(timetable))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
