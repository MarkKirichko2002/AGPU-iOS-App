//
//  UserStatusListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 12.10.2023.
//

import Foundation

final class UserStatusListViewModel: NSObject {
    
    @objc dynamic var isChanged = false
    
    var observation: NSKeyValueObservation?
    
}
