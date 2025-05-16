//
//  CurrentTabOptionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 14.12.2024.
//

import Foundation

final class CurrentTabOptionsListViewModel {
    
    var itemSelectedHandler: (()->Void)?
    var title: String
    var currentSection: TabOptionsSectionModel
    var alertHandler: ((String, String)->Void)?
    
    // MARK: - сервисы
    let settingsManager = SettingsManager()
    
    init(title: String) {
        self.title = title
        self.currentSection = TabOptionsSections.sections.first(where: { $0.title == title })!
    }
}
