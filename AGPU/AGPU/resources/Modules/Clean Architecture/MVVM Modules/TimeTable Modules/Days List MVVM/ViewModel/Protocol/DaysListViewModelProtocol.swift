//
//  DaysListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 14.09.2023.
//

import Foundation

protocol DaysListViewModelProtocol {
    func setUpData()
    func getTimetableInfo()
    func chooseDay(index: Int)
    func checkDisciplinesExistence(index: Int)-> Bool
    func registerDataChangedHandler(block: @escaping()->Void)
}
