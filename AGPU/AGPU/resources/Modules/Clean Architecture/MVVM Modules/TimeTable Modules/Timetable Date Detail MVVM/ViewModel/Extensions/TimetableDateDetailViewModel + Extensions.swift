//
//  TimetableDateDetailViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit

// MARK: - TimetableDateDetailViewModel
extension TimetableDateDetailViewModel: ITimetableDateDetailViewModel {
    
    func getTimeTableForDay() {
        timeTableService.getTimeTableDay(id: id, date: date, owner: owner) { [weak self] result in
            switch result {
            case .success(let data):
                self?.pairs = data.disciplines
                if !data.disciplines.isEmpty {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") пары: \(self?.getPairsCount() ?? 0)")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
                } else {
                    self?.getImage(json: data) { image in
                        let model = TimeTableDateModel(id: data.id, date: self?.date ?? "", image: image, description: "\(self?.formattedDate() ?? "") нет пар")
                        self?.image = image
                        self?.timeTableHandler?(model)
                    }
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
    
    func formattedDate()-> String {
        let date = "\(dateManager.getCurrentDayOfWeek(date: date)) \(date)"
        return date
    }
    
    func registerTimeTableHandler(block: @escaping (TimeTableDateModel) -> Void) {
        self.timeTableHandler = block
    }
}
