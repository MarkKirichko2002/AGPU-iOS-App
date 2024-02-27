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
                        let model = TimeTableDateModel(image: image, description: "\(self?.date ?? "") есть пары")
                        self?.timeTableHandler?(model)
                    }
                } else {
                    let model = TimeTableDateModel(image: UIImage(), description: "\(self?.date ?? "") нет пар")
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
    
    func textColor()-> UIColor {
        if pairs.isEmpty {
            return .systemGray
        } else {
            return .systemGreen
        }
    }
    
    func registerTimeTableHandler(block: @escaping (TimeTableDateModel) -> Void) {
        self.timeTableHandler = block
    }
}
