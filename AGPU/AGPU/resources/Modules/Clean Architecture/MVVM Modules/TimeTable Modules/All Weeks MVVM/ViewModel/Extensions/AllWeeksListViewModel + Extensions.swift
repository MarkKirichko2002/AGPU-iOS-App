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
        service.getWeeks { [weak self] result in
            switch result {
            case .success(let weeks):
                self?.weeks = weeks
                self?.isChangedHandler?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfWeeks()-> Int {
        return weeks.count
    }
    
    func weekItem(index: Int)-> WeekModel {
        return weeks[index]
    }
    
    func registerIsChangedHandler(block: @escaping(()->Void)) {
        self.isChangedHandler = block
    }
    
    func getCurrentWeek() {
        if !weeks.isEmpty {
            for week in weeks {
                let isRange = dateManager.dateRange(startDate: week.from, endDate: week.to)
                if isRange {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        self.ScrollHandler?(week.id - 1)
                    }
                }
            }
        }
    }
    
    func registerScrollHandler(block: @escaping((Int)->Void)) {
        self.ScrollHandler = block
    }
    
    func isCurrentWeek(index: Int)-> Bool {
        let week = weeks[index]
        let isRange = dateManager.dateRange(startDate: week.from, endDate: week.to)
        return isRange
    }
}
