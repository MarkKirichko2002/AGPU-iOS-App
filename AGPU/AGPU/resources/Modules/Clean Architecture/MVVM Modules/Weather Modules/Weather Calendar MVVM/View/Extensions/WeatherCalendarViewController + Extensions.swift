//
//  WeatherCalendarViewController + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 15.07.2024.
//

import UIKit
import CoreLocation

// MARK: - UICalendarSelectionSingleDateDelegate
extension WeatherCalendarViewController: UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        viewModel.getWeather(location: CLLocation(latitude: 44.9892, longitude: 41.1234), startDate: Date(), endDate: dateComponents?.date ?? Date())
    }
}

// MARK: - TimetableDateDetailViewControllerDelegate
extension WeatherCalendarViewController: TimetableDateDetailViewControllerDelegate {
    
    func dateWasSelected(model: TimeTableChangesModel) {
        delegate?.dateWasSelected(model: model)
        self.dismiss(animated: true)
    }
}
