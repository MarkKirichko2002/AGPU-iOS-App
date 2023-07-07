//
//  AGPUMainViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

class AGPUMainViewModel {
    
    // MARK: - cервисы
    private let dateManager = DateManager()
    
    private var dateHandler: ((String)->Void)?
    
    func registerDateHandler(block: @escaping(String)->Void) {
        self.dateHandler = block
    }
    
    func GetDate() {
        DispatchQueue.main.async {
            self.dateHandler?(self.dateManager.getCurrentDate())
        }
    }
}
