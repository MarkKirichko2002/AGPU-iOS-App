//
//  TimeTableSoundsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 02.04.2024.
//

import Foundation

class TimeTableSoundsListViewModel {
    
    // MARK: - сервисы
    let audioPlayerClass = AudioPlayerClass()
    
    var dataChangedHandler: (()->Void)?
}
