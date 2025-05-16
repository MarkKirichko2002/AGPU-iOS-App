//
//  TimeTableService + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit
import Alamofire
import Foundation

struct TimetableImage: Codable {
    let url: String
    let size: Int
}

// MARK: - TimeTableServicerProtocol
extension TimeTableService: TimeTableServicerProtocol {
    
    func getSearchResults(searchText: String, completion: @escaping(Result<[SearchResultModel],Error>)->Void) {
        
        AF.request("https://it-institut.ru/SearchString/KeySearch?Id=118&SearchProductName=\(searchText)").responseData { response in
            
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
        
        AF.request("http://\(domain)/api/v2/timetable/day?id=\(id)&date=\(date)&owner=\(owner)").responseData { response in
            
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
        
        AF.request("http://\(domain)/api/v2/timetable/days?id=\(id)&startDate=\(startDate)&owner=\(owner)&endDate=\(endDate)&removeEmptyDays").responseData { response in
            
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
    
    func getGroups(completion: @escaping(Result<[FacultyGroupModel],Error>)->Void) {
        
        AF.request("http://\(HostName.host)/api/v2/timetable/groups").responseData { response in
        
            guard let data = response.data else {return}
            
            do {
                let groups = try JSONDecoder().decode([FacultyGroupModel].self, from: data)
                print("Группы: \(groups)")
                completion(.success(groups))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) {
        
        AF.request("http://\(domain)/api/v2/timetable/weeks").responseData { response in
            
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
        
        let url = "http://\(domain):8081/api/v2/timetable/image/day?vertical"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        AF.request(request).responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let image = try JSONDecoder().decode(TimetableImage.self, from: data)
                self.getImage(from: "http://\(HostName.host):8081\(image.url)") { image in
                    completion(image)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getTimeTableWeekImage(json: Data, completion: @escaping(UIImage)->Void) {
        
        let url = "http://\(domain):8081/api/v2/timetable/image/6days?horizontal"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        
        AF.request(request).responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let image = try JSONDecoder().decode(TimetableImage.self, from: data)
                self.getImage(from: "http://\(HostName.host):8081\(image.url)") { image in
                    completion(image)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getImage(from url: String, completion: @escaping(UIImage)->Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, error, _ in
            guard let data = data else {return}
            if let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
}
