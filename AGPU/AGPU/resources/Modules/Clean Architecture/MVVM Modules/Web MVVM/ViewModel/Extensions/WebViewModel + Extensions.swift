//
//  WebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import Foundation

// MARK: - WebViewModelProtocol
extension WebViewModel: WebViewModelProtocol {
    
    func ObserveScroll(completion: @escaping(CGPoint)->Void) {
        
        var positionX = 0
        var positionY = 0
        var scrollPosition = ""
        
        NotificationCenter.default.addObserver(forName: Notification.Name("scroll"), object: nil, queue: .main) { notification in
            scrollPosition = notification.object as? String ?? ""
            
            print(scrollPosition)
            
            if scrollPosition == "вверх" {
                positionY -= 20
            } else if scrollPosition == "вниз" {
                positionY += 20
            }
            
            if scrollPosition.contains("лево") {
                positionX -= 10
            } else if scrollPosition.contains("право") {
                positionX += 10
            }
            
            completion(CGPoint(x: positionX, y: positionY))
        }
    }
    
    func ObserveActions(block: @escaping()->Void) {
        NotificationCenter.default.addObserver(forName: Notification.Name("close web"), object: nil, queue: nil) { _ in
            block()
        }
    }
    
    func SaveCurrentPage(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let page = RecentPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.SaveData(object: page, key: "last page") {
            print("сохранено: \(page)")
        }
    }
}
