//
//  AGPUSectionsListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 18.07.2023.
//

import Foundation

class AGPUSectionsListViewModel {
    
    func ObserveScroll(completion: @escaping(Int)->Void) {
        // Выбор раздела
        NotificationCenter.default.addObserver(forName: Notification.Name("ScrollToSection"), object: nil, queue: .main) { notification in
            if let section = notification.object as? Int {
                completion(section)
            }
        }
    }
}
