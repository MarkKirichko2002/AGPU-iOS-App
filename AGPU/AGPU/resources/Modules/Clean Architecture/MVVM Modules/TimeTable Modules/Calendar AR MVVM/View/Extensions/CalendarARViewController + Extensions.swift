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
        let formattedDate = viewModel.getFormattedDate(date: dateComponents?.date ?? Date())
        viewModel.saveDate(date: formattedDate)
        delegate?.dateWasSelected(date: formattedDate)
        self.dismiss(animated: true)
    }
}

// MARK: - UICalendarViewDelegate
extension CalendarARViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: viewModel.compareDates(date1: self.date, date2: dateComponents.date ?? Date()))
    }
}
