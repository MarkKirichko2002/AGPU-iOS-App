//
//  AllWeeksListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

// MARK: - AllWeeksListViewModelProtocol
extension AllWeeksListViewModel: AllWeeksListViewModelProtocol {
    
    func GetWeeks() {
        service.GetWeeks { result in
            switch result {
            case .success(let weeks):
                self.weeks = weeks
                self.isChangedHandler?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func registerIsChangedHandler(block: @escaping(()->Void)) {
        self.isChangedHandler = block
    }
    
    func GetCurrentWeek() {
        for week in weeks {
            let isRange = dateManager.DateRange(startDate: week.from, endDate: week.to)
            if isRange {
                DispatchQueue.main.async {
                    self.ScrollHandler?(week.id - 1)
                }
            }
        }
    }
    
    func registerScrollHandler(block: @escaping((Int)->Void)) {
        self.ScrollHandler = block
    }
    
    func isCurrentWeek(index: Int)-> Bool {
        let week = weeks[index]
        let isRange = dateManager.DateRange(startDate: week.from, endDate: week.to)
        return isRange
    }
}
