//
//  TimetableSettingsListViewModelProtocol.swift
//  AGPU
//
//  Created by Марк Киричко on 19.11.2023.
//

import Foundation

protocol TimetableSettingsListViewModelProtocol {
    func getAllData()
    func getSavedFaculty()-> AGPUFacultyModel?
    func getSavedGroup()-> String
    func getSavedSubGroup()-> Int
    func getSavedPairType()-> PairType
    func observeOptionSelection()
    func registerDataChangedHandler(block: @escaping()->Void)
}
