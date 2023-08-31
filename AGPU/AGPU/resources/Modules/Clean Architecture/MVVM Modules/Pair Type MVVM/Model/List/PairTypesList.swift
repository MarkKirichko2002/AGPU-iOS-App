//
//  PairTypesList.swift
//  AGPU
//
//  Created by Марк Киричко on 31.08.2023.
//

import Foundation

struct PairTypesList {
    
    static let list = [
        
        PairTypeModel(
            name: "Все",
            type: .all),
        PairTypeModel(
            name: "Лекция",
            type: .lec),
        PairTypeModel(
            name: "Практика",
            type: .prac),
        PairTypeModel(
            name: "Экзамен",
            type: .exam),
        PairTypeModel(
            name: "Лабораторная",
            type: .lab),
        PairTypeModel(
            name: "Каникулы",
            type: .hol),
        PairTypeModel(
            name: "Зачёт",
            type: .cred),
        PairTypeModel(
            name: "ФЭПО",
            type: .fepo),
        PairTypeModel(
            name: "Консультация",
            type: .cons),
        PairTypeModel(
            name: "Неизвестно",
            type: .none)
    ]
}
