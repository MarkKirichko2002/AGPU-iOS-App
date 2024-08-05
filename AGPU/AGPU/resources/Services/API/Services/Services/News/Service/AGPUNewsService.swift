//
//  AGPUNewsService.swift
//  AGPU
//
//  Created by Марк Киричко on 08.08.2023.
//

import Foundation

final class AGPUNewsService {
    
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
