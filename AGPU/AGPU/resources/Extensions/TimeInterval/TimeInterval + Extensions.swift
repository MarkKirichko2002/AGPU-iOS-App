//
//  TimeInterval + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import Foundation

extension TimeInterval {
    
    func formatTime()-> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        let formattedString = formatter.string(from: self) ?? "00:00"
        return formattedString
    }
}
