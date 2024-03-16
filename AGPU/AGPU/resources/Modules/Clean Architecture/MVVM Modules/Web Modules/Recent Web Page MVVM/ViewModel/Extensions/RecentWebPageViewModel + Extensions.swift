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
        if let page = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last page")  {
            if currentUrl == page.url {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    completion(page.position)
                }
            }
        } 
        
        if let article = UserDefaults.loadData(type: RecentWebPageModel.self, key: "last article") {
            if currentUrl == article.url {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    completion(article.position)
                }
            }
        }
    }
    
    func checkWebPage(url: String) {
        let items = url.components(separatedBy: "/")
        print(items)
        for item in items {
            if item == "PedagogicalQuantorium" {
                if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == item }) {
                    NotificationCenter.default.post(name: Notification.Name("category"), object: item)
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    print("Категория \(newsCategory.name) сохранена!")
                }
            } else if item == "EducationalTechnopark" {
                NotificationCenter.default.post(name: Notification.Name("category"), object: item.lowercased())
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                print("Категория сохранена!")
            } else {
                if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == item }) {
                    NotificationCenter.default.post(name: Notification.Name("category"), object: item.lowercased())
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    print("Категория \(newsCategory.name) сохранена!")
                }
            }
        }
    }
}
