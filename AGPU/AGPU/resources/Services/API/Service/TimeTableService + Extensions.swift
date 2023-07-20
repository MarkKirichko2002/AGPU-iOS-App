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
    
    func GetAllGroups(completion: @escaping ([String: [String]]) -> Void) {
        
        AF.request("http://merqury.fun:8080/api/allGroups").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let groups = try JSONDecoder().decode([String: [String]].self, from: data)
                print(groups)
                completion(groups)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func GetTimeTable(groupId: String, date: String, completion: @escaping([TimeTable])->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://merqury.fun:8080/api/timetableOfDay?groupId=\(group)&date=\(date)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode([TimeTable].self, from: data)
                print("Расписание: \(timetable)")
                completion(timetable)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
