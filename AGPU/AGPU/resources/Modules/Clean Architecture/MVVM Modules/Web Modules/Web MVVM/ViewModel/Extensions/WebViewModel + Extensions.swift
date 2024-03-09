//
//  WebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - WebViewModelProtocol
extension WebViewModel: WebViewModelProtocol {
    
    func saveCurrentWebPage(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let page = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: page, key: "last page") {
            print("сохранено: \(page)")
        }
    }
    
    func saveCurrentWebArticle(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let article = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: article, key: "last article") {
            print("сохранено: \(article)")
        }
    }
    
    func checkWebType(url: String, position: CGPoint) {
        if url.contains("news") {
            saveCurrentWebArticle(url: url, position: position)
        } else {
            saveCurrentWebPage(url: url, position: position)
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
                    UserDefaults.standard.setValue(item, forKey: "category")
                    print("Категория \(newsCategory.name) сохранена!")
                }
            } else if item == "EducationalTechnopark" {
                NotificationCenter.default.post(name: Notification.Name("category"), object: item.lowercased())
                NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                UserDefaults.standard.setValue(item.lowercased(), forKey: "category")
                print("Категория сохранена!")
            } else {
                if let newsCategory = NewsCategories.categories.first(where: { $0.newsAbbreviation == item }) {
                    NotificationCenter.default.post(name: Notification.Name("category"), object: item.lowercased())
                    NotificationCenter.default.post(name: Notification.Name("option was selected"), object: nil)
                    UserDefaults.standard.setValue(item.lowercased(), forKey: "category")
                    print("Категория \(newsCategory.name) сохранена!")
                }
            }
        }
    }
    
    func observeActions(block: @escaping(Actions)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("actions"), object: nil, queue: nil) { notification in
            if let action = notification.object as? Actions {
                block(action)
            }
        }
    }
    
    func observeSectionSelected(block: @escaping(AGPUSectionModel)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("section selected"), object: nil, queue: .main) { notification in
            if let section = notification.object as? AGPUSectionModel {
                block(section)
            }
        }
    }
    
    func observeSubSectionSelected(block: @escaping(AGPUSubSectionModel)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("subsection selected"), object: nil, queue: .main) { notification in
            if let subsection = notification.object as? AGPUSubSectionModel {
                block(subsection)
            }
        }
    }
    
    func observeScroll(completion: @escaping(CGPoint)->Void) {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("scroll web page"), object: nil, queue: nil) { notification in
            
            var scrollPosition = ""
            var positionX = self.scrollView.contentOffset.x
            var positionY = self.scrollView.contentOffset.y
            
            scrollPosition = notification.object as? String ?? ""
            
            print(scrollPosition)
            print(positionX)
            print(positionY)
            
            if scrollPosition == "вверх" {
                positionY -= 50
            } else if scrollPosition.contains("низ"){
                positionY += 50
            }
            
            if scrollPosition.contains("лев") {
                positionX -= 20
            } else if scrollPosition.contains("прав") {
                positionX += 20
            }
            
            completion(CGPoint(x: positionX, y: positionY))
        }
    }
}
