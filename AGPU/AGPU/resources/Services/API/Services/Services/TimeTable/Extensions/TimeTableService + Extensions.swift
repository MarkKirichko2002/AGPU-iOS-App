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
    
    func getTimeTableDay(id: String, date: String, owner: String, completion: @escaping (Result<TimeTable, Error>) -> Void) {
        Task {
            do {
                guard let timetableOwner = TimetableOwner(rawValue: owner.capitalized) else {
                    throw NSError(domain: "InvalidOwner", code: 0)
                }
                
                let days = try await GetTimetableService.shared.getDisciplines(
                    id: id,
                    owner: timetableOwner,
                    startDate: date,
                    endDate: date
                )
                
                guard let day = days.first else {
                    throw NSError(domain: "NoData", code: 0)
                }
                
                let timetable = TimeTable(id: day.owner?.rawValue ?? "", date: day.date, disciplines: day.lessons.map({ Discipline(time: $0.time ?? "", name: $0.name ?? "", groupName: $0.groupName ?? "", teacherName: $0.teacherName ?? "", audienceID: $0.audienceId ?? "", subgroup: $0.subgroup, type: $0.type)
                    
                }))
                
                completion(.success(timetable))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTimeTableWeek(id: String, startDate: String, endDate: String, owner: String, completion: @escaping (Result<[TimeTable], Error>) -> Void) {
        // Маппинг строки owner в TimetableOwner
        guard let timetableOwner = TimetableOwner(rawValue: owner.capitalized) else {
            let error = NSError(domain: "TimetableError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid owner type: \(owner)"])
            completion(.failure(error))
            return
        }
        
        Task {
            do {
                let timetableDays = try await GetTimetableService.shared.getDisciplines(
                    id: id,
                    owner: timetableOwner,
                    startDate: startDate,
                    endDate: endDate
                )
                
                // Преобразуем [TimetableDay] в [TimeTable]
                var timeTables = timetableDays.map { TimeTable(id: $0.owner?.rawValue ?? "", date: $0.date, disciplines: $0.lessons.map({ Discipline(time: $0.time ?? "", name: $0.name ?? "", groupName: $0.groupName ?? "", teacherName: $0.teacherName ?? "", audienceID: $0.audienceId ?? "", subgroup: $0.subgroup, type: $0.type)
                    
                })) }
                
                timeTables = timeTables.filter { !$0.disciplines.isEmpty }
                completion(.success(timeTables))
            } catch {
                print("Error fetching timetable: \(error)")
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
    
    func getWeeks(completion: @escaping (Result<[WeekModel], Error>) -> Void) {
        completion(.success(GetWeeksService.shared.collectWeeks()))
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
