//
//  WebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

// MARK: - WebViewModelProtocol
extension WebViewModel: WebViewModelProtocol {
    
    func observeScroll(completion: @escaping(CGPoint)->Void) {
        
        var positionX = 0
        var positionY = 0
        var scrollPosition = ""
        
        NotificationCenter.default.addObserver(forName: Notification.Name("scroll web page"), object: nil, queue: .main) { notification in
            scrollPosition = notification.object as? String ?? ""
            
            print(scrollPosition)
            
            if scrollPosition == "вверх" {
                positionY -= 30
            } else if scrollPosition == "вниз" {
                positionY += 30
            }
            
            if scrollPosition.contains("лево") {
                positionX -= 20
            } else if scrollPosition.contains("право") {
                positionX += 20
            }
            
            completion(CGPoint(x: positionX, y: positionY))
        }
    }
    
    func saveCurrentWebPage(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let page = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: page, key: "last page") {
            print("сохранено: \(page)")
        }
    }
    
    func observeActions(block: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("close screen"), object: nil, queue: nil) { _ in
            block()
        }
    }
    
    func observeSectionSelected(block: @escaping(AGPUSectionModel)->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("section selected"), object: nil, queue: .main) { notification in
            if let url = notification.object as? AGPUSectionModel {
                block(url)
            }
        }
    }
}
