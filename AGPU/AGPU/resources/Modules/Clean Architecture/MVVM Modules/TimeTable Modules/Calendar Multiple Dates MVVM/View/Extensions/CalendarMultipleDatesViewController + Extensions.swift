//
//  CalendarMultipleDatesViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarMultipleDatesViewController: UICalendarViewDelegate, UICalendarSelectionMultiDateDelegate {
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        navigationItem.title = "Выбрано дат: \(selection.selectedDates.count)"
        self.selection = selection
        HapticsManager.shared.hapticFeedback()
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        navigationItem.title = "Выбрано дат: \(selection.selectedDates.count)"
        self.selection = selection
        HapticsManager.shared.hapticFeedback()
    }
}
