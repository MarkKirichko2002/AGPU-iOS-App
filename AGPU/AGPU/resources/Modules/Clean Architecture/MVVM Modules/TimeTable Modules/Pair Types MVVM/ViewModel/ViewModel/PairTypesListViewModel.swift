//
//  PairTypesListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 15.09.2023.
//

import Foundation

final class PairTypesListViewModel {
    
    var date: String
    var type: PairType
    var disciplines = [Discipline]()
    var allDisciplines = [Discipline]()
    
    // MARK: - сервисы
    let dateManager = DateManager()
    
    var pairTypeSelectedHandler: ((PairType)->Void)?
    
    // MARK: - Init
    init(date: String, type: PairType, disciplines: [Discipline]) {
        self.date = date
        self.type = type
        self.disciplines = disciplines
    }
}
