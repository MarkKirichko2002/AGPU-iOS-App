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
    
    func SelectCathedra(index: Int) {
        let cathedraItem = cathedraItem(index: index)
        if let Savedfaculty = UserDefaults.loadData(type: AGPUFacultyModel.self, key: "faculty") {
            if Savedfaculty.name == faculty.name {
                UserDefaults.SaveData(object: cathedraItem, key: "cathedra") {
                    print("сохранено")
                    self.isChanged.toggle()
                }
            } else {
                print("no \(faculty.name) != \(Savedfaculty.name)")
            }
        }
    }
    
    func isCathedraSelected(index: Int) -> UITableViewCell.AccessoryType {
        let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra")
        if cathedra?.name == cathedraItem(index: index).name {
            return .checkmark
        } else {
            return .none
        }
    }
    
    func isCathedraSelectedColor(index: Int)-> UIColor {
        let cathedra = UserDefaults.loadData(type: FacultyCathedraModel.self, key: "cathedra")
        if cathedra?.name == cathedraItem(index: index).name {
            return UIColor.systemGreen
        } else {
            return UIColor.black
        }
    }
}
