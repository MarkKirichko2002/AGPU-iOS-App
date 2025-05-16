//
//  String + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 12.06.2023.
//

import Foundation

extension String {
    
    func removeLastWords()-> String {
        if self.contains("(очная форма обучения)") {
            let modifiedStroke = self.replacingOccurrences(of: "(очная форма обучения)", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return modifiedStroke
        }
        if self.contains("(заочная форма обучения)") {
            let modifiedStroke = self.replacingOccurrences(of: "(заочная форма обучения)", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return modifiedStroke
        }
        return ""
    }
    
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
    
    func teacherAbbreviation()-> Self {
        let str = self.components(separatedBy: " ")
        let firstLetter =  String(str[1].first!)
        let secondLetter = String(str[2].first!)
        let result = "\(str[0]) \(firstLetter).\(secondLetter)."
        return result
    }
    
    func lastWord()-> String {
        let size = self.reversed().firstIndex(of: " ") ?? self.count
        let startWord = self.index(self.endIndex, offsetBy: -size)
        let last = String(self[startWord...])
        return last.lowercased()
    }
    
    func noWhitespacesWord()-> String {
        let words = self.components(separatedBy: .whitespaces)
        let slittedString = words.joined()
        return slittedString.lowercased()
    }
    
    func getCurrentTabName()-> String {
        let title = self
        if title == "news" {
            return "Новости"
        } else if title == "favourites" {
            return "Избранное"
        } else if title == "timetable" {
            return "Расписание"
        } else if title == "settings" {
            return "Настройки"
        } else if title == "maps" {
            return "Карты"
        } else if title == "sections" {
            return "Разделы"
        } else if title == "weeks" {
            return "Недели"
        } else if title == "weather" {
            return "Погода"
        } else {
            return ""
        }
    }
    
    func getDateFromString()-> String {
        var text = self
        if text.contains("-е") {
            text = text.replacingOccurrences(of: "-е", with: "")
        } else if text.contains("-го") {
            text = text.replacingOccurrences(of: "-го", with: "")
        } else if text.contains("-я") {
            text = text.replacingOccurrences(of: "-я", with: "")
        }
        let wordPattern = try! Regex("\\d+\\s+[а-яА-Я]+")
        if let match = try? wordPattern.firstMatch(in: text) {
            return String(match.0)
        }
        return ""
    }
    
    func getNumberFromString()-> String {
        
        var num = ""
        
        print(self)
        
        if self.contains("нуле") {
            num = "0"
        }
        
        if self.contains("перво") {
            num = "1"
        }
        
        if self.contains("второ") {
            num = "2"
        }
        
        if self.contains("треть") {
            num = "3"
        }
        
        if self.contains("четв") {
            num = "4"
        }
        
        if self.contains("пято") {
            num = "5"
        }
        
        if self.contains("шесто") {
            num = "6"
        }
        
        if self.contains("седьмо") {
            num = "7"
        }
        
        if self.contains("восьмо") {
            num = "8"
        }
        
        if self.contains("девято") {
            num = "9"
        }
        
        for char in self {
            if char.isNumber {
                num += String(char)
            }
        }
        return num
    }
    
    func updateDateDay(number: String)-> String {
        
        var arr = Array(self)
        
        if number.count == 2 {
            arr[0] = number[number.startIndex]
            arr[1] = number[number.index(after: number.startIndex)]
        } else if number.count <= 1 {
            arr[0] = Character("0")
            arr[1] = Character(number)
        }
        
        return String(arr)
    }
    
    func updateDateMonth(month: String)-> String {
        
        var arr = Array(self)
        
        if month.count == 2 {
            arr[3] = month[month.startIndex]
            arr[4] = month[month.index(after: month.startIndex)]
        } else if month.count <= 1 {
            arr[3] = Character("0")
            arr[4] = Character(month)
        }
        
        return String(arr)
    }
    
    func currentBuilding()-> String {
        for building in AGPUBuildings.buildings {
            if building.audiences.contains(self) {
                return building.name
            }
        }
        return ""
    }
}
