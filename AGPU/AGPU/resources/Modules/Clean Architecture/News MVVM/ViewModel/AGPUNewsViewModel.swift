//
//  AGPUNewsViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 07.07.2023.
//

import Foundation

class AGPUNewsViewModel {
    
    // MARK: - cервисы
    private let dateManager = DateManager()
    
    let faculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty")
    
    private var dateHandler: ((String)->Void)?
    
    func registerDateHandler(block: @escaping(String)->Void) {
        self.dateHandler = block
    }
    
    func GetDate() {
        DispatchQueue.main.async {
            self.dateHandler?("\(self.dateManager.getCurrentDate()) \(self.dateManager.getCurrentTime())")
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.dateHandler?("\(self.dateManager.getCurrentDate()) \(self.dateManager.getCurrentTime())")
        }
    }
    
    func registerScrollHandler(completion: @escaping(CGPoint)->Void) {
        
        var positionX = 0
        var positionY = 0
        var scrollPosition = ""
        
        NotificationCenter.default.addObserver(forName: Notification.Name("ScrollMainScreen"), object: nil, queue: .main) { notification in
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
    
    func registerFacultyHandler(completion: @escaping(AGPUFacultyModel)->Void) {
        
        NotificationCenter.default.addObserver(forName: Notification.Name("faculty"), object: nil, queue: .main) { notification in
            
            guard let faculty = notification.object as? AGPUFacultyModel else {return}
            
            completion(faculty)
        }
    }
}
