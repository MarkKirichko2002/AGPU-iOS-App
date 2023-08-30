//
//  DateManagerProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

protocol DateManagerProtocol {
    func getCurrentDate()-> String
    func getCurrentTime()-> String
    func getDateFromOtherFormat(date: String)-> String
    func nextDay(date: String)-> String
    func previousDay(date: String)-> String
    func dateRange(startDate: String, endDate: String)-> Bool
}
