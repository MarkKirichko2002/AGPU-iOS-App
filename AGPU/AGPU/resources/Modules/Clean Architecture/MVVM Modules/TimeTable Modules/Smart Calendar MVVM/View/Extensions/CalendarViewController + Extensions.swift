//
//  CalendarViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import UIKit

// MARK: - UICalendarSelectionSingleDateDelegate
extension CalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        let date = DateManager().getFormattedDate(date: dateComponents?.date ?? Date())
        let vc = TimetableDateDetailViewController(id: self.id, date: date, owner: self.owner)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true)
        selection.selectedDate = nil
        HapticsManager.shared.hapticFeedback()
    }
}

// MARK: - UICalendarViewDelegate
extension CalendarViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .default(color: viewModel.compareDates(date1: self.date, date2: dateComponents.date ?? Date()))
    }
}

// MARK: - TimetableDateDetailViewControllerDelegate
extension CalendarViewController: TimetableDateDetailViewControllerDelegate {
    
    func dateWasSelected(model: TimeTableChangesModel) {
        delegate?.dateWasSelected(model: model)
        self.dismiss(animated: true)
    }
}
