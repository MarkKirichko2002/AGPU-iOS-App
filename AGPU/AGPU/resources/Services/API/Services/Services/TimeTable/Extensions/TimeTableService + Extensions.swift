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
    
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) {
        
        AF.request("http://\(HostName.host)/api/timetable/weeks").responseData { response in
            
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
    
    func getTimeTableDay(groupId: String, date: String, completion: @escaping(Result<TimeTable,Error>)->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host)/api/timetable/day?groupId=\(group)&date=\(date)").responseData { response in
            
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
    
    func getTimeTableWeek(groupId: String, startDate: String, endDate: String, completion: @escaping(Result<[TimeTable],Error>)->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host)/api/timetable/days?groupId=\(group)&startDate=\(startDate)&endDate=\(endDate)&removeEmptyDays").responseData { response in
            
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
            
            print(response.response?.statusCode)
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("нет")
            }
        }
    }
    
    func checkTimetableChanges(completion: @escaping () -> Void) {
        
        let group = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
        let url = "http://merqury.fun:8080/api/timetable/changes/day/check?groupId=\(group)&timeout=\(30)"

        print("Start polling")

        let semaphore = DispatchSemaphore(value: 0)

        var changesResponse: ChangesResponse?

        AF.request(url).responseData { response in
            
            defer {
                semaphore.signal()
            }

            guard let data = response.data else { return }

            do {
                let changes = try JSONDecoder().decode(ChangesResponse.self, from: data)
                print("Расписание: \(changes)")
                changesResponse = changes
            } catch {
                print(error.localizedDescription)
            }
        }

        semaphore.wait()

        if let changes = changesResponse {
            if changes.thereAreChanges {
                NotificationManager().sendTimetableNotification()
            } else {
               
            }
        }

        completion()
    }

    
    func startLongPolling() {
        
        DispatchQueue.global().async {
           
            while true {
                
                self.checkTimetableChanges {}
            }
        }
    }
}
