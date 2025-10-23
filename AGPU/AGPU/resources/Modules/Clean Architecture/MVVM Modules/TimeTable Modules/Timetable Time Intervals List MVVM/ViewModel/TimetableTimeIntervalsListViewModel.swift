//
//  TimetableTimeIntervalsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.10.2025.
//

import Foundation

final class TimetableTimeIntervalsListViewModel {
    
    var intervals = TimetableIntervals.intervals
    var selectedIntervals = [String]()
    
    var dataChangedHandler: (()->Void)?
    
    // MARK: - сервисы
    private let settingsManager = SettingsManager()
    
    func getIntervals() {
        selectedIntervals = settingsManager.loadTimetableIntervals()
        dataChangedHandler?()
    }
    
    func intervalItem(index: Int)-> String {
        return intervals[index]
    }
    
    func intervalsCount()-> Int {
        return intervals.count
    }
    
    func selectInterval(index: Int) {
        let interval = intervalItem(index: index)
        if selectedIntervals.contains(interval) {
            let index = selectedIntervals.firstIndex { $0 == interval }!
            selectedIntervals.remove(at: index)
        } else {
            selectedIntervals.append(interval)
        }
        HapticsManager.shared.hapticFeedback()
        dataChangedHandler?()
    }
    
    func saveAllIntervals() {
        settingsManager.saveIntervals(intervals: selectedIntervals) {
            self.getIntervals()
            HapticsManager.shared.hapticFeedback()
        }
    }
    
    func isIntervalSelected(index: Int)-> Bool {
        let interval = intervalItem(index: index)
        return selectedIntervals.contains(interval)
    }
        
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
