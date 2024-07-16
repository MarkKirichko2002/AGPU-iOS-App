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
        self.selection = selection
        viewModel.getWeather(location: location, startDate: Date(), endDate: dateComponents?.date ?? Date())
    }
}
