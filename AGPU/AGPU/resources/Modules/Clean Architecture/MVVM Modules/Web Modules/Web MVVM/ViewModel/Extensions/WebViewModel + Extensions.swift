//
//  WebViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 21.07.2023.
//

import UIKit

// MARK: - WebViewModelProtocol
extension WebViewModel: WebViewModelProtocol {
    
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
    
    func saveCurrentWebPage(url: String, position: CGPoint) {
        let dateManager = DateManager()
        let date = dateManager.getCurrentDate()
        let time = dateManager.getCurrentTime()
        let page = RecentWebPageModel(date: date, time: time, url: url, position: position)
        UserDefaults.saveData(object: page, key: "last page") {
            print("сохранено: \(page)")
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
}
