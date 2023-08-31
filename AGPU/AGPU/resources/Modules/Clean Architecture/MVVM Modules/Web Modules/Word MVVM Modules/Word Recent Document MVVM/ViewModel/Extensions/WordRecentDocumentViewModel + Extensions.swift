//
//  WordRecentDocumentViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 13.08.2023.
//

import Foundation

// MARK: - WordRecentDocumentViewModelProtocol
extension WordRecentDocumentViewModel: WordRecentDocumentViewModelProtocol {
    
    func getRecentPosition(currentUrl: String, completion: @escaping(CGPoint)->Void) {
        if let page = UserDefaults.loadData(type: RecentWordDocumentModel.self, key: "last word document") {
            if currentUrl == page.url {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(page.position)
                }
            }
        }
    }
}
