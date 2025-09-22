//
//  TimeTableSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2024.
//

import UIKit

extension TimeTableSplashScreenViewModel: ITimeTableSplashScreenViewModel {
    
    func getTimeTable() {
        let id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-4-1"
        let date = dateManager.getCurrentDate()
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: "", date: "", image: image, description: "\(date) есть пары: \(self?.getPairsCount() ?? 0)")
                        self?.timeTableHandler?(model)
                    }
                } else {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: id, date: date, image: image, description: "\(date) нет пар")
                        self?.timeTableHandler?(model)
                    }
                }
            case .failure(let error):
                let data = TimeTable(id: id, date: date, disciplines: [])
                self?.getImage(json: data) { image in
                    let model = TimeTableDateModel(id: id, date: date, image: image, description: "\(date) нет пар")
                    self?.timeTableHandler?(model)
                }
                print(error)
            }
        }
    }
    
    func getImage(json: Codable, completion: @escaping(UIImage)->Void) {
    
        let id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-4-1"
        let date = dateManager.getCurrentDate()
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        
        let emptyTimetable = TimeTable(id: id, date: dateManager.getCurrentDate(), disciplines: [])
        
        if !self.pairs.isEmpty {
            do {
                let timetable = TimeTable(id: id, date: dateManager.getCurrentDate(), disciplines: pairs)
                let json = try JSONEncoder().encode(timetable)
                self.timeTableService.getTimeTableDayImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode(emptyTimetable)
                self.timeTableService.getTimeTableDayImage(json: json) { image in
                    completion(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPairsCount()-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in pairs {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
    }
    
    func textColor()-> UIColor {
        if pairs.isEmpty {
            return .systemGray
        } else {
            return .systemGreen
        }
    }
    
    func registerTimeTableHandler(block: @escaping(TimeTableDateModel)->Void) {
        self.timeTableHandler = block
    }
}
