//
//  TimeInterval + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 24.10.2024.
//

import Foundation

extension TimeInterval {
    func getTime()-> [Int] {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        return [hours, minutes, seconds]
    }
}
