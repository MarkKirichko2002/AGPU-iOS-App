//
//  TimeTableSplashScreenViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.03.2024.
//

import UIKit

extension TimeTableSplashScreenViewModel: ITimeTableSplashScreenViewModel {
    
    func getTimeTable() {
        let id = UserDefaults.standard.object(forKey: "group") as? String ?? "ВМ-ИВТ-2-1"
        let date = dateManager.getCurrentDate()
        let owner = UserDefaults.standard.object(forKey: "recentOwner") as? String ?? "GROUP"
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(image: image, description: "Сегодня есть пары: \(self?.getPairsCount() ?? 0)")
                        self?.timeTableHandler?(model)
                    }
                } else {
                    let model = TimeTableDateModel(image: UIImage(), description: "Сегодня нет пар")
                    self?.timeTableHandler?(model)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImage(json: Codable, completion: @escaping(UIImage)->Void) {
        do {
            let json = try JSONEncoder().encode(json)
            self.timeTableService.getTimeTableDayImage(json: json) { image in
                completion(image)
            }
        } catch {
            print(error.localizedDescription)
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
