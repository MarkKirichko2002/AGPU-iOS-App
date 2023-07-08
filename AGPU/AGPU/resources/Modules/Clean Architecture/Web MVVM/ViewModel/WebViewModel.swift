//
//  WebViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

class WebViewModel {
    
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
    
    func SavePosition(position: CGPoint) {
        UserDefaults.SaveData(object: position, key: "last position") {
            print("сохранено: \(position)")
        }
    }
    
    func SaveCurrentPage(page: RecentPageModel) {
        UserDefaults.SaveData(object: page, key: "last page") {
            print("сохранено")
        }
    }
}
