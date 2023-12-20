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
        if let savedCathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra") {
            if savedCathedra.name != cathedraItem.name  {
                saveCathedra(cathedra: cathedraItem)
            }
        } else {
            saveCathedra(cathedra: cathedraItem)
        }
    }
    
    func saveCathedra(cathedra: FacultyCathedraModel) {
        UserDefaults.saveData(object: cathedra, key: "cathedra") {
            print("сохранено")
            self.isChanged.toggle()
            HapticsManager.shared.hapticFeedback()
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
