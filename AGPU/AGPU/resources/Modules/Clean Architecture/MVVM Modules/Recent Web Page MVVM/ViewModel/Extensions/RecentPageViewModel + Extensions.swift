//
//  RecentPageViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 28.07.2023.
//

import Foundation

// MARK: - RecentPageViewModelProtocol
extension RecentPageViewModel: RecentPageViewModelProtocol {
    
    func GetLastPosition(currentUrl: String, completion: @escaping(CGPoint)->Void) {
        if let page = UserDefaults.loadData(type: RecentPageModel.self, key: "last page") {
            if currentUrl == page.url {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(page.position)
                }
            }
        }
    }
}
