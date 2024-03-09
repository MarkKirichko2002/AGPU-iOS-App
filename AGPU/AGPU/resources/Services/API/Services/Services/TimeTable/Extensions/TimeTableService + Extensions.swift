//
//  TimeTableService + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import Alamofire

// MARK: - TimeTableServicerProtocol
extension TimeTableService: TimeTableServicerProtocol {
    
    func getSearchResults(searchText: String, completion: @escaping(Result<[SearchResultModel],Error>)->Void) {
        
        AF.request("https://www.it-institut.ru/SearchString/KeySearch?Id=118&SearchProductName=\(searchText)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let results = try JSONDecoder().decode([SearchResultModel].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTimeTableDay(id: String, date: String, owner: String, completion: @escaping(Result<TimeTable,Error>)->Void) {
        
        let id = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://agpu.merqury.fun/api/timetable/day?id=\(id)&date=\(date)&owner=\(owner)").responseData { response in
            
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
    
    func getTimeTableWeek(id: String, startDate: String, endDate: String, owner: String, completion: @escaping(Result<[TimeTable],Error>)->Void) {
        
        let id = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://agpu.merqury.fun/api/timetable/days?id=\(id)&startDate=\(startDate)&owner=\(owner)&endDate=\(endDate)&removeEmptyDays").responseData { response in
            
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
    
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) {
        
        AF.request("http://merqury.fun/api/timetable/weeks").responseData { response in
            
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
    
    func getTimeTableDayImage(json: Data, completion: @escaping(UIImage)->Void) {
        
        let url = "http://merqury.fun/api/timetable/image/day?vertical"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        AF.request(request).responseData { response in
            
            guard let data = response.data else {return}
            
            print(response.response?.statusCode)
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("нет")
            }
        }
    }
    
    func getTimeTableWeekImage(json: Data, completion: @escaping(UIImage)->Void) {
        
        let url = "http://merqury.fun/api/timetable/image/6days?horizontal"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        AF.request(request).responseData { response in
            
            guard let data = response.data else {return}
            
            print(response.response?.statusCode ?? 0)
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("нет")
            }
        }
    }
}
