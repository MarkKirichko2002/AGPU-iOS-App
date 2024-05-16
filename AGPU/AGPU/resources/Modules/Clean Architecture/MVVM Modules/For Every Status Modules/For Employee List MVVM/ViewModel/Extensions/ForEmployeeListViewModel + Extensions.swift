//
//  ForEmployeeListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 16.05.2024.
//

import Foundation

// MARK: - ForApplicantListViewModel
extension ForEmployeeListViewModel: IForEmployeeListViewModel {
    
    func sectionItem(index: Int)-> ForEveryStatusModel {
        return sections[index]
    }
    
    func numberOfItemsInSection()-> Int {
        return sections.count
    }
    
    func getData() {
        
        sections = ForEmployeeSections.sections
        
        let position = UserDefaults.standard.object(forKey: "for employee") as? [Int] ?? [0,1,2,3,4,5,6,7]
        
        for section in sections {
            for number in position {
                let index = sections.firstIndex(of: section)!
                print("индекс: \(index) позиция: \(number)")
                sections.swapAt(index, number)
            }
        }
        dataChangedHandler?()
    }
    
    func restartPosition() {
        
        let numbers = [0,1,2,3,4,5,6,7]
        
        UserDefaults.saveArray(array: numbers, key: "for employee") {
            self.getData()
        }
    }
    
    func saveSectionsPosition(_ index: Int, _ index2: Int) {
        
        var arr = sections
        
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
        
        UserDefaults.saveArray(array: numbers, key: "for employee") {
            self.getData()
        }
    }
    
    func registerDataChangedHandler(block: @escaping ()-> Void) {
        self.dataChangedHandler = block
    }
}
