//
//  ICalendarMultipleDatesViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 26.06.2024.
//

import UIKit

protocol ICalendarMultipleDatesViewModel {
    func selectDates(dates: UICalendarSelectionMultiDate)
    func registerAlertHandler(block: @escaping() -> Void)
}
