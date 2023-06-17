//
//  String + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2023.
//

import Foundation

extension String {
    
    func lastWord()-> String {
        let size = self.reversed().firstIndex(of: " ") ?? self.count
        let startWord = self.index(self.endIndex, offsetBy: -size)
        let last = self[startWord...]
        return String(last)
    }
}
