//
//  TimeTableService.swift
//  AGPU
//
//  Created by Марк Киричко on 12.07.2023.
//

import Foundation

final class TimeTableService {

    // MARK: - сервисы
    let firebaseManager = FirebaseManager()
    var domain = HostName.host
    
    init() {
        firebaseManager.getConfig { domain in
            print("домин: \(domain)")
            self.domain = domain
        }
    }
}
