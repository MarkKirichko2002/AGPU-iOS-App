//
//  RecentWebPageViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.07.2023.
//

import Foundation

// MARK: - RecentWebPageViewModelProtocol
extension RecentWebPageViewModel: RecentWebPageViewModelProtocol {
    
    func getRecentPosition(currentUrl: String, completion: @escaping(CGPoint)->Void) {
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page") {
            if currentUrl == page.url {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    completion(page.position)
                }
            }
        }
    }
}
