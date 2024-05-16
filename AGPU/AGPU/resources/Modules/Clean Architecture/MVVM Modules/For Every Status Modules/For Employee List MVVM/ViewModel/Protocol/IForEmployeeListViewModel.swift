//
//  IForEmployeeListViewModel.swift
//  AGPU
//
//  Created by Марк Киричко on 16.05.2024.
//

import Foundation

protocol IForEmployeeListViewModel {
    func sectionItem(index: Int)-> ForEveryStatusModel
    func numberOfItemsInSection()-> Int
    func getData()
    func restartPosition()
    func saveSectionsPosition(_ index: Int, _ index2: Int)
    func registerDataChangedHandler(block: @escaping()->Void)
}
