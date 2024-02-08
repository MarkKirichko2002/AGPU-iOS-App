//
//  CalendarViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import FSCalendar

// MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.checkTimetable(date: date)
    }
}

// MARK: - FSCalendarDataSource
extension CalendarViewController: FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let color = viewModel.compareDates(date1: self.date, date2: date)
        return color
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.systemGreen
    }
}
