//
//  FacultyCathedraListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 25.07.2023.
//

import Foundation

protocol FacultyCathedraListViewModelProtocol {
    func cathedraListCount()-> Int
    func cathedraItem(index: Int)-> FacultyCathedraModel
    func selectCathedra(index: Int)
    func saveCathedra(cathedra: FacultyCathedraModel)
    func isCathedraSelected(index: Int)-> Bool
}
