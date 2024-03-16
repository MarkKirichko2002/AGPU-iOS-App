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
        let date = DateManager().getFormattedDate(date: date)
        let vc = TimetableDateDetailViewController(id: self.id, date: date, owner: self.owner)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true)
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

// MARK: - TimetableDateDetailViewControllerDelegate
extension CalendarViewController: TimetableDateDetailViewControllerDelegate {
    
    func dateWasSelected(date: String) {
        viewModel.sendNotificationDataWasSelected(date: date)
        self.dismiss(animated: true)
    }
}
