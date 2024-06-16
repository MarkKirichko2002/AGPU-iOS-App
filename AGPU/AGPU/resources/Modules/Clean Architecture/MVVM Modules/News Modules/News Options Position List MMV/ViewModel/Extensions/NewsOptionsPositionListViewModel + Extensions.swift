//
//  NewsOptionsPositionListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.06.2024.
//

import Foundation

// MARK: - INewsOptionsPositionListViewModel
extension NewsOptionsPositionListViewModel: INewsOptionsPositionListViewModel {
    
    func getData() {
        
        options = NewsOptions.list
        
        let position = UserDefaults.standard.object(forKey: "news options position") as? [Int] ?? [0,1,2,3,4,5,6,7]
        
        for option in options {
            for number in position {
                let index = options.firstIndex(of: option)!
                print("индекс: \(index) позиция: \(number)")
                options.swapAt(index, number)
            }
        }
        NotificationCenter.default.post(name: Notification.Name("news options position"), object: nil)
        dataChangedHandler?()
    }
    
    func saveNewsOptionsPosition(_ index: Int, _ index2: Int) {
        
        var arr = options
        
        arr.swapAt(index, index2)
        
        let index1 = arr.firstIndex { $0.id == 1 }
        let index2 = arr.firstIndex { $0.id == 2 }
        let index3 = arr.firstIndex { $0.id == 3 }
        let index4 = arr.firstIndex { $0.id == 4 }
        let index5 = arr.firstIndex { $0.id == 5 }
        let index6 = arr.firstIndex { $0.id == 6 }
        let index7 = arr.firstIndex { $0.id == 7 }
        let index8 = arr.firstIndex { $0.id == 8 }
        
        let numbers = [index1, index2, index3, index4, index5, index6, index7, index8]
        
        UserDefaults.saveArray(array: numbers, key: "news options position") {
            self.getData()
        }
    }
    
    func registerDataChangedHandler(block: @escaping()->Void) {
        self.dataChangedHandler = block
    }
}
