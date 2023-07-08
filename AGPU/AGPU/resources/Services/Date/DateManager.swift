//
//  DateManager.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

class DateManager: DateManagerProtocol {
    
    private let date = Date()
    private let dateFormatter = DateFormatter()
    
    func getCurrentDate()-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd MMMM yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getCurrentTime()-> String {
        let date = Date()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
}
