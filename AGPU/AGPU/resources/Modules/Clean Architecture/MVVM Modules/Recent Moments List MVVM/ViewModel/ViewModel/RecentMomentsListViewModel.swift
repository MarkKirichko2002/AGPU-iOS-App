//
//  RecentMomentsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 10.08.2023.
//

import Foundation

class RecentMomentsListViewModel {
    
    var alertHandler: ((String, String)->Void)?
    
    func registerAlertHandler(block: @escaping(String, String)->Void) {
        self.alertHandler = block
    }
}
