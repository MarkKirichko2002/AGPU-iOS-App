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
    
    func GetTimeTable(groupId: String, date: String, completion: @escaping([TimeTable])->Void) {
        
        let group = groupId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://merqury.fun:8080/api/timetable?groupId=\(group)&date=\(date)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode([TimeTable].self, from: data)
                print(timetable)
                completion(timetable)
            } catch {
                print(error)
            }
        }
    }
}
