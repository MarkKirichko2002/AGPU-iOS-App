//
//  Array + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 05.12.2023.
//

import Foundation

extension Array {
    
    func deleteDuplicates<T: Equatable>(arr: [T])-> [T] {
        
        var filteredArray = [T]()
        
        for i in arr {
            if !filteredArray.contains(i) {
                filteredArray.append(i)
            }
        }
        
        return filteredArray
    }
}
