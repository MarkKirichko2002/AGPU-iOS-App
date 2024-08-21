//
//  CalendarARViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.08.2024.
//

import UIKit

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarARViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        viewModel.getTimetable(date: dateComponents?.date ?? Date())
    }
}

// MARK: - UICalendarViewDelegate
extension CalendarARViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: viewModel.compareDates(date1: self.date, date2: dateComponents.date ?? Date()))
    }
}
