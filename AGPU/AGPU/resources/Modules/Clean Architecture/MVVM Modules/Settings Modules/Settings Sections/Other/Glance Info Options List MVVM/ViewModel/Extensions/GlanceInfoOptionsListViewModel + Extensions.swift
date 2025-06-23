//
//  GlanceInfoOptionsListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 17.06.2025.
//

import Foundation

// MARK: - ITimetableOptionsListViewModel
extension GlanceInfoOptionsListViewModel: IGlanceInfoOptionsListViewModel {
    
    func getAllData() {
        options[0].info = getScreenStyleInfo()
        dataChangedHandler?()
    }
    
    func getScreenStyleInfo()-> String {
        return settingsManager.checkScreenPresentationStyleOption().rawValue
    }
            
    func observeOptionSelection() {
        NotificationCenter.default.addObserver(forName: Notification.Name("option was selected"), object: nil, queue: .main) { _ in
            self.getAllData()
            self.dataChangedHandler?()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
