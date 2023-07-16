//
//  String + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2023.
//

import Foundation

extension String {
    
    func abbreviation()-> String {
        
        if self == "Аспирантура" {
            return self
        }
        
        var result = ""
        let modifiedStroke = self.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "-", with: " ")
        
        let sntns = modifiedStroke.components(separatedBy: "(")
        
        if modifiedStroke.lowercased().contains("исторический факультет") {
            result = "ИстФак"
        } else {
            let words = sntns[0].components(separatedBy: " ")
            for word in words {
                if word.count == 1 {
                    result += word.lowercased()
                } else {
                    result += String(word.uppercased().prefix(1))
                }
            }
        }
        
        if self.contains("(") {
            result += " ("
        }
        
        for i in 1..<sntns.count {
            result += sntns[i]
        }
        
        return result
        
        
    }
    
    func lastWord()-> String {
        let size = self.reversed().firstIndex(of: " ") ?? self.count
        let startWord = self.index(self.endIndex, offsetBy: -size)
        let last = String(self[startWord...])
        return last
    }
    
    func noWhitespacesWord()-> String {
        let words = self.components(separatedBy: .whitespaces)
        let slittedString = words.joined()
        return slittedString.lowercased()
    }
}
