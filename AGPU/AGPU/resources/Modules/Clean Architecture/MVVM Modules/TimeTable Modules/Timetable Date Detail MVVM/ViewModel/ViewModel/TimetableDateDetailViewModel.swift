//
//  TimetableDateDetailViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 24.02.2024.
//

import UIKit

class TimetableDateDetailViewModel {

    var timeTableHandler: ((TimeTableDateModel)->Void)?
    var pairs = [Discipline]()
    var allDisciplines: [Discipline] = []
    var type = PairType.all
    
    var id: String = ""
    var date: String = ""
    var owner: String = ""
    var subgroup: Int = 0
    var image: UIImage?
    
    var model = TimeTableChangesModel(id: "", date: "", owner: "", type: .all, subgroup: 0, filteredPairs: [], allPairs: [])
    
    // MARK: - сервисы
    let timeTableService = TimeTableService()
    let dateManager = DateManager()
    let realmManager = RealmManager()
    
    // MARK: - Init
    init(id: String, date: String, owner: String) {
        self.id = id
        self.date = date
        self.owner = owner
    }
}
