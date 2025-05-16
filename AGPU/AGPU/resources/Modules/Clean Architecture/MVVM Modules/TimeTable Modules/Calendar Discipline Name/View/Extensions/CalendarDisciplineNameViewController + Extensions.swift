//
//  CalendarDisciplineNameViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 26.04.2025.
//

import UIKit

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarDisciplineNameViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let date = viewModel.getFormattedDate(date: selection.selectedDate?.date ?? Date())
        viewModel.checkTimetable(date: date, name: name)
    }
}

// MARK: - UICalendarViewDelegate
extension CalendarDisciplineNameViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: viewModel.compareDates(date1: self.date, date2: dateComponents.date ?? Date()))
    }
}
