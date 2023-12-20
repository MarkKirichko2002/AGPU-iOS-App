//
//  FacultyCathedraListViewModel + Extensions.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import UIKit

// MARK: - FacultyCathedraListViewModelProtocol
extension FacultyCathedraListViewModel: FacultyCathedraListViewModelProtocol {
    
    func cathedraListCount()-> Int {
        return 2
    }
    
    func cathedraItem(index: Int) -> FacultyCathedraModel {
        return faculty.cathedra[index]
    }
    
    func selectCathedra(index: Int) {
        let cathedraItem = cathedraItem(index: index)
        guard let savedCathedra = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") else {return}
        if savedCathedra.name != cathedraItem.name {
            UserDefaults.saveData(object: cathedraItem, key: "cathedra") {
                print("сохранено")
                self.isChanged.toggle()
                HapticsManager.shared.hapticFeedback()
            }
        }
    }
    
    func isCathedraSelected(index: Int)-> Bool {
        let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra")
        if cathedra?.name == cathedraItem(index: index).name {
            return true
        } else {
            return false
        }
    }
}
